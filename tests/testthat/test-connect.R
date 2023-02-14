test_that("arcpy can be loaded", {
  skip_on_cran()
  skip_if_no_arcgis()
  
  expect_warning(find_ArcGIS(pro = FALSE))
  expect_warning(find_ArcGIS(pro = TRUE), NA)
  expect_message(use_ArcGIS(pro = TRUE))
  expect_type(arcpy$GetInstallInfo(), "list")
})
