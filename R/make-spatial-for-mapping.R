source('R/packages.R')
source('R/functions.R')
source('R/tables.R')


##make your geopackage for mapping
make_geopackage <- function(dat, gpkg_name = 'habitat_confirmations'){
  nm <-deparse(substitute(dat))
  dat %>%
    sf::st_as_sf(coords = c("utm_easting", "utm_northing"), crs = 26911, remove = F) %>%
    st_transform(crs = 4326) %>%
    sf::st_write(paste0("./data/", gpkg_name, ".gpkg"), nm, append = TRUE)
}

make_geopackage(dat = hab_fish_collect)
make_geopackage(dat = hab_features)
make_geopackage(dat = hab_site_priorities)
