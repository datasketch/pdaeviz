
.onLoad <- function(libname, pkgname){
  dotenv::load_dot_env()
  ckanr::ckanr_setup("https://datosabiertos.gob.ec", 
                     key = Sys.getenv("CKAN_API_TOKEN"))
}

# .onUnload <- function(libpath){
# }


