# === REFLECTIVIDAD TOA IMAGEN LANDSAT ===

# Cargar o Instalar Librerias 
rm(list = ls())
#install.packages("dplyr")
#install.packages("raster")
#install.packages("RStoolbox")
#install.packages("sf")

library(dplyr)
library(raster)
library(RStoolbox)
library(sf)

# Definir la ruta donde estan ubicados la escena Landsat
setwd('C:/Users/hugoa/Documents/Remote_Sensing_with_R/TOA Reflectance Calculation/')

# Seleccionar metadato para la lectura
mtlFile <- 'LC08_L1TP_003070_20190707_20190719_01_T1/LC08_L1TP_003070_20190707_20190719_01_T1_MTL.txt'
MTL <- readMeta(mtlFile)

# Definir archivo shape de área de interes (AOI) para recorte
SisRef <- '+proj=utm +zone=19 +datum=WGS84 +units=m +no_defs' # Establecer Sistema de referencia de coordenadas
AOI <- read_sf('C:/Users/hugoa/Documents/Remote_Sensing_with_R/TOA Reflectance Calculation/SHAPE/SHAPE.shp') %>% st_transform(SisRef) # Definir ruta de archivo shape

# Creando stack de imagenes y recortando segun nuestra área de interes
lsat <- stackMeta(mtlFile) %>% crop(AOI)

# Calculando la reflectividad TOA 
lsat_TOA <- radCor(lsat, MTL, 'apref')

# Reproyectando el Stack
lsat_TOA= projectRaster(lsat_TOA, crs = "+init=epsg:32719") # Definir SRC EPSG

# Visualizamos (falso color) 
plotRGB(lsat_TOA,r=5,g=4,b=3,stretch="lin") 

# Guardamos el Stack
setwd("C:/Users/hugoa/Documents/Remote_Sensing_with_R/TOA Reflectance Calculation/") #Definir directorio donde guardar 
writeRaster(lsat_TOA,"Lsat8_TOA.tif",drivername="Gtiff") # Definir nombre del Stack


