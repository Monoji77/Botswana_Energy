# load libraries
library(tidyverse)

year <- seq(2018, 2022, 1)

power <- c(4787840, 4066910, 2948290, 3526430, 4687930)
transport <- c(2447760, 2352690, 2126700, 2126920, 2320520)
industrial <- c(691560, 653690, 573400, 603890, 703130)
buildings <- c(133830, 125000, 111800, 115200, 130630)
fuel <- c(21930, 18650, 16680, 17520, 17710)
processes <- c(114860, 120020, 319060, 353980, 353800)


df_unclean <- tibble(year, power, transport, industrial, 
                     buildings, fuel, processes)
options(scipen=999)

df <- df_unclean |>
  mutate(others = industrial + buildings + 
                  fuel + processes,
         total_tons = power + transport + others) |>
  select(year, power, transport, others, total_tons) |>
  # mutate(across(c(power, transport, others),
  #           function(x) round(x/total_tons*100,2))) |>
  select(-total_tons) |>
  pivot_longer(cols=c(power:others),
               names_to='industry',
               values_to = 'prop') |>
  rename(Year=year,
         Group=industry,
         Prop=prop) |>
  mutate(Prop = Prop/1000000)

df |>
  ggplot(mapping=aes(x=year, y=prop, colour=industry)) +
  geom_point() +
  geom_line(alpha=0.3) +
  theme_minimal() +
  scale_y_continuous(limits=c(0, 100), 
                     labels= function(x) paste0(x, '%')) +
  geom_vline(alpha=0.5, xintercept=2020, lwd=1.1, colour='indianred4') +
  geom_rect(mapping=aes(xmin=2020, xmax=Inf, 
                        ymin=0, ymax=Inf), 
            alpha=0.01,
            color=NA,
            fill='skyblue')


df |>
  ggplot(mapping=aes(x=year, y=prop, colour=industry)) +
  geom_rect(mapping=aes(xmin=2020, xmax=Inf, 
                        ymin=0, ymax=Inf), 
            alpha=0.01,
            color=NA,
            fill='skyblue') +
  geom_line(lwd=1) +
  geom_point(size=3, alpha=0.5) +
  scale_x_continuous(breaks=seq(2018, 2022, 1)) +
  scale_y_continuous(breaks=seq(0, 100, 20),
                     labels= function(x) paste0(x, '%'),
                     limits = c(0, 100)) +
  geom_vline(xintercept=2020, col='brown4', lty=2, lwd=1.1) +
  theme_minimal() +
  annotate('text', x=2020.4, y=41, label='COVID-19', fontface='bold.italic',color='brown4') +
  labs(title='Botswana Energy Supply Post COVID-19',
       caption='Source: https://www.iea.org/countries/botswana/energy-mix') +
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
          hjust=0,
          size=9,
          color='gray40',
          face='italic',
          margin=margin(t=10)
        )) +
  scale_color_viridis_d(option='D',
                        name='Energy Source')
