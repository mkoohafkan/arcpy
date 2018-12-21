#' R Interface to ArcPy
#'
#' An R interface for the ArcGIS Python module \code{arcpy} via the 
#' R-Python interface provided by reticulate. See the vignettes to get
#' started.
#'
#' @name arcpy-package
#' @aliases arcpy
#' @docType package
#' @md
#' @seealso \code{\link{use_ArcGIS}}
NULL

#' ArcPy Module
#'
#' The arcpy module.
#'
#' @export
arcpy = NULL

#' @importFrom reticulate import
.onLoad <- function(libname, pkgname) {
  arcpy <<- import("arcpy", delay_load = TRUE)
}

#' @importFrom reticulate py_help
#' @export
reticulate::py_help
