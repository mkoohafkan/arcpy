#' List Attribute Table Fields
#'
#' Read attribute table field names with `arcpy.da`` module.
#'
#' @param table.path The file path to the table.
#' @return A vector of field names.
#'
#' @examples
#' \dontrun{
#' arcpy$env$workspace = tempdir()
#' arcpy$env$scratchWorkspace = tempdir()
#' fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
#'   "CA_Counties_TIGER2016.shp", package = "arcpy"), "CA_Counties")
#' da_fields(fc)
#' }
#'
#' @export
da_fields = function(table.path) {
  field.objects = arcpy$ListFields(table.path)
  unlist(lapply(field.objects, function(x) x$name))
}


#' List Field Tokens
#'
#' Return a list of possible field tokens.
#'
#' @return A vector of field names.
#'
#' @details Possible tokens are listed below. Note that not
#'  all tokens are valid for all geometries.
#'
#' * OID@ The OBJECTID for the feature.
#' * SHAPE@ A geometry object for the feature.
#' * SHAPE@XY A tuple of the feature's centroid x,y coordinates.
#' * SHAPE@TRUECENTROID A tuple of the feature's true centroid
#'   x, y coordinates.
#' * SHAPE@X A double of the feature's x-coordinate.
#' * SHAPE@Y A double of the feature's y - coordinate.
#' * SHAPE@Z A double of the feature s z-coordinate.
#' * SHAPE@M A double of the feature's m - value.
#' * SHAPE@JSON The esri JSON string representing the geometry.
#' * SHAPE@WKB The well-known binary(WKB) representation for
#'   OGC geometry. It provides a portable representation of a
#'   geometry value as a contiguous stream of bytes.
#' * SHAPE@WKT The well-known text(WKT) representation for
#'   OGC geometry. It provides a portable representation of a
#'   geometry value as a text string.
#' * SHAPE@AREA A double of the feature 's area.
#' * SHAPE@LENGTH A double of the feature' s length.
#'
#' @keywords internal
tokens = c("OID@", "SHAPE@", "SHAPE@XY", "SHAPE@TRUECENTROID",
    "SHAPE@X", "SHAPE@Y", "SHAPE@Z", "SHAPE@M", "SHAPE@JSON",
    "SHAPE@WKB", "SHAPE@WKT", "SHAPE@AREA", "SHAPE@LENGTH")


#' Fields Exist
#'
#' Check if specified fields are present in a table.
#'
#' @param table.path The file path to the table.
#' @param fields The field names.
#' @return No return value; will produce an error if any of the
#'   specified fields are not present in the table.
#'
#' @keywords internal
fields_exist = function(table.path, fields) {
  actual = da_fields(table.path)
  res = fields %in% c(actual, tokens)
  if (!all(res)) {
    stop("Specified fields do not exist in table: ",
      paste(fields[!res], collapse = ", "), call. = FALSE)
  }
  invisible(NULL)
}


#' Read Table with arcpy.da
#'
#' Read a table (e.g. attribute table of a layer) with the
#' `arcpy.da` module.
#'
#' @param table.path The file path to the table.
#' @param fields A vector of field names or column indices to retrieve.
#' @param simplify If `TRUE`, coerce the results to a data.frame. If
#'   `FALSE`, the results will be returned as a list of lists, with
#'   each top-level element corresponding to one row of the table.
#' @return a dataframe with columns corresponding to `fields`.
#'
#' @details This implementation may be faster than accessing the
#'   `@data` slot of an object created from `rgdal::readOGR`
#'   in cases where there are a very large number of features. An
#'   additional advantage of `da_read` is that it can read
#'   raster attribute tables and stand-alone tables stored in file
#'   geodatabases, which is not supported by `rgdal::readOGR`.
#'
#' @examples
#' \dontrun{
#' arcpy$env$workspace = tempdir()
#' arcpy$env$scratchWorkspace = tempdir()
#' fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
#'   "CA_Counties_TIGER2016.shp", package = "arcpy"), "CA_Counties")
#' da_read(fc, c("COUNTYFP", "ALAND"))
#' }
#'
#' @importFrom stats setNames
#' @importFrom reticulate %as% iterate
#' @export
da_read = function(table.path, fields, simplify = TRUE) {
  cursor = NULL

  if (missing(fields)) {
    fields = da_fields(table.path)
  }
  if (is.numeric(fields)) {
    fields = da_fields(table.path)[fields]
  }
  # check that fields are valid
  fields_exist(table.path, fields)
  with(arcpy$da$SearchCursor(table.path, fields) %as% cursor, {
    res = iterate(cursor, function(x) x)
  })
  res = lapply(res, setNames, fields)
  if (!simplify) {
    return(res)
  }
  # replace NULLs with NAs
  res = lapply(res, function(x) lapply(x, function(xx)
    if (is.null(xx)) NA else xx))
  col.classes = unique(do.call(rbind, lapply(res, lapply, is.atomic)))
  not.valid = sapply(col.classes, isFALSE)
  if (any(not.valid) && simplify) {
    if (!requireNamespace("tibble")) {
      warning("Package \"tibble\" is required to read list columns. ",
        "The following fields could not be read: ",
        paste(fields[not.valid], collapse = ", "))
      do.call(rbind, lapply(res, function(x)
        as.data.frame(x[!not.valid], stringsAsFactors = FALSE)))
      } else {
        for (i in seq_along(res)) {
          res[[i]][not.valid] = lapply(res[[i]][not.valid], list)
        }
        do.call(rbind, lapply(res, function(x)
          tibble::as_tibble(x, stringsAsFactors = FALSE)))
      }
  } else {
    do.call(rbind, lapply(res, function(x)
      as.data.frame(x[!not.valid], stringsAsFactors = FALSE)))
  }
}


#' Update Table with arcpy.da
#'
#' Update a table (e.g., attribute table of a layer) with the
#' arcpy.da module.
#'
#' @param table.path The file path to the table.
#' @param d The data to write to `table.path`, with the same number
#'   of rows as the table. Column names must match field names
#'   of the table.
#' @return (Invisible) The path to the table, i.e. `table.path`.
#'
#' @examples
#' \dontrun{
#' arcpy$env$workspace = tempdir()
#' arcpy$env$scratchWorkspace = tempdir()
#' fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
#'   "CA_Counties_TIGER2016.shp", package = "arcpy"), "CA_Counties")
#' d = da_read(fc, "ALAND")
#' d["ALAND"] = d$ALAND+ 5000
#' da_update(fc, d)
#' }
#'
#' @importFrom stats setNames
#' @importFrom reticulate %as% iter_next
#' @export
da_update = function(table.path, d) {
  cursor = NULL

  fields = names(d)
  fields_exist(table.path, fields)
  with(arcpy$da$UpdateCursor(table.path, fields) %as% cursor, {
    i = 0L
    while (TRUE) {
      item = iter_next(cursor)
      if (is.null(item)) {
        break
      }
      i = i + 1L
      cursor$updateRow(lapply(seq_len(ncol(d)), function(j) d[[j]][[i]]))
    }
  })
  invisible(table.path)
}


#' Table Insertion with arcpy.da
#'
#' Insert records into a table (e.g. attribute table of a layer)
#' with the arcpy.da module.
#'
#' @param table.path The file path to the table.
#' @param d The data to write to `table.path`, with the same number
#'   of rows as the table. Column names must match field names
#'   of the table.
#' @return (Invisible) The path to the table, i.e. `table.path`.
#'
#' @examples
#' \dontrun{
#' arcpy$env$workspace = tempdir()
#' arcpy$env$scratchWorkspace = tempdir()
#' fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
#'   "CA_Counties_TIGER2016.shp", package = "arcpy"), "CA_Counties")
#' d = da_read(fc, c("ALAND", "CLASSFP"))
#' add.d = data.frame(ALAND= 1e4, CLASSFP = "H2",
#'   stringsAsFactors = FALSE)
#' da_insert(fc, add.d)
#' }
#'
#' @importFrom stats setNames
#' @importFrom reticulate %as%
#' @export
da_insert = function(table.path, d) {
  cursor = NULL

  fields = names(d)
  fields_exist(table.path, fields)
  with(arcpy$da$InsertCursor(table.path, fields) %as% cursor, {
    for (i in seq_len(nrow(d))) {
      cursor$insertRow(lapply(seq_len(ncol(d)), function(j) d[[j]][[i]]))
    }
  })
  invisible(table.path)
}


#' Table Row Removal with arcpy.da
#'
#' Drop records from a table (e.g. attribute table of a layer)
#' with the arcpy.da module.
#'
#' @param table.path The file path to the table.
#' @param rows The row indexes to drop.
#' @return (Invisible) The path to the table, i.e. `table.path`.
#'
#' @examples
#' \dontrun{
#' arcpy$env$workspace = tempdir()
#' arcpy$env$scratchWorkspace = tempdir()
#' fc = arcpy$management$CopyFeatures(system.file("CA_Counties",
#'   "CA_Counties_TIGER2016.shp", package = "arcpy"), "CA_Counties")
#' d = da_read(fc, c("STATEFP", "COUNTYFP"))
#' drop.rows = which(d$STATEFP == "06" & d$COUNTYFP == "067")
#' da_drop(fc, drop.rows)
#' }
#'
#' @importFrom reticulate %as%
#' @export
da_drop = function(table.path, rows) {
  cursor = NULL

  rows = as.integer(rows)
  fields = da_fields(table.path)
  with(arcpy$da$UpdateCursor(table.path, fields) %as% cursor, {
    i = 0L
    while (TRUE) {
      item = iter_next(cursor)
      if (is.null(item)) {
        break
      }
      i = i + 1L
      if (i %in% rows) {
        cursor$deleteRow()
      }
    }
  })
  invisible(table.path)
}
