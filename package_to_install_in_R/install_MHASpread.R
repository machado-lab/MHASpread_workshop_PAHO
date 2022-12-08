# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "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", force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
