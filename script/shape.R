
# SOURCE
# https://data.humdata.org/dataset/cod-ab-bwa
file_path <- "../bwa_adm_2011_shp/bwa_admbnda_adm0_2011.shp"

library(sf)
library(tmap)
shape_data <- st_read(file_path)

tmap_mode('view')

tm_shape(shape_data) +
  tm_basemap(providers$Stadia.AlidadeSmooth) +
  tm_polygons(fill_alpha=0.3, 
              fill = 'indianred4',
              lwd = 2.3,
              col = 'indianred3')

