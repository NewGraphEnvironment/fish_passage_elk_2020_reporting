##this is to give to simon as qa for the modelled vs. pscis crossings

pscis_modelledcrossings_streams_xref_QA <- dat_after_review %>%
  filter(!is.na(modelled_crossing_id_corr) | my_text == 'bridge') %>%
  mutate(structure = case_when(my_text == 'bridge' ~ 'OBS', T ~ NA_character_)) %>%
  select(stream_crossing_id, modelled_crossing_id, modelled_crossing_id_corr, linear_feature_id,reviewer, structure, notes = my_text) %>%
  sf::st_drop_geometry()


pscis_modelledcrossings_streams_xref <-   dat_after_review %>%
  filter(!is.na(modelled_crossing_id_corr)) %>%
  mutate(reviewer = 'AI') %>%
  select(stream_crossing_id, modelled_crossing_id = modelled_crossing_id_corr, linear_feature_id, reviewer, notes = my_text) %>%
  sf::st_drop_geometry() %>%
  readr::write_csv(file = 'data/raw_input/pscis_modelledcrossings_streams_xref.csv')


modelled_stream_crossings_fixes <-  dat_after_review %>%
  filter(my_text == 'bridge') %>%
  mutate(reviewer = 'AI') %>%
  mutate(structure = case_when(my_text == 'bridge' ~ 'OBS', T ~ NA_character_)) %>%
  select(modelled_crossing_id, watershed_group_code, reviewer, structure, notes = my_text) %>%
  sf::st_drop_geometry() %>%
  readr::write_csv(file = 'data/raw_input/modelled_stream_crossings_fixes_al.csv')

