test_that("arcpy can be loaded", {
  skip_if_no_arcgis()

  expect_type(arcpy$GetInstallInfo(), "list")
})
