#===========================================================#
# set up all the necessary package for the model
#===========================================================#
# the next lines require the package and if is not pre-installed trigger the installation request

if (!require(doParallel)){install.packages("doParallel") };library(doParallel)
if (!require(magrittr)){install.packages("magrittr") };library(magrittr)
if (!require(methods)){install.packages("methods") };library(methods)
if (!require(Matrix)){install.packages("Matrix") };library(Matrix)
if (!require(mc2d)){install.packages("mc2d") };library(mc2d)
if (!require(snow)){install.packages("snow") };library(snow)
if (!require(lubridate)){install.packages("lubridate") };library(lubridate)
if (!require(DBI)){install.packages("DBI") };library(DBI)
if (!require(scales)){install.packages("scales") };library(scales)
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
if (!require(reshape2)){install.packages("reshape2") };library(reshape2)
if (!require(mapview)){install.packages("mapview") };library(mapview)
if (!require(data.table)){install.packages("data.table") };library(data.table)
if (!require(remotes)){install.packages("remotes") };library(remotes)
if (!require(devtools)){install.packages("devtools") };library(devtools)
if (!require(emo)){devtools::install_github("hadley/emo")};library(emo)

# add py 3 with python libraries
if (!require(reticulate)){install.packages("reticulate") };library(reticulate)
reticulate::install_miniconda()
reticulate::py_install("pandas")
# if you still have issues try this
#conda_install("r-reticulate", "pandas")

