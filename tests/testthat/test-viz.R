test_that("viz works", {

  library(homodatum)
  library(pseudoviz)

  url <- pdae_rscr_sample()

  url <- "https://datosabiertos.gob.ec/dataset/cff9dbb6-ac0c-43a5-b787-167dfd165f3f/resource/774e0f92-dcac-48d9-857d-48d185ea8d31/download/pre_distributivo_2022junio.xls"
  info <- pdae_read_data(url)
  d <- info$data

  f <- homodatum::fringe(d)
  dic <- homodatum::fringe_dic(f, stats = TRUE)


  # Suggest cols with frtype = "Cat-Num"

  sug_cols <- suggest_columns(f, frtype = "Cat-Num")


  # for 1 or 2 variables, check which viz works

  selected_vars <- sug_cols
  #selected_vars <- dic |> dplyr::sample_n(2)

  selected_vars
  fringe_selected <- homodatum::select_columns(f, selected_vars)

  frtype <- fringe_frtype(f2)

  available_families <- c("bar", "line", "pie","treemap")

  families <- viz_which(f2)
  families <- families |>
    dplyr::filter(family %in% available_families) |>
    dplyr::pull(family) |> unique()

  funs <- viz_fun("hgchmagic", family = families, frtype = frtype, with_package = F)
  funs

  library(hgchmagic)

  input <- list(viz_selection = "pie")
  fun <- funs[grepl(input$viz_selection,funs)]
  viz <- do.call(fun, list(fringe_selected$data))

  str(viz)
  hgchmagic::hgch_bar_CatNum(f2$data)


})
