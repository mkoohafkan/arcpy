skip_if_no_arcgis = function() {
  skip_on_cran()
  if (!reticulate::py_module_available("arcpy")) {
    skip("Could not connect to ArcGIS")
  }
}
