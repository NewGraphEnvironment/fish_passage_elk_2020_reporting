##i want to make a table that looks just like the field data collection form
source('R/functions.R')
source('R/packages.R')
source('R/private_info.R')

##make a dataframe to pull info from the db
##we should probably break each row out and determine the crs by the utm_zone attribute
df <- import_pscis(workbook_name = 'pscis_phase1.xlsm') %>%
  sf::st_as_sf(coords = c("easting", "northing"),
               crs = 26911, remove = F) %>%
  sf::st_transform(crs = 3005) ##convert to match the bcbarriers format


##get the road info from the database
conn <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = dbname,
  host = host,
  port = port,
  user = user,
  password = password
)


##list tables in a schema
# dbGetQuery(conn,
#            "SELECT table_name
#            FROM information_schema.tables
#            WHERE table_schema='ali'")
# dbSendQuery(conn, paste0("DROP TABLE IF EXISTS ", "ali.test",";"))

# add a unique id - we could just use the reference number
df$misc_point_id <- seq.int(nrow(df))

dbSendQuery(conn, paste0("CREATE SCHEMA IF NOT EXISTS ", "ali",";"))
# load to database
sf::st_write(obj = df, dsn = conn, Id(schema= "ali", table = "misc"))



# sf doesn't automagically create a spatial index or a primary key
res <- dbSendQuery(conn, "CREATE INDEX ON ali.misc USING GIST (geometry)")
dbClearResult(res)
res <- dbSendQuery(conn, "ALTER TABLE ali.misc ADD PRIMARY KEY (misc_point_id)")
dbClearResult(res)

df_info <- dbGetQuery(conn, "SELECT
  a.misc_point_id,
  b.*,
  ST_Distance(ST_Transform(a.geometry,3005), b.geom) AS distance
FROM
  ali.misc AS a
CROSS JOIN LATERAL
  (SELECT *
   FROM fish_passage.modelled_crossings_closed_bottom
   ORDER BY
     a.geometry <-> geom
   LIMIT 1) AS b")

df_joined <- left_join(
  df,
  df_info,
  by = "misc_point_id"
) %>%
  mutate(downstream_route_measure = as.integer(downstream_route_measure))

dbDisconnect(conn = conn)

