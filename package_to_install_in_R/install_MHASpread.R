# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "", force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
