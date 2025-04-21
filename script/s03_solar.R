############################
#
#
# author  : Chris Yong
# date    : 20/4/2025
# preamble: obtain heat map of Botswana by Global Horizontal 
#           Irradiance (GHI) for figure 3 of paper
# 
# source  : https://solargis.com/resources/ free-maps-and-gis-data
#
#
############################

#                                  #
#                                  #
#             LIBRARY              #
#                                  #
####################################
library(leaflet)
library(terra)
# library(sf)
# library(tmap)

#                                  #
#                                  #
#            READ DATA             #
#                                  #
####################################

r <- raster("../data/Botswana_GISdata_LTAy_YearlyMonthlyTotals_GlobalSolarAtlas-v2_GEOTIFF/GHI.tif")

# for analysis of summary statistics
breaks <- quantile(r, probs=seq(0,1,0.25))
breaks <- c(1900, 2000, 2100, 2200, 2300, 2400)

# doesn't work for legend labels, need to find a way to make it work 
break_labels <- c(
  '<= 2000',
  '2000 - 2100',
  '2100 - 2200',
  '2200 - 2300',
  '> 2300',
  'missing'
)

# set palette
pal <- colorBin("Reds", values(r), bins=breaks, na.color='transparent')


#                                  #
#                                  #
#             PLOT                 #
#                                  #
####################################
leaflet(options=leafletOptions(zoomControl=F)) |>
  addProviderTiles('Stadia.AlidadeSmooth') |>
  addRasterImage(
    r,
    colors=pal,
    opacity=0.7,
    project=F
   ) |>
  addLegend(
    pal=colorBin(
      palette='Reds',
      values(r),
      bins=breaks,
      na.color = 'transparent'
    ),
    values=values(r),
    title='GHI (kWh/m2)',
    position='bottomright',
  )
    
# plot saved using RStudio's interactive helper function

#                                  #
#                                  #
#             tmap                 #
#                                  #
#     wait until tmap v4 can set   #
#         alpha complexity         #
#                                  #
#                                  #                 
#                                  #
####################################
# # get boundary
# shp_df <- st_read('../data/bwa_adm_2011_shp/bwa_admbnda_adm1_2011.shp')
# raster_df <- rast('../data/Botswana_GISdata_LTAy_YearlyMonthlyTotals_GlobalSolarAtlas-v2_GEOTIFF/GHI.tif') 
# 
# # convert for easier readibility after plot
# names(raster_df) <- 'GHI (kWh/m^2)'
# 

# tmap_mode('view')
# tmap_options(raster.max.cells=c(plot=ncell(raster_df)))
# botswana_border <- tm_shape(shp_df) +
#   tm_lines(col='grey50',
#            lwd=2)
# 
# botswana_border
# 
# solar_map <- tm_shape(raster_df) +
#   tm_basemap('Stadia.AlidadeSmooth') +
#   tm_raster(col.scale=tm_scale(palette='brewer.reds'),
#             col_alpha.scale = tm_scale(values=c(0.1, 0.5)))
# 
# botswana_border + solar_map