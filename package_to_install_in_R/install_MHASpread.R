# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "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", force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
