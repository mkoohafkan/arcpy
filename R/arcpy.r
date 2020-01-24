#' Interface to ArcPy
#'
#' An interface to the ArcGIS \code{arcpy} Python module via the
#' R-Python interface provided by \code{reticulate}. Loading the
#' packages exposes the `arcpy` python module for accessing the
#' ArcGIS geoprocessor. See the vignettes to get started.
#'
#' @name arcpy-package
#' @aliases arcpy
#' @docType package
#' @md
#' @seealso \code{\link{use_ArcGIS}}, \code{\link{RasterAlgebra}}
NULL

#' @rdname arcpy-package
#' @format An object of class \code{python.builtin.module}.
#'
#' @examples
#' \dontrun{
#' use_ArcGIS()
#' arcpy$GetInstallInfo()
#' }
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
