#' @importFrom reticulate import
.onLoad <- function(libname, pkgname) {
  # import modules
  arcpy <<- import("arcpy", delay_load = TRUE)
  arcgis <<- import("arcgis", delay_load = TRUE)
  # look for ArcGIS Pro by default if option not defined
  if (is.null(getOption("arcpy.pro"))) {
    options(arcpy.pro = TRUE)
  }
}
