test_that("attribute table helper functions work", {
  skip_on_cran()
  skip_if_no_arcgis()

  arcpy$env$workspace = tempdir()
  arcpy$env$scratchWorkspace = tempdir()
  fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
    "CA_Counties_TIGER2016.shp", package = "arcpy"), "CA_Counties")

  # reading attribute tables
  expect_type(da_fields(fc), "character")
  expect_s3_class(da_read(fc, fields = c("FID", "NAME")),
    "data.frame")
  expect_s3_class(
    da_read(fc, fields = c("OID@", "NAME", "SHAPE@TRUECENTROID")),
    "tbl_df"
  )

  # updating attribute tables
  d = da_read(fc, "ALAND")

  d["ALAND"] = d$ALAND + 5000
  da_update(fc, d)
  new.d = da_read(fc, "ALAND")
  expect_equivalent(d$ALAND, new.d$ALAND)

  # inserting rows
  d = da_read(fc, c("ALAND", "CLASSFP"))
  add.d = data.frame(ALAND= 1e4, CLASSFP = "H2",
    stringsAsFactors = FALSE)
  da_insert(fc, add.d)
  new.d = tail(da_read(fc, c("ALAND", "CLASSFP")), 1)
  arcpy$management$Delete(fc)
  expect_equivalent(new.d, add.d)

  # dropping rows
  fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
    "CA_Counties_TIGER2016.shp", package = "arcpy"), "CA_Counties")
  d = da_read(fc, c("STATEFP", "COUNTYFP"))
  drop.rows = which(d$STATEFP == "06" & d$COUNTYFP == "067")
  da_drop(fc, drop.rows)
  new.d = da_read(fc, c("STATEFP", "COUNTYFP"))
  expect_equal(which(new.d$STATEFP == "06" & new.d$COUNTYFP == "067"),
    integer(0))

  arcpy$management$Delete(fc)
})
