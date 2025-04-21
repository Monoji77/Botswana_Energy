# Botswana's energy situation
![Botswana](https://github.com/user-attachments/assets/a1c81e78-9ecd-43e7-b335-e684b8927961)

## File Structure
The repo is structured as:
```
├───data 
│   ├───Botswana_GISdata_LTAy_YearlyMonthlyTotals_GlobalSolarAtlas-v2_GEOTIFF
│   │   └───monthly
│   └───bwa_adm_2011_shp
├───others
├───paper
└───script
```

-   `data` contains raw electricy.csv and total_energy.csv files obtained from [IEA](https://www.iea.org/countries/botswana).
-   `data/Botswana_GISdata_LTAy_YearlyMonthlyTotals_GlobalSolarAtlas-v2_GEOTIFF` contains the raw .geotiff solar related data for botswana obtained from [SolarGIS](https://solargis.com/resources/free-maps-and-gis-data?locality=botswana).
-   `data/bwa_adm_2011_shp` contains Botswana boundary shape files from [The Humanitarian Data Exchange](https://data.humdata.org/dataset/cod-ab-bwa).
-   `others` contains images of figures generated from `scripts`.
-   `paper` contains the word document outlining Botswana Energy Project. 
-   `scripts` contains the R scripts used to download, clean, manipulate and transform data.

## Quick View of Figures
![solar](https://github.com/user-attachments/assets/a50bf0da-22fe-4039-a6f7-fb9019d514e6)

## Notes
All aspects of the code were written by me (Chris Yong Hong Sen). A lot of time was spent using tmap to generate map related data. However, due to inability to make plot translucent in tmap for Global Horizontal Irradiance (GHI), used leaflet package instead. 
