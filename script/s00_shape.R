############################
#
#
# author  : Chris Yong
# date    : 20/4/2025
# preamble: obtain geographical boundary of Botswana for 
#           cover page of paper
# 
# source  : https://data.humdata.org/dataset/cod-ab-bwa
#
#
############################


#                                  #
#                                  #
#             LIBRARY              #
#                                  #
####################################
library(sf)
library(tmap)

#                                  #
#                                  #
#            READ DATA             #
#                                  #
####################################
#                                  #
#         customisations           #     
#                                  #  
#   1. change '..._adm0_...' to    #    
#           - adm1                 #
#           - adm2                 #
#           - adm3                 #
#           - ALL                  #
#                                  #
####################################
file_path <- "../data/bwa_adm_2011_shp/bwa_admbnda_adm0_2011.shp"
shape_data <- st_read(file_path)


#                                  #
#                                  #
#             PLOT                 #
#                                  #
####################################

# interactive view
tmap_mode('view')

# plot
tm_shape(shape_data) +
  tm_basemap(providers$Stadia.AlidadeSmooth) +
  tm_polygons(fill_alpha=0.3, 
              fill = 'indianred4',
              lwd = 2.3,
              col = 'indianred3')

# plot saved using RStudio interactive helper buttons

