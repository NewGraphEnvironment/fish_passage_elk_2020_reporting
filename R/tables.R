source('R/packages.R')
source('R/functions.R')

####---------------import pscis data----------------
pscis <- import_pscis() %>%
  arrange(my_crossing_reference)



#------------------make the tables for the methods----------
tab_barrier_scoring <- dplyr::tribble(
  ~Risk,   ~Embedded,                                 ~Value,  ~`Outlet Drop (cm)`, ~Value, ~SWR,    ~Value, ~`Slope (%)`, ~Value, ~`Length (m)`, ~Value,
  "LOW",  ">30cm or >20% of diameter and continuous",  "0",       "<15",              '0',  '<1.0',    '0',      '<1',      '0',     '<15',         '0',
  "MOD",  "<30cm or 20% of diameter but continuous",   "5",       "15-30",            '5',  '1.0-1.3', '3',      '1-3',     '5',     '15-30',       '3',
  "HIGH", "No embedment or discontinuous",             "10",      ">30",             '10',  '>1.3',    '6',       '>3',     '10',    '>30',         '6',
)

tab_barrier_result <- dplyr::tribble(
  ~`Cumlative Score`, ~Result,
  '0-14',             'passable',
  '15-19',            'potential barrier',
  '>20',              'barrier'
)

# names_bcdata <- names(d) %>%
#   stringr::str_to_lower() %>%
#   dplyr::as_tibble() %>%
#   # dplyr::slice(-1:-7) %>%
#   mutate(report_names = 'report_names') %>%
#   tibble::rowid_to_column() %>%
#   select(value, rowid, report_names)

##there is a bunch hashed out becasue we don't need to repeat this proces anynore.  good to know for the future though

##make a lookup table to pull out the pscis barrier info and present in the report
##first we pull out the data from the provincial catalougue.  We will filter for our project later
# bcdata::bcdc_browse()
# d <- bcdata::bcdc_get_data('7ecfafa6-5e18-48cd-8d9b-eae5b5ea2881') ###aka 'pscis-assessments'
# names_pscis_spreadsheet <- import_pscis() %>%
#   names() %>%
#   dplyr::as_tibble() %>%
#   mutate(test = value)

# ##make a table to cross reference the names from bcdata catalouge with the names for our report with the names of our input spreadsheet
# names_bcdata <- names(d) %>%
#   stringr::str_to_lower() %>%
#   dplyr::as_tibble() %>%
  # dplyr::slice(-1:-7)
#   # dplyr::rename(value_bcdata = value)



####---------make a table to cross reference column names for ---------------
tab_xref_names <- tibble::tribble(
                          ~bcdata,                               ~spdsht,               ~report, ~id_join, ~id_side,
                             "id",                                    NA,                    NA,       NA,       NA,
         "funding_project_number",                                    NA,                    NA,       NA,       NA,
                "funding_project",                                    NA,                    NA,       NA,       NA,
                     "project_id",                                    NA,                    NA,       NA,       NA,
                 "funding_source",                                    NA,                    NA,       NA,       NA,
         "responsible_party_name",                                    NA,                    NA,       NA,       NA,
                "consultant_name",                                    NA,                    NA,       NA,       NA,
                "assessment_date",                                'date',                'Date',       1L,       1L,
             "stream_crossing_id",                   "pscis_crossing_id",            "PSCIS ID",       2L,       1L,
                  "assessment_id",                                    NA,                    NA,       NA,       NA,
    "external_crossing_reference",               "my_crossing_reference",         "Modelled ID",       3L,       1L,
                   "crew_members",                        "crew_members",                "Crew",       5L,       1L,
                       "utm_zone",                            "utm_zone",            "UTM Zone",       6L,       1L,
                    "utm_easting",                             "easting",             "Easting",       7L,       1L,
                   "utm_northing",                            "northing",            "Northing",       8L,       1L,
        "location_confidence_ind",                                    NA,                    NA,       NA,       NA,
                    "stream_name",                         "stream_name",              "Stream",       9L,       1L,
                      "road_name",                           "road_name",                "Road",       10L,      1L,
                   "road_km_mark",                        "road_km_mark",                    NA,       NA,       NA,
                    "road_tenure",                         "road_tenure",         "Road Tenure",       11L,       1L,
             "crossing_type_code",                       "crossing_type",       "Crossing Type",       NA,       NA,
             "crossing_type_desc",                                    NA,                    NA,       NA,       NA,
          "crossing_subtype_code",                    "crossing_subtype",   "Crossing Sub Type",       1L,       2L,
          "crossing_subtype_desc",                                    NA,                    NA,       NA,       NA,
               "diameter_or_span",             "diameter_or_span_meters",            "Diameter",       2L,       2L,
                "length_or_width",              "length_or_width_meters",              "Length",       3L,       2L,
    "continuous_embeddedment_ind",      "continuous_embeddedment_yes_no",               "Embed",       5L,       2L,
     "average_depth_embededdment",   "average_depth_embededdment_meters",      "Depth Embedded",       6L,       2L,
           "resemble_channel_ind",             "resemble_channel_yes_no",    "Resemble Channel",       7L,       2L,
                "backwatered_ind",                  "backwatered_yes_no",         "Backwatered",       8L,       2L,
         "percentage_backwatered",              "percentage_backwatered", "Percent Backwatered",       9L,       2L,
                     "fill_depth",                   "fill_depth_meters",          "Fill Depth",       10L,       2L,
                    "outlet_drop",                  "outlet_drop_meters",         "Outlet Drop",       11L,       2L,
              "outlet_pool_depth",             "outlet_pool_depth_0_01m",   "Outlet Pool Depth",       12L,       2L,
                 "inlet_drop_ind",                   "inlet_drop_yes_no",          "Inlet Drop",       13L,       2L,
                  "culvert_slope",               "culvert_slope_percent",               "Slope",       14L,       2L,
       "downstream_channel_width",     "downstream_channel_width_meters",       "Channel Width",       12L,       1L,
                   "stream_slope",                        "stream_slope",        "Stream Slope",       13L,       1L,
            "beaver_activity_ind",              "beaver_activity_yes_no",     "Beaver Activity",       14L,       1L,
              "fish_observed_ind",                "fish_observed_yes_no",        "Fish Sighted",       NA,       NA,
               "valley_fill_code",                         "valley_fill",         "Valley Fill",       15L,       2L,
          "valley_fill_code_desc",                                    NA,                    NA,       NA,       NA,
             "habitat_value_code",                       "habitat_value",       "Habitat Value",       15L,       1L,
             "habitat_value_desc",                                    NA,                    NA,       NA,       NA,
             "stream_width_ratio",                  "stream_width_ratio",                 "SWR",       NA,       NA,
       "stream_width_ratio_score",                                    NA,               "Score",       NA,       NA,
           "culvert_length_score",                "culvert_length_score",               "Score",       NA,       NA,
                    "embed_score",                         "embed_score",               "Score",       NA,       NA,
              "outlet_drop_score",                   "outlet_drop_score",               "Score",       NA,       NA,
            "culvert_slope_score",                 "culvert_slope_score",               "Score",       NA,       NA,
                    "final_score",                         "final_score",         "Total Score",       NA,       NA,
            "barrier_result_code",                      "barrier_result",              "Result",       NA,       NA,
     "barrier_result_description",                                    NA,                    NA,       NA,       NA,
              "crossing_fix_code",                        "crossing_fix",         "Culvert Fix",       NA,       NA,
              "crossing_fix_desc",                                    NA,                    NA,       NA,       NA,
   "recommended_diameter_or_span", "recommended_diameter_or_span_meters", "Fix Span / Diameter",       NA,       NA,
             "assessment_comment",                  "assessment_comment",             "Comment",       NA,       NA,
                     "ecocat_url",                                    NA,                    NA,       NA,       NA,
                 "image_view_url",                                    NA,                    NA,       NA,       NA,
           "current_pscis_status",                                    NA,                    NA,       NA,       NA,
     "current_crossing_type_code",                                    NA,                    NA,       NA,       NA,
     "current_crossing_type_desc",                                    NA,                    NA,       NA,       NA,
  "current_crossing_subtype_code",                                    NA,                    NA,       NA,       NA,
  "current_crossing_subtype_desc",                                    NA,                    NA,       NA,       NA,
    "current_barrier_result_code",                                    NA,                    NA,       NA,       NA,
    "current_barrier_description",                                    NA,                    NA,       NA,       NA,
                   "feature_code",                                    NA,                    NA,       NA,       NA,
                       "objectid",                                    NA,                    NA,       NA,       NA,
               "se_anno_cad_data",                                    NA,                    NA,       NA,       NA,
                       "geometry",                                    NA,                    NA,       NA,       NA
  )


####------------make a table to summarize priorization of phase 1 sites
phase1_priorities <- pscis %>%
  select(my_crossing_reference, utm_zone:northing, habitat_value, barrier_result) %>%
  mutate(priority_phase1 = case_when(habitat_value == 'High' & barrier_result != 'Passable' ~ 'high',
                                     habitat_value == 'Medium' & barrier_result != 'Passable' ~ 'mod',
                                     habitat_value == 'Low' & barrier_result != 'Passable' ~ 'low',
                                     T ~ NA_character_)) %>%
  mutate(priority_phase1 = case_when(habitat_value == 'High' & barrier_result == 'Potential' ~ 'mod',
                                     T ~ priority_phase1)) %>%
  mutate(priority_phase1 = case_when(habitat_value == 'Medium' & barrier_result == 'Potential' ~ 'low',
                                     T ~ priority_phase1)) %>%
  mutate(priority_phase1 = case_when(my_crossing_reference == 4600070 ~ 'high', ##very large watershed
                                     my_crossing_reference == 4600039 ~ 'low', ##does not seem like much of barrier
                                     my_crossing_reference == 4604198 ~ 'low', ##very steep
                                     my_crossing_reference == 4605653 ~ 'low', ##does not seem like much of barrier
                                     my_crossing_reference == 4605675 ~ 'low', ##does not seem like much of barrier
                                     T ~ priority_phase1)) %>%
  dplyr::rename(utm_easting = easting, utm_northing = northing)


####---------------make a table for the comments---------------
make_tab_summary_comments <- function(df){
  df %>%
  select(assessment_comment) %>%
  # slice(1) %>%
  set_names('Comment')
}

####---------------make the report table-----
##grab a df with the names of the left hand side of the table
make_tab_summary <- function(df){
  tab_results_left <- tab_xref_names %>%
    filter(id_side == 1)
  ##get the data
  tab_pull_left <- df %>%
    select(pull(tab_results_left,spdsht)) %>%
    # slice(1) %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column()

  left <- left_join(tab_pull_left, tab_xref_names, by = c('rowname' = 'spdsht'))

  tab_results_right <- tab_xref_names %>%
    filter(id_side == 2)

  ##get the data
  tab_pull_right<- pscis %>%
    select(pull(tab_results_right,spdsht)) %>%
    # slice(1) %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column()

  right <- left_join(tab_pull_right, tab_xref_names, by = c('rowname' = 'spdsht'))

  tab_joined <- left_join(
    select(left, report, V1, id_join),
    select(right, report, V1, id_join),
    by = 'id_join'
  ) %>%
    select(-id_join) %>%
    purrr::set_names(c('Location and Stream Data', '-', 'Crossing Characteristics', '--'))
  return(tab_joined)
}

##turn spreadsheet into list of data frames
pscis_split <- pscis %>%
  # tibble::rownames_to_column() %>%
  dplyr::group_split(my_crossing_reference) %>%
  purrr::set_names(pscis$my_crossing_reference)

##make result summary tables for each of the crossings
tab_summary <- pscis_split %>%
  purrr::map(make_tab_summary)

tab_summary_comments <- pscis_split %>%
  purrr::map(make_tab_summary_comments)


####------------------make a table for the cost estimates.  It should have an equation.--------------


####-----------make a table with just the photos in it so you can add as a footnote - should combine with commetns I think-------
##get list of files (site_ids) in the photo folder
tab_photo_url <- list.files(path = paste0(getwd(), '/data/photos/'), full.names = T) %>%
  basename() %>%
  as_tibble() %>%
  mutate(value = as.integer(value)) %>% ##need this to sort
  dplyr::arrange(value)  %>%
  mutate(photo = paste0('![](https://github.com/NewGraphEnvironment/', basename(getwd()), '/raw/master/data/photos/', value, '/crossing_all.JPG)')) %>%
  filter(value %in% pscis$my_crossing_reference) %>% ##we don't want all the photos - just the phase 1 photos for this use case!!!
  dplyr::group_split(value) %>%
  purrr::set_names(nm = pscis$my_crossing_reference)

####--------------bring in the habitat and fish data------------------
habitat_confirmations <-  readxl::excel_sheets(path = "./data/habitat_confirmations.xls") %>%
  purrr::set_names() %>%
  purrr::map(read_excel,
             path = "./data/habitat_confirmations.xls",
             .name_repair = janitor::make_clean_names) %>%
  purrr::set_names(janitor::make_clean_names(names(.))) %>%
  purrr::map(at_trim_xlsheet2) %>% #moved to functions from https://github.com/NewGraphEnvironment/altools to reduce dependencies
  purrr::map(plyr::colwise(type.convert))


hab_site_prep <-  habitat_confirmations %>%
  purrr::pluck("step_4_stream_site_data") %>%
  # tidyr::separate(local_name, into = c('site', 'location'), remove = F) %>%
  mutate(average_gradient_percent = round(average_gradient_percent * 100, 1)) %>%
  mutate_if(is.numeric, round, 1) %>%
  select(-gazetted_names:-site_number, -feature_type:-utm_method) ##remove the feature utms so they don't conflict with the site utms

hab_loc <- habitat_confirmations %>%
  purrr::pluck("step_1_ref_and_loc_info") %>%
  dplyr::filter(!is.na(site_number))%>%
  mutate(survey_date = janitor::excel_numeric_to_date(as.numeric(survey_date)))

hab_site <- left_join(
  hab_loc,
  hab_site_prep,
  by = 'reference_number'
) %>%
  tidyr::separate(alias_local_name, into = c('site', 'location'), remove = F) %>%
  dplyr::filter(!alias_local_name %like% '_ef') ##get rid of the ef sites

hab_fish_collect_prep <- habitat_confirmations %>%
  purrr::pluck("step_2_fish_coll_data") %>%
  dplyr::filter(!is.na(site_number)) %>%
  select(-gazetted_name:-site_number)

# hab_fish_indiv_prep <- habitat_confirmations %>%
#   purrr::pluck("step_3_individual_fish_data") %>%
#   dplyr::filter(!is.na(site_number)) %>%
#   select(-gazetted_names:-site_number)

hab_fish_codes <- habitat_confirmations %>%
  purrr::pluck("species_by_common_name") %>%
  select(-step)

# hab_fish_indiv_prep2 <- left_join(
#   hab_fish_indiv_prep,
#   hab_loc,
#   by = 'reference_number'
# )

hab_fish_collect_prep2 <- left_join(
  hab_fish_collect_prep,
  hab_loc,
  by = 'reference_number'
)


# hab_fish_indiv <- left_join(
#   hab_fish_indiv_prep2,
#   select(hab_fish_codes, common_name:species_code),
#   by = c('species' = 'common_name')
# ) %>%
#   dplyr::distinct(alias_local_name, utm_zone, utm_easting, utm_northing, species_code)

hab_fish_collect <- left_join(
  hab_fish_collect_prep2,
  select(hab_fish_codes, common_name:species_code),
  by = c('species' = 'common_name')
) %>%
  dplyr::distinct(reference_number, alias_local_name, utm_zone, utm_easting, utm_northing, species_code)


hab_features <- habitat_confirmations %>%
  purrr::pluck("step_4_stream_site_data") %>%
  select(feature_type:utm_northing) %>%
  filter(!is.na(feature_type))


####--------import priorities spreadsheet--------------
habitat_confirmations_priorities <- readxl::read_excel(
  path = "./data/habitat_confirmations_priorities.xlsx",
  .name_repair = janitor::make_clean_names)


##add the priorities to the site data
hab_site_priorities <- left_join(
  select(habitat_confirmations_priorities, reference_number, priority),
  select(hab_site, reference_number, alias_local_name, site, utm_zone:utm_northing),
  by = 'reference_number'
) %>%
  filter(!is.na(priority))


##clean up the objects
rm(hab_site_prep,
   # hab_fish_indiv_prep,
   # hab_fish_indiv_prep2,
   hab_fish_collect_prep,
   hab_fish_collect_prep2)





