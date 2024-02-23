#===========================================================#
# set up all the necessary packages for the model
#===========================================================#
# The next lines require the package and if it is not pre-installed trigger the installation request

if (!require(tidyverse)){install.packages("tidyverse") };library(tidyverse)
if (!require(spatialEco)){install.packages("spatialEco") };library(spatialEco)
if (!require(parallel)){install.packages("parallel") };library(parallel)
if (!require(ggsci)){install.packages("ggsci") };library(ggsci)
if (!require(leaflet)){install.packages("leaflet") };library(leaflet)
if (!require(lwgeom)){install.packages("lwgeom") };library(lwgeom)
if (!require(reshape2)){install.packages("reshape2") };library(reshape2)
if (!require(mapview)){install.packages("mapview") };library(mapview)
if (!require(devtools)){install.packages("devtools") };library(devtools)
if (!require(shiny)){install.packages("shiny") };library(shiny)
if (!require(reticulate)){install.packages("reticulate") };library(reticulate)
if (!require(webshot)){install.packages("webshot") };library(webshot)


# add py 3 with Python libraries
reticulate::install_miniconda()
reticulate::py_install("pandas")
reticulate::py_install("scipy")
reticulate::py_install("numpy")
reticulate::py_install("pickle")
reticulate::py_install("sys")


# If you still have issues try this
#conda_install("r-reticulate", "pandas")

