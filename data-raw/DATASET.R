library(tidyverse)
devtools::load_all()
## Download all links from resources
source("data-raw/get_all_resouces.R")
# rm(list=ls(all.names = TRUE))

all_resources <- read_csv("data-raw/all_resources.csv")

unique(all_resources$format)

usethis::use_data(all_resources, overwrite = TRUE)

