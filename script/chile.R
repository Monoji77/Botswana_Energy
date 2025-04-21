library(knitr)
library(tidyverse)

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
tbl <- df_solar |>
  mutate(solar_lag = lag(solar),
         increase = paste0('+', round((solar-solar_lag)/solar_lag*100, 0), ' %'),
         increase = ifelse(year < 2014, NA, increase)) |>
  select(-solar_lag)


