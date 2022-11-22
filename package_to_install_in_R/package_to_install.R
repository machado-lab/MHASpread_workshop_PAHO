
#===========================================================#
#       List of packages required by MHASpread              #
#===========================================================#
# the next lines require the package adn if is not pre-installed trigger the instalation request

if (!require(doParallel)){install.packages("doParallel") };library(doParallel)
if (!require(magrittr)){install.packages("magrittr") };library(magrittr)
if (!require(methods)){install.packages("methods") };library(methods)
if (!require(Matrix)){install.packages("Matrix") };library(Matrix)
if (!require(mc2d)){install.packages("mc2d") };library(mc2d)
if (!require(snow)){install.packages("snow") };library(snow)
if (!require(lubridate)){install.packages("lubridate") };library(lubridate)
if (!require(DBI)){install.packages("DBI") };library(DBI)
if (!require(scales)){install.packages("scales") };library(scales)
if (!require(EpiContactTrace)){install.packages("EpiContactTrace") };library(EpiContactTrace)
if (!require(sampler)){install.packages("sampler") };library(sampler)
if (!require(sp)){install.packages("sp") };library(sp)
if (!require(rgeos)){install.packages("rgeos") };library(rgeos)
if (!require(spatialEco)){install.packages("spatialEco") };library(spatialEco)
if (!require(parallel)){install.packages("parallel") };library(parallel)
if (!require(ggsci)){install.packages("ggsci") };library(ggsci)
if (!require(tidyverse)){install.packages("tidyverse") };library(tidyverse)
if (!require(leaflet)){install.packages("leaflet") };library(leaflet)
if (!require(crayon)){install.packages("crayon") };library(crayon) 
if (!require(lwgeom)){install.packages("lwgeom") };library(lwgeom) 
if (!require(sf)){install.packages("sf") };library(sf) 
if (!require(cowsay)){install.packages("cowsay") };library(cowsay) 
if (!require(fastmatch)){install.packages("fastmatch") };library(fastmatch)
if (!require(leaflet.extras)){install.packages("leaflet.extras") };library(leaflet.extras) 
if (!require(leaflet.extras)){install.packages("leaflet.extras") };library(leaflet.extras)
if (!require(reshape2)){install.packages("reshape2") };library(reshape2) #optional




