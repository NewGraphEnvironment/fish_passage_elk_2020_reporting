source('R/packages.R')
source('R/functions.R')
source('R/tables-phase2.R')
source('R/tables.R')

##make your geopackage for mapping
make_geopackage <- function(dat, gpkg_name = 'fishpass_mapping'){
  nm <-deparse(substitute(dat))
  dat %>%
    sf::st_as_sf(coords = c("utm_easting", "utm_northing"), crs = 26911, remove = F) %>%
    st_transform(crs = 3005) %>%
    sf::st_write(paste0("./data/", gpkg_name, ".gpkg"), nm, append = TRUE)
}

# ##just scab together the new id's with the old ones to save time
# ##this is built with load-crossings-xref.R file
# xref_pscis_my_crossing_modelled <- readr::read_csv(file = paste0(getwd(), '/data/raw_input/xref_pscis_my_crossing_modelled.csv')) %>%
#   mutate(across(everything(), as.integer))

phase1_priorities <- left_join(
  phase1_priorities,
  select(xref_pscis_my_crossing_modelled, my_crossing_reference, stream_crossing_id),
  by = 'my_crossing_reference'
)

make_geopackage(dat = hab_fish_collect)
make_geopackage(dat = hab_features)
make_geopackage(dat = hab_site_priorities)
make_geopackage(dat = phase1_priorities)

##add the tracks
sf::read_sf("./data/habitat_confirmation_tracks.gpx", layer = "tracks") %>%
  sf::st_write(paste0("./data/", 'fishpass_mapping', ".gpkg"), 'hab_tracks', append = TRUE)

####------------add the watersheds-------------------------

##having the watersheds derived is nice so lets try
##make a function to retrieve the watershed info
get_watershed <- function(dat){
  mapply(fwapgr::fwa_watershed_at_measure,
         blue_line_key = dat$blue_line_key,
         downstream_route_measure = dat$downstream_route_measure,
         SIMPLIFY = F) %>%
    purrr::set_names(nm = dat$alias_local_name) %>%
    discard(function(x) nrow(x) == 0) %>% ##remove zero row tibbles with https://stackoverflow.com/questions/49696392/remove-list-elements-that-are-zero-row-tibbles
    data.table::rbindlist(idcol="alias_local_name") %>%
    distinct(alias_local_name, .keep_all = T) %>% ##there are duplicates we should get rid of
    st_as_sf()
}

##for each site grab a blueline key and downstream route measure
hab_site_priorities2 <- hab_site_priorities %>%
  mutate(srid = as.integer(26911),
         limit = as.integer(1))

hab_site_fwa_index <- mapply(fwapgr::fwa_index_point,
                             x = hab_site_priorities2$utm_easting,
                             y = hab_site_priorities2$utm_northing,
                             srid = hab_site_priorities2$srid,
                             SIMPLIFY = F) %>%
  purrr::set_names(nm = hab_site_priorities2$alias_local_name) %>%
  data.table::rbindlist(idcol="alias_local_name") %>%
  st_as_sf()

##now lets get our watersheds
hab_site_fwa_wshds <- get_watershed(dat = hab_site_fwa_index)


##add to the geopackage
hab_site_fwa_wshds %>%
  sf::st_write(paste0("./data/", 'fishpass_mapping', ".gpkg"), 'hab_wshds', append = TRUE)

hab_site_fwa_index %>%
  sf::st_write(paste0("./data/", 'fishpass_mapping', ".gpkg"), 'hab_fwa_index', append = TRUE)



