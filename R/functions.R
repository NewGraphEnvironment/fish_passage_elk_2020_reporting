
##function to trim up sheet and get names (was previously source from altools package)
at_trim_xlsheet2 <- function(df, column_last = ncol(df)) {
  df %>%
    dplyr::select(1:column_last) %>% ##get rid of the extra columns.  should be more abstract
    janitor::row_to_names(which.max(complete.cases(.))) %>%
    janitor::clean_names() %>%
    janitor::remove_empty(., which = "rows")
}


##function to import pscis info
import_pscis <- function(workbook_name = 'pscis_phase1.xlsm'){ ##new template.  could change file back to .xls
  readxl::read_excel(path = paste0(getwd(),"/data/", workbook_name),
                     sheet = 'PSCIS Assessment Worksheet') %>%
    # purrr::set_names(janitor::make_clean_names(names(.))) %>%
    at_trim_xlsheet2() %>% ##recently added function above and pulled the altools package as it was a week link
    rename(date = date_of_assessment_yyyy_mm_dd) %>%
    mutate(date = janitor::excel_numeric_to_date(as.numeric(date))) %>%
    filter(!is.na(date)) %>%
    readr::type_convert()  ##guess the type!!
}


# make_photo_comp_cv <- function(site_id){
#   photos_images1 <- list.files(path = paste0(getwd(), '/data/photos/', site_id), full.names = T) %>%
#     stringr::str_subset(., 'barrel|outlet|upstream') %>%
#     image_read()
#   photos_images2 <- list.files(path = paste0(getwd(), '/data/photos/', site_id), full.names = T) %>%
#     stringr::str_subset(., 'downstream|road|inlet') %>%
#     image_read()
#   photos_stack1 <-image_append(image_scale(photos_images1, "x420")) ##1/3 the width 373.33 and half the original height
#   photos_stack2 <- image_append(image_scale(photos_images2, "x420"))
#   photos_stack <- c(photos_stack1, photos_stack2)
#   photos_stacked <- image_append(image_scale(photos_stack), stack = T)
#   image_write(photos_stacked, path = paste0(getwd(), '/data/photos/', site_id, '/crossing_all.JPG'), format = 'jpg')
# }

##here we stack up and down then side to side for reporting - this works!
make_photo_comp_cv <- function(site_id){
  photos_images1 <- list.files(path = paste0(getwd(), '/data/photos/', site_id), full.names = T) %>%
    stringr::str_subset(., 'barrel|outlet|upstream') %>%
    image_read()
  photos_images2 <- list.files(path = paste0(getwd(), '/data/photos/', site_id), full.names = T) %>%
    stringr::str_subset(., 'downstream|road|inlet') %>%
    image_read()
  photos_stack1 <-image_append(image_scale(photos_images1, "x420"), stack = T) ##1/3 the width 373.33 and half the original height
  photos_stack2 <- image_append(image_scale(photos_images2, "x420"), stack = T)
  photos_stack <- c(photos_stack1, photos_stack2)
  photos_stacked <- image_append(image_scale(photos_stack), stack = F)
  image_write(photos_stacked, path = paste0(getwd(), '/data/photos/', site_id, '/crossing_all.JPG'), format = 'jpg')
}

##make a function to retrieve the watershed info
get_watershed <- function(fish_habitat_info){
  mapply(fwapgr::fwa_watershed, blue_line_key = fish_habitat_info$blue_line_key,
         downstream_route_measure = fish_habitat_info$downstream_route_measure) %>%
    purrr::set_names(nm = fish_habitat_info$pscis_model_combined_id) %>%
    discard(function(x) nrow(x) == 0) %>% ##remove zero row tibbles with https://stackoverflow.com/questions/49696392/remove-list-elements-that-are-zero-row-tibbles
    data.table::rbindlist(idcol="pscis_model_combined_id") %>%
    distinct(pscis_model_combined_id, .keep_all = T) %>% ##there are duplicates we should get rid of
    st_as_sf()
}


