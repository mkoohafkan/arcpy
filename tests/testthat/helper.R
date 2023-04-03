skip_if_no_arcgis = function() {
  skip_on_cran()
  if (!require_arcpy(quietly = TRUE)) {
    skip("Could not connect to ArcGIS")
  }
}
