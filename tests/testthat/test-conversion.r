test_that("R to ArcGIS conversion works", {
  skip_if_no_arcgis()

  requireNamespace("sf")
  requireNamespace("terra")

  fc = sf::st_read(system.file("CA_Counties",
      "CA_Counties_TIGER2016.shp", package = "arcpy"))
  to_arcpy(fc)

})


test_that("ArcGIS to R conversion works", {
  skip_if_no_arcgis()

  arcpy$env$workspace = tempdir()
  arcpy$env$scratchWorkspace = tempdir()
  arcpy$CheckOutExtension("Spatial")

  raster1 = arcpy$sa$CreateConstantRaster(2, "FLOAT", 2,
    arcpy$Extent(0, 0, 20, 20))

  fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
      "CA_Counties_TIGER2016.shp", package = "arcpy"), tempfile())

  expect_s4_class(
    from_arcpy(raster1),
    "SpatRaster"
  )

  expect_s3_class(
    from_arcpy(fc),
    "sf"
  )

  bad1 = data.frame()
  bad2 = matrix(1:10, nrow = 2)
  expect_error(from_arcpy(bad1),
    sprintf("Conversion of %s to arcpy not supported.", class(bad1))
  )
  expect_error(from_arcpy(bad2),
    sprintf("Conversion of %s to arcpy not supported.", class(bad2)[1])
  )
})
