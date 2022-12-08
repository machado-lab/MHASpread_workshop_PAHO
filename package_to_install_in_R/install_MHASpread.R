# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "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", 
                        force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
