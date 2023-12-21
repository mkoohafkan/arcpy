.onLoad <- function(libname, pkgname) {
  # import modules
  arcpy <<- reticulate::import("arcpy", delay_load = list(priority = 5,
    environment = "r-arcpy"))
  arcgis <<- reticulate::import("arcgis", delay_load = list(priority = 10,
    environment = "r-arcpy"))
  invisible(TRUE)
}
