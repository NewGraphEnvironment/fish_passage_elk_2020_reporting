library(tabulizer)
library(tidyverse)

##maske the tables for the methods

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


