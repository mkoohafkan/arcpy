#' @importFrom reticulate import
.onLoad <- function(libname, pkgname) {
  # create a connection environment, used to flag if arcpy is loaded
  loadenv = new.env(parent = getNamespace(pkgname))
  assign("loadenv", loadenv, envir = getNamespace(pkgname))
  assign("arcpy_env", NULL, envir = loadenv)
  # import modules
  arcpy <<- import("arcpy", delay_load = TRUE)
  arcgis <<- import("arcgis", delay_load = TRUE)
  # look for ArcGIS Pro by default if option not defined
  invisible(TRUE)
}
