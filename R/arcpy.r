#' R Interface to ArcPy
#'
#' An R interface for the ArcGIS Python module \code{arcpy}. Relies on 
#' the virtual Python environment provided by \code{PythonInR} to generate 
#' function interfaces for \code{arcpy} tools and environment settings.
#' \code{arcpy} toolboxes and extensions are accessed via an R environment
#' object. See the vignette to get started.
#' @name arcpyr-package
#' @aliases arcpyr
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

