
#' @export
pdae_read_data <- function(url){
  #resources_cache <- pdaeviz::all_resources
  #is_pdae_resource(url)

  max_file_size <- 20000000
  n_max <- 50000
  info <- pdae_rsrc_info(url)

  if(!is.null(info$size)){
    if(info$size > max_file_size){
      info$error <- "Archivo muy grande para visualizar"
      return(info)
    }
  }

  url <- info$url
  format <- tolower(info$format)

  if(format %in% c("xlsx", "xls")){
    tmpdir <- tempdir()
    dest <- file.path(tmpdir, basename(url))
    download.file(url, destfile = dest)
    if(format == "xlsx") {
      d <- readxl::read_xlsx(dest)
    } else {
      d <- readxl::read_xls(dest)
    }
    sheets <- readxl::excel_sheets(dest)
    if(length(sheets) > 1){
      info$sheets <- purrr::map(sheets, function(s){
        if(format == "xlsx") {
          d <- readxl::read_xlsx(dest, sheet = s)
        } else {
          d <- readxl::read_xls(dest, sheet = s)
        }
        list(sheet = s, data = d)
      })
    }
    unlink(dest)
  } else if(format == "csv"){
    locale <- readr::locale(encoding = "latin1")
    delim <- NULL
    safe_read_delim <- purrr::safely(readr::read_delim)
    n_max <- 10000
    out <- safe_read_delim(url, delim = delim, locale = locale, n_max = n_max)
    d <- out$result
  } else if(format == "ods"){
    tmpdir <- tempdir()
    dest <- file.path(tmpdir, basename(url))
    download.file(url, destfile = dest)
    d <- readODS::read_ods(dest)
    sheets <- readODS::list_ods_sheets(dest)
    if(length(sheets) > 1){
      info$sheets <- purrr::map(sheets, function(s){
        d <- readODS::read_ods(dest, sheet = s)
        list(sheet = s, data = d)
      })
    }
    unlink(dest)
  } else{
    d <- NULL
    info$error <- paste0("Formato no definido para visualizar (", format, ")")
  }
  info$data <- d
  info
}

#' @export
pdae_rscr_sample <- function(){
  pdaeviz::all_resources |>
    dplyr::sample_n(1) |>
    dplyr::pull(url)
}




is_pdae_resource <- function(url){
  grepl("https://datosabiertos.gob.ec", url, fixed = TRUE)
}



#' @export
pdae_resource_id_from_url <- function(url){
  if(!is_pdae_resource(url))
    stop(url, "\n is not a pdae resource")
  x <- stringr::str_split_fixed(url, "/download/",2)
  stringr::word(x[1],-1, sep="/")
}

#' @export
pdae_rsrc_info <- function(url){
  rsrc_id <- pdae_resource_id_from_url(url)
  x <- ckanr::resource_show(rsrc_id)

  ext <- tools::file_ext(basename(x$url))
  x$ext <- ext
  if(x$format != ext) x$format <- ext

  list(
    size = x$size,
    format = x$format,
    url = x$url,
    url_type = x$url_type,
    mimetype = x$mimetype,
    name = x$name,
    description = x$description,
    package_id = x$package_id,
    state = x$state
  )

}



