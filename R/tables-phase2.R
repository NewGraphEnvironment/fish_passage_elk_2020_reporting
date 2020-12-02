source('R/packages.R')
source('R/functions.R')
source('R/tables.R')



##pupose here is to put all the habitat data into one place so that we can spit out
##individual write-ups

pscis <- import_pscis(workbook_name = 'pscis_phase2.xlsm') %>%
  tibble::rownames_to_column() %>%
  arrange(my_crossing_reference)

xref_pscis_my_crossing_modelled %>%
  filter(my_crossing_reference %in% c(4605732, 4600070, 4600183))



##having the watersheds derived is nice so lets try
##make a function to retrieve the watershed info
get_watershed <- function(fish_habitat_info){
  mapply(fwapgr::fwa_watershed_at_measure, blue_line_key = fish_habitat_info$blue_line_key,
         downstream_route_measure = fish_habitat_info$downstream_route_measure) %>%
    purrr::set_names(nm = fish_habitat_info$pscis_model_combined_id) %>%
    discard(function(x) nrow(x) == 0) %>% ##remove zero row tibbles with https://stackoverflow.com/questions/49696392/remove-list-elements-that-are-zero-row-tibbles
    data.table::rbindlist(idcol="pscis_model_combined_id") %>%
    distinct(pscis_model_combined_id, .keep_all = T) %>% ##there are duplicates we should get rid of
    st_as_sf()
}
