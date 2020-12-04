source('R/packages.R')
source('R/functions.R')
source('R/tables-phase2.R')

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
  select(-geometry)

##now lets get our watersheds
hab_site_fwa_wshds <- get_watershed(dat = hab_site_fwa_index)
