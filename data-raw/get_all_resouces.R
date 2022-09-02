
library(dotenv)
dotenv::load_dot_env()

library(ckanr)
library(tidyverse)
library(jsonlite)

ckanr_setup(url =  "https://datosabiertos.gob.ec")

source("data-raw/ckan_funs.R")

all_orgs <- organization_list(as = "table")

all_resources <- get_all_resources_by_org()
write_csv(all_resources, "data-raw/all_resources.csv")

