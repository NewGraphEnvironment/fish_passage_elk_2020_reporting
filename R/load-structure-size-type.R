##figure out how big of a structure to use.
##cost estimates
source('R/packages.R')
source('R/functions.R')


pscis <- import_pscis() %>%
  tibble::rownames_to_column() %>%
  mutate(rowname = as.numeric(rowname)) %>%
  mutate(column_num = rowname + 4)

##assign a value that we want to call standard fill
fill_dpth <- 3

##assign a multiplier to determine the length of a bridge above the standard
##that you get when you go deeper


##standard bridge width - we go with 10m
brdg_wdth <- 10

##% bigger than the channel that the bridge should be
chn_wdth_max <- 5



##fill depth multiplier
##for every 1 m deeper than 3m, we need a 1.5:1 slope so there is 3m more bridge required
fill_dpth_mult <- 3

####----------backwater candidates------------------
##backwatering required od<30 and slope <2, swr <1.2 see if there are options
tab_backwater <- pscis %>%
  filter(barrier_result != 'Passable' &
           barrier_result != 'Unknown' &
           outlet_drop_meters < 0.3 &
           stream_width_ratio_score < 1.2 &
           culvert_slope_percent <= 2 )

str_type <- pscis %>%
  select(column_num, my_crossing_reference, downstream_channel_width_meters, fill_depth_meters) %>%
  mutate(fill_dpth_over = fill_depth_meters - fill_dpth_mult) %>%
  mutate(span_input = case_when(downstream_channel_width_meters >= 2 ~ brdg_wdth))  %>%
  mutate(span_input = case_when(fill_dpth_over > 0 ~
                                      (brg_wdth_input + fill_dpth_mult * fill_dpth_over),  ##1m more fill = 3 m more bridge
                                    T ~ brg_wdth_input)) %>%
  mutate(span_input = case_when(downstream_channel_width_meters > 5 ~
                                      (downstream_channel_width_meters - chn_wdth_max) * 2 + brdg_wdth,  ##for every m bigger than a 5 m channel add that much to each side in terms of span
                                    T ~ brg_wdth_input))




