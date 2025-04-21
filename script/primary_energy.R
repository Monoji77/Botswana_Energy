library(tidyverse)
year = seq(2018, 2022, 1)
coal = c(641, 1892, 1414, 1551, 1910)
oil = c(1043, 1110, 1201, 1301, 997)
biofuel = c(981, 677, 770, 726, 799)
imported_electricity = c(115, 95, 180, 120, 158)
renewable = c(67, 75, 43, 85, 90)

source <-  'https://au-afrec.org/botswana; https://www.iea.org/countries/botswana/energy-mix'
  
df_energy <- tibble(year, 
                    coal, 
                    oil,
                    biofuel, 
                    # imported_electricity, 
                    renewable)
  
df_analysis <- df_energy |>
  mutate(total=coal+oil+biofuel+renewable) |>
  reframe(across(c(coal:renewable), 
                function (x) paste0(round(x/total*100, 1),'%'),
                .names='{.col}_prop'))

df_energy_clean <- df_energy |>
  pivot_longer(cols=coal:renewable,
               names_to='Group') |>
  rename(Year = year,
         Value = value) |>
  mutate(Value = Value/1000)


getplot <- function(df, group_name, plot_title, 
                    source, covid_y, plot_breaks,
                    sign, y_axis_label) {
  plot <- df |>
    ggplot(mapping=aes(x=Year, y=Value, colour=Group)) +
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
    annotate('text', x=2020.4, y=covid_y, label='COVID-19', fontface='bold.italic',color='brown4') +
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
                          direction=-1,
                          end=0.97
                          ) 
  return(plot)
}


energy_source_plot <- getplot(df_energy_clean, 
        'Energy Source',
        'Botswana Energy Sources', 
        source,
        1.75,
        seq(0, 2, 0.5),
        '',
        'total energy supply (Mtoe)')
energy_source_plot

ggsave('energy_source_plot.png',plot=energy_source_plot, width=9, height=7,dpi=600)
