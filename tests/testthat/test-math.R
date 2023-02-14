test_that("arcpy raster math works", {
  skip_on_cran()
  skip_if_no_arcgis()

  expect_max_equal = function(raster, value) {
    raster.max = as.numeric(arcpy$management$GetRasterProperties(raster,
      "MAXIMUM")[[0]])
    expect_equivalent(raster.max, value)
  }

  arcpy$env$workspace = tempdir()
  arcpy$env$scratchWorkspace = tempdir()
  arcpy$CheckOutExtension("Spatial")

  cellSize = 2
  outExtent = arcpy$Extent(0, 0, 20, 20)
  raster1 = arcpy$sa$CreateConstantRaster(2, "FLOAT",
    cellSize, outExtent)
  raster2 = arcpy$sa$CreateConstantRaster(3, "FLOAT",
    cellSize, outExtent)

  expect_max_equal(raster1 + raster2, 5)
  expect_max_equal(raster1 * raster2, 6)
  expect_max_equal(raster1 ^ raster2, 8)
  expect_max_equal(raster1 %% raster2, 2)
  expect_max_equal(raster1 %/% raster2, 0)

  expect_max_equal(raster1 > 1, 1)
  expect_max_equal(raster1 > 2, 0)
  expect_max_equal(raster1 >= 2, 1)
  expect_max_equal(raster1 > raster2, 0)
  expect_max_equal(raster1 < raster2, 1)

  expect_max_equal((raster1 > raster2) & (raster2 > 2), 0)
  expect_max_equal((raster1 > raster2) | (raster2 > 2), 1)

  arcpy$CheckInExtension("Spatial")

})
