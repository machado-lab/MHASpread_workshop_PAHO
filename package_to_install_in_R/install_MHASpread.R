# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "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", 
                        force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
