skip_if_no_arcgis = function() {
  connected = tryCatch({
    use_ArcGIS()
    TRUE
  }, error = function(e)
    FALSE
  )
  if (connected) {
    return(invisible(TRUE))
  }
  skip("Could not connect to ArcGIS")
}