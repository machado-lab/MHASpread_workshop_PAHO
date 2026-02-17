# Install R package 
if (!require(remotes)){install.packages("remotes") };library(remotes)
if (webshot::is_phantomjs_installed()==F) {  # additional software to screen shot
  webshot::install_phantomjs()
}
library(remotes)
remotes::install_github(repo='machado-lab/EpiShark',
                        auth_token = "replace_token_here",
                        force=T)
#check
require(EpiShark)
if (!require(EpiShark)==F){hello()}
                        
                        
