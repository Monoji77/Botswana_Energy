############################
#
#
# author  : Chris Yong
# date    : 20/4/2025
# preamble: obtain Botswana total secondary source by fuel  
#           type for figure 2 of paper
# 
# source  : https://www.iea.org/countries/botswana/electricity
#
#
############################


#                                  #
#                                  #
#             LIBRARY              #
#                                  #
####################################
library(tidyverse)

#                                  #
#                                  #
#            READ DATA             #
#                                  #
####################################
df_electricity <- read_csv('../data/electricity.csv',) |>
  rename(Group = `electricity generation sources in Botswana`) |>
  filter(Year >= 2018) |>
  select(-Units) |>
  mutate(Value = ifelse(is.na(Value), 0, Value))
df_electricity


#                                  #
#                                  #
#            ANALYSES              #
#                                  #
####################################

# clean for analyses
df_total <- df_electricity |>
  pivot_wider(names_from=Group, values_from = Value) |>
  mutate(total = Coal+Oil+`Solar PV`)

# analysis 1: percentage increase in electricity since covid
orig <- df_total$total[3]
new <- df_total$total[5]
formatted <-'Percentage increase in electricity\n----------------------------------\n' 
cat(formatted, paste0('+ ', round((new-orig)/orig*100,1), '%'))

# analysis 2: proportion of sources in electricity generation 
df_prop_source <- df_total |>
  reframe(across(c(Coal:`Solar PV`), 
                 function(x) paste0(round(x/total*100, 1), '%'),
                 .names='{.col}_prop'))
df_prop_source


#                                  #
#                                  #
#             PLOT                 #
#                                  #
####################################

electricity_plot <- df_electricity |>
  mutate(Group = paste(tolower(Group), 'produced')) |>
  ggplot(aes(x=Year, y=Value, fill=Group)) +
  geom_area(alpha=0.3, position='stack', 
            show.legend = FALSE) +
  geom_point(aes(shape=Group, color=Group),stroke=1.2, # makes shape thicker
             position='stack', size=3) +
  theme_minimal() +
  theme(panel.grid.major=element_blank()) +
  scale_x_continuous(breaks=seq(2018, 2022, 1)) +
  scale_y_continuous(breaks=seq(0, 4000, 500),
                     labels= function(x) paste0(x, '')) +
  geom_vline(xintercept=2020, col='brown4', lty=2, lwd=1.1) +
  annotate('text', x=2020.4, y=2750, label='COVID-19', fontface='bold.italic',color='brown4') +
  labs(title='Botswana secondary energy: Electricity',
       caption=paste0('Source: ', 'https://www.iea.org/countries/botswana/electricity')) +
  ylab('Electricity Supply (GWh)') +
  xlab('') +
  theme(panel.grid.minor=element_blank(),
        panel.grid.major = element_line(
          color = "gray80",
          linewidth = 0.5,
          linetype = "solid"
        ),
        panel.grid.major.x=element_blank(),
        plot.title=element_text(
          hjust=0.5,
          size=14,
          face='bold'
        ),
        plot.caption=element_text(
          hjust=1,
          size=9,
          color='gray40',
          face='italic',
          margin=margin(t=10)
        ),
        axis.title.y=element_text(color='grey50'),
        legend.position='bottom',
        legend.title = element_text(hjust=0.5,
                                    face='bold'),
        legend.title.position = 'top',
        legend.box.background=element_rect(color='grey70',
                                           linewidth=0.8)) +
  scale_color_viridis_d(option='D',
                         name='Electricity Type',
                         direction=1,
                         end=1
  ) +
  scale_fill_viridis_d(option='D',
                       name='Electricity Type',
                       direction=1,
                       end=1
  ) +  
  scale_shape_manual(
    values = c('coal produced' = 19,
               'oil produced' = 17,
               'solar pv produced' = 4),
    name='Electricity Type'
  ) 
electricity_plot

#                                  #
#                                  #
#           SAVE DATA              #
#                                  #
####################################
ggsave('../others/electricity_plot.png',plot=electricity_plot, width=9, height=7,dpi=600)
