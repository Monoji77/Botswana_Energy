############################
#
#
# author  : Chris Yong
# date    : 20/4/2025
# preamble: obtain Botswana total co2 emissions by fuel  
#           type for figure 4 of paper
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
#           READ DATA              #
#       (Energy supplied)          #
#                                  #
####################################

df <- read_csv('../data/total_energy.csv')
clean_df <- df |>
  rename('Group'=`total energy supply in Botswana`) |>
  filter(Year >= 2018)|>
  mutate(total = sum(Value), .by=Year) |>
  mutate(Prop = round(Value/total*100, 2)) |>
  select(-total)


#                                  #
#                                  #
#           READ DATA              #
#                                  #
#     (CO2 emission per            #
#       industry supplied)         #
#                                  #
####################################

power <- c(4787840, 4066910, 2948290, 3526430, 4687930)
transport <- c(2447760, 2352690, 2126700, 2126920, 2320520)
industrial <- c(691560, 653690, 573400, 603890, 703130)
buildings <- c(133830, 125000, 111800, 115200, 130630)
fuel <- c(21930, 18650, 16680, 17520, 17710)
processes <- c(114860, 120020, 319060, 353980, 353800)


df_unclean <- tibble(year, power, transport, industrial, 
                     buildings, fuel, processes)
options(scipen=999)

df_energy_source <- df_unclean |>
  mutate(others = industrial + buildings + 
           fuel + processes,
         total_tons = power + transport + others) |>
  select(year, power, transport, others, total_tons) |>
  select(-total_tons) |>
  pivot_longer(cols=c(power:others),
               names_to='industry',
               values_to = 'prop') |>
  rename(Year=year,
         Group=industry,
         Prop=prop) |>
  mutate(Prop = Prop/1000000)

#                                  #
#                                  #
#             PLOT                 #
#                                  #
####################################

# define a function for resuability
getplot <- function(df, group_name, plot_title, 
                    source, ylabel, plot_breaks,
                    sign, y_axis_label) {
  plot <- df |>
    ggplot(mapping=aes(x=Year, y=Prop, colour=Group)) +
    geom_rect(mapping=aes(xmin=2020, xmax=Inf, 
                          ymin=0, ymax=Inf), 
              alpha=0.01,
              color=NA,
              fill='skyblue') +
    geom_line(lwd=1) +
    geom_point(size=3, alpha=0.5) +
    scale_x_continuous(breaks=seq(2018, 2022, 1)) +
    scale_y_continuous(breaks=plot_breaks,
                       labels= function(x) paste0(x, sign)) +
    geom_vline(xintercept=2020, col='brown4', lty=2, lwd=1.1) +
    theme_minimal() +
    annotate('text', x=2020.4, y=ylabel, label='COVID-19', fontface='bold.italic',color='brown4') +
    labs(title=plot_title,
         caption=paste0('Source: ', source)) +
    ylab(y_axis_label) +
    xlab('') +
    theme(panel.grid.minor=element_blank(),
          panel.grid.major = element_line(
            color = "gray80",  # Darker gray (adjust as needed)
            linewidth = 0.5,   # Slightly thicker
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
                          name=group_name,
                          end=0.9)
  return(plot)
}

# plot energy
energy_supply <- getplot(clean_df, 
        'Energy Source', 
        'Botswana energy supply by source (proportion)',
        'https://www.iea.org/countries/botswana/energy-mix',
        41,
        seq(0,50,10),
        '%', 
        '')
energy_supply



# plot industry proportions in CO2 emissions
industry_prop <- getplot(df_energy_source, 
        'Industry', 
        'Botswana CO2 emissions by Industry',
         'https://www.worldometers.info/co2-emissions/botswana-co2-emissions/',
        3.8,
        seq(0, 5, 1),
        'M',
        'Fossil C02 emissions (tons)')
        

# save plot
ggsave('../others/industry_prop.png',plot=industry_prop, width=9, height=7,dpi=600)
# ggsave('../others/energy_mix.png',plot=energy_supply, width=9, height=7,dpi=600)
