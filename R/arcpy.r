#' Interface to ArcPy
#'
#' An interface to the ArcGIS \code{arcpy} Python module via the
#' R-Python interface provided by \code{reticulate}. Loading the
#' packages exposes the `arcpy` python module for accessing the
#' ArcGIS geoprocessor. See the vignettes to get started.
#'
#' \code{arcpy} uses the following [options()] to configure behavior:
#'
#' \itemize{
#'   \item `arcpy.env`: The name of an ArcGIS conda environment, or the
#'     path to an ArcGIS Desktop Python binary.
#' }
#'
#' @name arcpy-package
#' @aliases arcpy
#' @docType package
#' @md
#' @seealso \code{\link{use_arcpy}}, \code{\link{RasterAlgebra}}
NULL

#' @rdname arcpy-package
#' @format An object of class \code{python.builtin.module}.
#'
#' @examples
#' \dontrun{
#' use_arcpy()
#' arcpy$GetInstallInfo()
#' mygis = arcgis$gis$GIS()
#' }
#'
#' @export
arcpy = NULL


#' @importFrom reticulate py_help
#' @export
reticulate::py_help
