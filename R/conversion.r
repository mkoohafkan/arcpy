#' R to/from ArcGIS Object
#'
#' Convert rasters and features between R and ArcGIS.
#'
#' @param x A raster or feature.
#' @param ... Reservered for future expansion.
#' @return For `to_arcpy()`, an ArcGIS raster or feature layer.
#'   For `from_arcpy()`, a `SpatRaster` or `sf` object.
#'
#' @export
to_arcpy = function(x, ...) {
  if (inherits(x, "SpatRaster")) {
    raster_to_arcpy(x, ...)
  } else if (inherits(x, "sf")) {
    feature_to_arcpy(x, ...)
  } else {
    stop(sprintf("Conversion of %s to arcpy not supported.",
        class(x)[1]))
  }
}


#' @rdname to_arcpy
#' @export
from_arcpy = function(x, ...) {
  if (inherits(x, "python.builtin.Raster")) {
    raster_from_arcpy(x, ...)
  } else if (inherits(x, "arcpy.arcobjects.arcobjects.Result")) {
    feature_from_arcpy(x, ...)
  } else {
    stop(sprintf("Conversion of %s to arcpy not supported.",
        class(x)[1]))
  }
}


###########
# rasters #
###########


#' Raster To ArcGIS Object
#'
#' Convert a `SpatRaster` object to ArcGIS.
#'
#' @param x A `SpatRaster` object.
#' @param ... Reserved for future expansion.
#' @return An ArcGIS Raster object.
#'
#' @keywords internal
raster_to_arcpy = function(x, ...) {
  requireNamespace("terra")
  tf = tempfile(fileext = ".tif")
  terra::writeRaster(x, tf)
  arcpy$Raster(tf)
}


#' Raster From ArcGIS Object
#'
#' Convert an ArcGIS raster object to a `SpatRaster` object.
#'
#' @param x An ArcGIS raster object.
#' @param ... Reserved for future expansion.
#' @return A `SpatRaster` object.
#'
#' @keywords internal
raster_from_arcpy = function(x, ...) {
  requireNamespace("terra")
  if (file.exists(normalizePath(as.character(x), mustWork = FALSE))) {
    terra::rast(normalizePath(as.character(x), mustWork = TRUE))
  } else {
    tf = tempfile(fileext = ".tif")
    x$save(tf)
    terra::rast(tf)
  }
}

############
# features #
############

#' Feature To ArcGIS Object
#'
#' Convert an `sf` object to ArcGIS.
#'
#' @param x An `sf` object.
#' @param ... Reserved for future expansion.
#' @return An ArcGIS vector object.
#'
#' @keywords internal
feature_to_arcpy = function(x, ...) {
  requireNamespace("sf")
  tf = tempfile(fileext = ".geojson")
  out = tempfile(fileext = ".geojson")
  sf::st_write(x, tf)
  arcpy$conversion$JSONToFeatures(tf, out)
}


#' Feature From ArcGIS Object
#'
#' Convert an ArcGIS object to an `sf` object.
#'
#' @param x An ArcGIS vector object.
#' @param ... Reserved for future expansion.
#' @return A `sf` object.
#'
#' @keywords internal
feature_from_arcpy = function(x, ...) {
  requireNamespace("sf")
  if (file.exists(normalizePath(as.character(x), mustWork = FALSE))) {
    sf::st_read(normalizePath(as.character(x), mustWork = TRUE))
  } else {
    tf = tempfile(fileext = ".geojson")
    res = arcpy$conversion$FeaturesToJSON(x, tf, geoJSON = "GEOJSON")
    sf::st_read(tf)
  }
}
