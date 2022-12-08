# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "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", 
                        force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
