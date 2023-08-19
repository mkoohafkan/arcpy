.onLoad <- function(libname, pkgname) {
  # import modules
  arcpy <<- reticulate::import("arcpy", delay_load = list(priority = 1,
    environment = "r-arcpy"))
  arcgis <<- reticulate::import("arcgis", delay_load = list(priority = 2,
    environment = "r-arcpy"))
  # look for ArcGIS Pro by default if option not defined
  invisible(TRUE)
}
