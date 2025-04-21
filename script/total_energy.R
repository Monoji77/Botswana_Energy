library(tidyverse)

df <- read_csv('../data/total_energy.csv')


clean_df <- df |>
  rename('Group'=`total energy supply in Botswana`) |>
  filter(Year >= 2018)|>
  mutate(total = sum(Value), .by=Year) |>
  mutate(Prop = round(Value/total*100, 2)) |>
  select(-total)


energy_mix <- clean_df |>
  ggplot(mapping=aes(x=Year, y=Prop, colour=Group)) +
  geom_rect(mapping=aes(xmin=2020, xmax=Inf, 
                        ymin=0, ymax=Inf), 
            alpha=0.01,
            color=NA,
            fill='skyblue') +
  geom_line(lwd=1) +
  geom_point(size=3, alpha=0.5) +
  scale_x_continuous(breaks=seq(2018, 2022, 1)) +
  scale_y_continuous(breaks=seq(0, 50, 10),
                     labels= function(x) paste0(x, '%')) +
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
energy_mix


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
          axis.title.y=element_text(color='grey50')) +
    scale_color_viridis_d(option='D',
                          name=group_name,
                          end=0.9)
  return(plot)
}

energy_supply <- getplot(clean_df, 
        'Energy Source', 
        'Botswana energy supply by source (proportion)',
        'https://www.iea.org/countries/botswana/energy-mix',
        41,
        seq(0,50,10),
        '%', 
        '')


# for this to work, run carbon_prop.R to obtain cleaned df
industry_prop <- getplot(df, 
        'Industry', 
        'Botswana CO2 emissions by Industry',
         'https://www.worldometers.info/co2-emissions/botswana-co2-emissions/',
        3.8,
        seq(0, max(df$Prop), 1),
        'M',
        'Fossil C02 emissions (tons)')
        

# save plot
ggsave('energy_mix.png',plot=energy_supply, width=9, height=7,dpi=600)
ggsave('industry_prop.png',plot=industry_prop, width=9, height=7,dpi=600)
