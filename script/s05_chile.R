############################
#
#
# author  : Chris Yong
# date    : 20/4/2025
# preamble: obtain table of solar produced returns from
#           Chile for prong-1's table 1
# 
# source  : https://www.iea.org/countries/chile/renewables
#
#
############################

#                                  #
#                                  #
#             LIBRARY              #
#                                  #
####################################
library(knitr)
library(tidyverse)
library(gridExtra) # for saving table as pictures

#                                  #
#                                  #
#            GET DATA              #
#                                  #
####################################
year <- seq(2012, 2023, 1)
solar <- c(0, 
           8,
           480,
           1261,
           2639,
           3915,
           5218,
           6419,
           7971,
           10411,
           15406,
           17748)

df_solar <- tibble(year, solar)

# craft final table
tbl <- df_solar |>
  mutate(solar_lag = lag(solar),
         increase = paste0('+', round((solar-solar_lag)/solar_lag*100, 0), ' %'),
         increase = ifelse(year < 2014, '-', increase)) |>
  select(Year=year,
         `Solar-produced electricity (GWh)`=solar,
         `Percentage increase`=increase)


#                                  #
#                                  #
#           SAVE DATA              #
#                                  #
####################################
png("../others/table.png", width = 800, height = 600, res = 150)
grid.table(tbl)
dev.off()

