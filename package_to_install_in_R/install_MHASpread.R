# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "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", force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
