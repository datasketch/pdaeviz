test_that("ckan info", {

  url <- "https://datosabiertos.gob.ec/dataset/recaudacion-de-impuestos-2022/resource/e7a6e4a8-72b7-4863-ad97-a3f6b7872581"
  rsrc_id <- pdae_resource_id_from_url(url)
  expect_equal(rsrc_id, "e7a6e4a8-72b7-4863-ad97-a3f6b7872581")

  url <- "https://datosabiertos.gob.ec/dataset/58d7ee01-3fd0-4d06-af4d-81ba32664629/resource/d5dae692-3808-44ac-a131-dea524f7c560/download/epaep_matrizreportemensualcac_2021agosto.ods"
  rsrc_id <- pdae_resource_id_from_url(url)
  expect_equal(rsrc_id, "d5dae692-3808-44ac-a131-dea524f7c560")

  url <- "https://www.sri.gob.ec/o/sri-portlet-biblioteca-alfresco-internet/descargar/79b1cc3b-04b3-41c4-ab6d-0a37b11ea595/sri_recaudacion_2022.csv"
  rsrc_id <- pdae_resource_id_from_url(url)

  url <- "/dataset/recaudacion-de-impuestos-2022/resource/322fd4a9-b3ee-4d0e-a212-614eef421ff1"
  rsrc_id <- pdae_resource_id_from_url(url)
  expect_equal(rsrc_id, "322fd4a9-b3ee-4d0e-a212-614eef421ff1")

  url <- "https://datosabiertos.gob.ec/dataset/58d7ee01-3fd0-4d06-af4d-81ba32664629/resource/d5dae692-3808-44ac-a131-dea524f7c560/download/epaep_matrizreportemensualcac_2021agosto.ods"
  pdae_rsrc_info(url)

  url <- "https://datosabiertos.gob.ec/dataset/e9f18550-a0f0-4c61-8fc8-3adc7d913e58/resource/6cf018dd-0c04-4e6b-853d-4de01d95df71/download/mag_zaebrocoli_dd_2021agosto.xlsx"
  pdae_rsrc_info(url)



})

test_that("Read different formats",{

  url <- pdae_rscr_sample()
  url

  # XLS
  url <- "https://datosabiertos.gob.ec/dataset/c5f28d19-6e02-4ccb-861e-e4ab177be82b/resource/d6dffcef-1a0d-4f1b-a9e6-86c84e3e13cd/download/metadatos-ras2013.xls"
  x <- pdae_read_data(url)
  d <- x$data
  sheets <- x$sheets


  # CSV
  url <- "https://datosabiertos.gob.ec/dataset/31718205-5bbf-4ef5-88e2-d31523ed6902/resource/a97687ee-aa06-4dcb-8ea1-03d0a5f1d752/download/senae_exportacion_general_enero_diciembre_2016.csv"
  x <- pdae_read_data(url)
  d <- x$data

  # Big CSV

  url <- "https://datosabiertos.gob.ec/dataset/f2b73b70-46c6-4011-859c-88c36b2b7ca8/resource/1ed0530a-81ba-4fcb-b3ce-3352c89d12f7/download/inec_enemdu_persona_2020_diciembre.csv"
  url <- "https://datosabiertos.gob.ec/dataset/df70c6d2-ed56-480c-831b-501697b0b7c0/resource/9a7f0d4d-813a-4dad-9536-e0593befe5d9/download/ensanut_f11_consumo_parteb.csv"

  url <- "https://datosabiertos.gob.ec/dataset/da851fd1-4cb9-4299-91b9-df8b29dcf895/resource/ba8b653a-eb67-4ee4-90d2-7e2285c37bd2/download/senae_recaudaciones_enero_diciembre_2019.csv"
  x <- pdae_read_data(url)
  d <- x$data

  # ODS
  url <- "https://datosabiertos.gob.ec/dataset/d3878ddf-3f42-4034-8ce5-caeac1162c73/resource/cbdfe1e3-32dc-43d5-8e7e-a6b66b201992/download/cnelep_-ejecucionpresupuestariaoperacion_2022enero.ods"
  x <- pdae_read_data(url)
  d <- x$data

  url <- "https://datosabiertos.gob.ec/dataset/8d92cf9f-1ad6-4222-b90a-00d65897ac8c/resource/2fcf0866-9a30-4a01-a9ae-c5559cc53270/download/pre_presupuestojuniagosto_pm_2021_agosto.ods"
  x <- pdae_read_data(url)
  d <- x$data


  # ODS Metadata
  url <- "https://datosabiertos.gob.ec/dataset/30ff5330-c2c2-455f-b2a8-66d8d3ce76e4/resource/8837a7cf-9e2c-457e-824e-b3ed1518cede/download/igm_aptitud_fisica_constructiva_machala_pm_2021noviembre.ods"
  url <- "https://datosabiertos.gob.ec/dataset/6213e4f5-0e5b-4582-9150-8f8098dcbef5/resource/be96c462-b698-4bcc-9f71-dab18e51ce14/download/appb_reportemovimientobuque_pm_2022_3.ods"
  x <- pdae_read_data(url)
  d <- x$data

  # PDF
  url <- "https://datosabiertos.gob.ec/dataset/289448cd-848c-4dea-8f76-d54fd9e3d589/resource/da698d45-74b9-4d7c-b30c-0c30c6e477ba/download/fichametodologicateletrabajo.pdf"
  expect_true(is.null(pdae_read_data(url)))

  # RAR
  url <- "https://datosabiertos.gob.ec/dataset/ec789f77-42f5-41f4-9b76-b9001ab836f0/resource/13620de4-a2c6-4ad9-8625-3ac371eecbf1/download/mef_distributivoremuneraciones_2022junio.rar"
  x <- pdae_read_data(url)
  expect_error(x$error, "Formato no definido para visualizar (rar)")

  # GEO
  url <- "https://datosabiertos.gob.ec/dataset/eafdd8e8-3b8c-45b2-a43d-4abbb651a474/resource/ccb60429-5b58-4a68-bc31-e5fd7c338b92/download/cnii_asistenciatecnica_2021septiembre.csv"
  url <- "https://datosabiertos.gob.ec/dataset/acfa5c91-62d1-45aa-b9ed-6bd2ce0bd572/resource/6488d0a5-0b13-4573-92ee-6224d6a21bee/download/maate_bvp_2021diciembre.csv"
  url <- "https://datosabiertos.gob.ec/dataset/e93247cc-10d5-4815-925e-7c5afb4ccf52/resource/79fc42d8-0e29-410e-a239-a90071ca2e95/download/maate_biosfera_2021diciembre.csv"

  # Non existing

  url <-"http://www.geoportaligm.gob.ec/p_afc/f_paisaje/wms/kml?layers=f_paisaje%3Af_paisajistica_quito_p"
  x <- pdae_read_data(url)
  d <- x$data


  # Random
  url <- pdae_rscr_sample()
  url
  x <- pdae_read_data(url)
  x$name
  x$description
  x$format
  d <- x$data

  ## TODO list resources for a given dataset
  pkg_id <- x$package_id
  p <- ckanr::package_show(pkg_id)
  rscrs <- p$resources

})





test_that("ckan info", {

  # File with format (xlsx) != ext (csv)
  url <- "https://datosabiertos.gob.ec/dataset/344c5c88-b1ea-4f37-b3c6-691e79380a77/resource/e6ef28df-38a9-4095-8ea1-d1b55d6ad3c1/download/sngre_inclusionriesgopdot_2021diciembre-.csv"
  x <- pdae_read_data(url)
  x$name
  x$description
  x$format
  d <- x$data


  url <- "https://datosabiertos.gob.ec/dataset/ee526d74-3fed-4927-886d-ac2bc9b6d753/resource/267cb022-1474-4b74-b8ac-8ae78caf0423/download/sdh_vacunacion_a_comunidades_waorani_zitt_pm_2021-julio.xlsx"
  x <- pdae_read_data(url)
  d <- x$data

  url <- "https://datosabiertos.gob.ec/dataset/d9ea8e2f-bc7c-4523-93dc-3ceeafd231aa/resource/f916a191-ffef-404d-bec9-e42b251d290a/download/sngre_sensibilizaciongrd_dd_2021diciembre-.xlsx"


  # Not found
  url <- "https://www.sri.gob.ec/o/sri-portlet-biblioteca-alfresco-internet/descargar/2bbf016e-0f1f-4279-be11-1847cca2350b/sri_recaudacion_2021.csv"



  url <- "https://datosabiertos.gob.ec/dataset/32c43003-2121-40cb-b85d-55900a80428c/resource/433c09a8-af37-4dfa-9875-4bf4884cca77/download/mef_ejecucionnominas_pm_2021agosto_v2.ods"
  x <- pdae_read_data(url)
  d <- x$data
  sheets <- x$sheets

  # resource url
  #"https://www.sri.gob.ec/o/sri-portlet-biblioteca-alfresco-internet/descargar/1e06937a-4286-4835-bc5c-69c266713530/SRI_Diccionario_Ventas.xlsx"


  #?lang=es&data=https://datosabiertos.gob.ec/dataset/58d7ee01-3fd0-4d06-af4d-81ba32664629/resource/d5dae692-3808-44ac-a131-dea524f7c560/download/epaep_matrizreportemensualcac_2021agosto.ods
  #&resource=/dataset/consulta-de-valores-de-pago-por-el-recurso-h-drico-y-numero-de-usuarios-facturados/resource/d5dae692-3808-44ac-a131-dea524f7c560&origin=https://datosabiertos.gob.ec


  # XLSX

  # External SRI
  # https://datosabiertos.gob.ec/dataset/recaudacion-de-impuestos-2022/resource/e7a6e4a8-72b7-4863-ad97-a3f6b7872581




})
