# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
library(remotes)
remotes::install_github(repo='machado-lab/MHASpread',
                        auth_token = "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", force=T)
#check
require(MHASpread)
if (!require(MHASpread)==F){hello()}
                        
                        
