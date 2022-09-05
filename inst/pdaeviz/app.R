
library(tidyverse)
library(shinypanels)
library(shiny)
library(shinyinvoer)
library(DT)
library(hgchmagic)
library(homodatum)
library(pdaeviz)
library(pseudoviz)
library(devtools)

devtools::load_all()

custom_css <- "
#debug{
max-height: 150px;
overflow: auto;
}
#debug2{
max-height: 300px;
overflow: auto;
}
#rsc_description{
max-height: 100px;
overflow: auto;
}
#rsc_title{
overflow-x: auto;
}


"


ui <- panelsPage(styles = custom_css,
                 panel(title = "Información", width = 300,
                       body = div(
                         #verbatimTextOutput("debug"),
                         uiOutput("data_info"),
                         uiOutput("data_info2"),
                         hr(),
                         uiOutput("column_selector"),
                         uiOutput("viz_button"),
                         hr(),
                         uiOutput("resource_info"),
                         br()
                       ),
                       footer = tags$a(
                         href="https://www.datasketch.co", target="blank",
                         img(src= 'ds_logo.svg', align = "left",
                             width = 180, height = 150)
                       )
                 ),
                 panel(title = "Gráficos",
                       #header_right =
                       body = div(
                         uiOutput("file_error"),
                         uiOutput("data_error"),
                         #verbatimTextOutput("debug2"),
                         uiOutput("viz"),
                         br()
                       ),
                       footer = "")
)

server <-  function(input, output, session) {

  # XLS File with 2 hojas
  # url_param_defaults <- list("data" =  "https://datosabiertos.gob.ec/dataset/c5f28d19-6e02-4ccb-861e-e4ab177be82b/resource/d6dffcef-1a0d-4f1b-a9e6-86c84e3e13cd/download/metadatos-ras2013.xls")
  # Big file 13Mb
  # url_param_defaults <- list("data" =  "https://datosabiertos.gob.ec/dataset/f2b73b70-46c6-4011-859c-88c36b2b7ca8/resource/1ed0530a-81ba-4fcb-b3ce-3352c89d12f7/download/inec_enemdu_persona_2020_diciembre.csv")
  # url <- "https://datosabiertos.gob.ec/dataset/da851fd1-4cb9-4299-91b9-df8b29dcf895/resource/ba8b653a-eb67-4ee4-90d2-7e2285c37bd2/download/senae_recaudaciones_enero_diciembre_2019.csv"
  # url <- "https://datosabiertos.gob.ec/dataset/8d92cf9f-1ad6-4222-b90a-00d65897ac8c/resource/2fcf0866-9a30-4a01-a9ae-c5559cc53270/download/pre_presupuestojuniagosto_pm_2021_agosto.ods"

  # multiples columnas
  #url <- "https://datosabiertos.gob.ec/dataset/cff9dbb6-ac0c-43a5-b787-167dfd165f3f/resource/774e0f92-dcac-48d9-857d-48d185ea8d31/download/pre_distributivo_2022junio.xls"

  # Error indices
  #url <- "https://datosabiertos.gob.ec/dataset/e9f18550-a0f0-4c61-8fc8-3adc7d913e58/resource/6cf018dd-0c04-4e6b-853d-4de01d95df71/download/mag_zaebrocoli_dd_2021agosto.xlsx"

  # Other data
  #url <- "https://www.sri.gob.ec/o/sri-portlet-biblioteca-alfresco-internet/descargar/b517acd4-15c5-43a3-8338-466a4638933d/SRI_IAENP_Mensual.csv"

  #url_param_defaults <- list("data" = url)

  # Error
  url <- "https://datosabiertos.gob.ec/dataset/58d7ee01-3fd0-4d06-af4d-81ba32664629/resource/8e7a23db-ae36-44a4-b723-979daf63e247/download/epaep_matrizreportemensualcac_2022junio.ods"


  # https://datosabiertos.gob.ec/visualiza/?
  #lang=es&
  #data=https://datosabiertos.gob.ec/dataset/40fb400c-8321-4973-8823-98c7aec6cbd2/resource/a92d7c50-837a-483f-b736-6f1c423d4673/download/astinave_embarcacionesatendidasmantenimiento_2022agosto.csv
  #&resource=/dataset/embarcaciones-atendidas-segun-el-tipo-de-mantenimiento-brindado/resource/a92d7c50-837a-483f-b736-6f1c423d4673&origin=https://datosabiertos.gob.ec


  url_param_defaults <- list("data" = pdaeviz::pdae_rscr_sample())
  str(url_param_defaults$data)
  message(url_param_defaults$data)

  output$debug <- renderText({
    what <- input$viz_selection
    what <- url_params(url_param_defaults, session)
    url_params <- url_params(url_param_defaults, session)
    what <- url_params$inputs$data
    #what <- data_info()$sheets
    #what <- data_fringe()
    #what <- viz_families()
    #what <- fringe_selected()
    #what <- input$selected_columns

    f <- data_fringe()
    dic <- fringe_dic(f)
    dic_names <- dic$id
    names(dic_names) <- dic$label
    cols <- suggest_columns(f, frtype = "Cat-Num")
    what <- cols

    paste0(capture.output(what),collapse = "\n")
  })



  # Data Info

  data_info <- reactive({
    #what <- url_params(url_param_defaults, session)
    url_params <- url_params(url_param_defaults, session)
    url <- url_params$inputs$data
    if(!pdaeviz::is_pdae_resource(url))
      return()
    pdaeviz::pdae_read_data(url)
  })

  output$data_info <- renderUI({
    info <- data_info()
    title <- gsub("_", " ", info$name)
    format <- info$format
    size <- info$size %||% "Desconocido"
    if(is.numeric(size)) size <- utils:::format.object_size(info$size, "auto")
    #sheets <- paste0(info$sheets, collapse = ", ")
    # if(is.null(format)){
    #   return(list(h2("Conjunto de datos no disponible")))
    # }
    list(
      h2(title, id = "rsrc_title"),
      br(),
      p(info$description, id = "rsc_description"),
      br(),
      HTML(markdown(paste("**Tamaño archivo:** ", size))),
      HTML(markdown(paste("**Formato:** ", format)))
    )
  })

  output$data_info2 <- renderUI({
    req(data_info())
    info <- data_info()
    out <- list()
    if(!is.null(info$sheets)){
      sheets <- map_chr(info$sheets, "sheet")
      out <-  selectInput("data_sheets", "Seleccione hoja:",
                          choices = sheets)
    }
    out
  })

  output$column_selector <- renderUI({

    f <- data_fringe()
    dic <- fringe_dic(f)
    dic_names <- dic$id
    names(dic_names) <- dic$label
    cols <- suggest_columns(f, frtype = "Cat-Num")

    selectizeInput("selected_columns", "Selecciones columnas a visualizar",
                   choices = dic_names,
                   selected = cols,
                   multiple = TRUE,
                   options = list(plugins = list("drag_drop", "remove_button"))

    )

  })



  data <- reactive({
    info <- data_info()
    if(!is.null(info$sheets)){
      s <- input$data_sheets
      d <- keep(info$sheets, ~.$sheet == s)[[1]]$data
    }else{
      d <- info$data
    }
    d
  })

  data_fringe <- reactive({
    req(data())
    homodatum::fringe(data())
  })

  fringe_selected <- reactive({
    f <- data_fringe()
    select_columns(f, columns = input$selected_columns)
  })

  viz_families <- reactive({
    f <- fringe_selected()
    families <- viz_which(f)
    av_viz_families <- c("bar", "line", "pie","treemap")
    families <- families |>
      dplyr::filter(family %in% av_viz_families) |>
      distinct(family)
    families |>
      dplyr::pull(family)

  })

  output$viz_button <- renderUI({

    viz_fams <- viz_families()

    buttonImageInput(inputId = 'viz_selection',
                     label = "",
                     images = c("table", viz_fams),
                     nrow = 1,
                     #tooltips = c("Table","Torta", "Barras", "Treemap"),
                     active = 'table',
                     imageStyle = list(borderColor = "#eee",
                                       borderSize = "1px",
                                       padding = "10px",
                                       shadow = TRUE),
                     path = "viz_icons")
  })

  output$file_error <- renderUI({
    error <- list()
    info <- data_info()
    if(!is.null(info$error)){
      error <- shinypanels::infomessage(info$error)
    }
    error
  })

  output$data_error <- renderUI({
    error <- list()
    req(data())
    d <- data()
    if(nrow(d) == 0){
      error <- shinypanels::infomessage("Sin datos disponibles")
    }
    error
  })



  output$debug2 <- renderPrint({

    req(viz_families())
    req(fringe_selected())
    f_viz <- fringe_selected()
    # what <- fun
    # out <- NULL
    # viz <- NULL
    # if(length(fun) != 0){
    #   message("here")
    #   message(fun)
    #   f_viz <- fringe_selected()
    #   opts <- list(
    #     dataLabels_show = TRUE,
    #     drop_na = TRUE
    #     #color_by = names(dd)[1]
    #   )
    #   viz <- do.call(fun, list(f_viz$data, opts = opts))
    #   message(str(viz))
    #   out <- renderHighchart(viz)
    # }
    what <- c(
      fringe_frtype(f_viz),
      viz_families()
    )
    paste0(capture.output(what),collapse = "\n")
  })

  output$viz <- renderUI({
    req(data())
    req(input$viz_selection)
    dd <- data()
    f_viz <- fringe_selected()
    frtype <- fringe_frtype(f_viz)
    viz_fams <- viz_families()

    funs <- viz_fun("hgchmagic", family = viz_families(),
                    frtype = frtype, with_package = F)

    if(input$viz_selection == "table"){
      out <- renderDataTable(dd)
    }else{
      out <- NULL
      fun <- funs[grepl(input$viz_selection,funs)]
      if(length(fun) != 0){
        opts <- list(
          dataLabels_show = TRUE,
          drop_na = TRUE
          #color_by = names(dd)[1]
        )
        d <- f_viz$data
        names(d) <- f_viz$dic$label
        viz <- do.call(fun, list(d, opts = opts))
        out <- renderHighchart(viz)
      }
    }
    out
  })




}

shinyApp(ui, server)
