#' Interface to ArcPy
#'
#' An interface to the ArcGIS `arcpy` Python module via the
#' R-Python interface provided by `reticulate`. Loading the
#' packages exposes the `arcpy` and `arcgis` python modules for
#' accessing the ArcGIS geoprocessor.
#' See the vignettes to get started.
#'
#' @name arcpy-package
#' @aliases arcpy
#' @docType package
#' @md
#' @seealso [install_arcpy()]
NULL


#' @importFrom reticulate py_help
#' @export
reticulate::py_help
