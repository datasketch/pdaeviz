
#' @export
run_app <- function(){
  app_file <- system.file("pdaeviz/app.R", package = "pdaeviz")
  shiny::runApp(app_file, port = 3838)
}
