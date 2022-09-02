
library(ckanr)
library(tidyverse)





get_package_resources <- function(slug, org_resources){
  x <- org_resources %>% filter(pkg_slug == slug)
  x$id
}

check_package_exists <- function(slug, org_resources){
  x <- org_resources %>% filter(pkg_slug == slug)
  nrow(x) > 0
}

get_package_id <- function(slug, org_resources){
  x <- org_resources %>% filter(pkg_slug == slug)
  x$pkg_id
}


get_all_resources_by_org <- function(){
  pkg_list <- package_list(limit = 10000)
  pkgs <- map(pkg_list, function(x){
    d <- package_show(x,as = "table")
    d$pkg_slug <- x
    d
  })
  pkgs_resources <- map(pkgs, function(x){
    d <- x$resources
    d$org_id <- x$organization$id
    d$org_name <- x$organization$name
    d$pkg_slug <- x$pkg_slug
    d$pkg_id <- x$id
    d
  }) %>% 
    bind_rows() %>% 
    select(org_name, org_id, pkg_slug, name, url, everything())
  pkgs_resources
}

get_org_id <- function(slug){
  orgs <- organization_list(as = "table") 
  orgs %>% filter(name == slug) %>% pull(id)
}




#licenses <- license_list(as = "table")


# get_tag <- function(tag){
#   tag_exists <- tag_list(pkg$Etiquetas, as = "table")
#   tag_exists[1,1]
# }


# check_package_exists <- function(name){
  
# exists_pkg <- package_search(name, as = "table")
# 
# name <- pkg$Slug
# 
# exists_pkg <- package_search(paste0("name:",name), as = "table")$results
# 
# exists_pkg <- package_search(paste0("id:",name), as = "table")$results
# 
# x <- package_search(paste0("owner_org:",org_id, ",name:",name), as = "table")$results
# 
# l <- package_list(limit = 1000)
# l <- package_list(owner_org = org_id)
# 
# 
# name %in% exists_pkg$results$name
# }