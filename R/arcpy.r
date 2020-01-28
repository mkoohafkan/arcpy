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
#'   \item `arcpy.pro`: (Logical) use ArcGIS Pro by default.
#'   \item `arcpy.installpath`: (Character) The default install path of ArcGIS Pro.
#'   \item `arcpy.condaenv`: (Character) The default path to the ArcGIS Pro Conda environment.
#'   \item `arcpy.pythonpath`: (Character) The default path to the ArcGIS Desktop Python installation.
#' }
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
#' mygis = arcgis$gis$GIS()
#' }
#'
#' @export
arcpy = NULL


#' @importFrom reticulate py_help
#' @export
reticulate::py_help
