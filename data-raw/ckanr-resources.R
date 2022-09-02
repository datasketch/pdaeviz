

library(ckanr)

# ckanr_setup(url = "https://pdae.datasketch.co",
#             key = Sys.getenv("CKAN_API_TOKEN"))

ckanr_setup(url = "https://datosabiertos.planificacion.gob.ec",
            key = Sys.getenv("CKAN_API_TOKEN_PDAE"))

site_url = "https://datosabiertos.planificacion.gob.ec"
key = Sys.getenv("CKAN_API_TOKEN_PDAE")

download_url <- "https://datosabiertos.planificacion.gob.ec/dataset/3cf2868d-6787-4620-8f37-5f8530931111/resource/837d5534-d88b-4a13-8df7-cc38603839a6/download/mernnr_perforacionpozospetroleros_2021diciembre.csv"


info <- pdaeviz::pdae_resource_info(download_url, site_url = site_url, key = key)
dataset <- pdae_read_download_url(download_url)

download_url <- "https://datosabiertos.planificacion.gob.ec/dataset/31718205-5bbf-4ef5-88e2-d31523ed6902/resource/07ecb477-80e2-442a-b200-3dcf5d071e46/download/senae_exportacion_enero_agosto_2021.csv"
info <- pdaeviz::pdae_resource_info(download_url)
info$visualize






