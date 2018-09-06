#' List Attribute Table Fields
#'
#' Read attribute table field names with arcpy.da module.
#'
#' @param table.path The file path to the table.
#' @return A vector of field names.
#'
#' @export
da_fields = function(table.path) {
  field.objects = arcpy$ListFields(table.path)
  unlist(lapply(field.objects, function(x) x$name))
}

#- Fields Exist
#-
#- Check if specified fields are present in a table.
#-
#- @param table.path The file path to the table.
#- @param fields The field names.
#- @return No return value; will produce an error if any of the 
#-   specified fields are not present in the table.
#-
fields_exist = function(table.path, fields) {
  actual = da_fields(table.path)
  res = fields %in% actual
  if (!all(res))
    stop("Specified fields do not exist in table: ", 
      paste(fields[!res], sep = ", "), call. = FALSE)
  invisible(NULL)
}


#' Read Table with arcpy.da
#'
#' Read a table (e.g. attribute table of a layer) with the arcpy.da module.
#'
#' @param table.path The file path to the table.
#' @param fields A vector of field names or column indices to retrieve.
#' @param simplify If \code{TRUE}, coerce the results to a data.frame. If
#'   \code{FALSE}, the results will be returned as a list of lists, with
#'   each top-level element corresponding to one row of the table.
#' @return a dataframe with columns corresponding to \code{fields}.
#' 
#' @details This implementation may be faster than accessing the
#'   \code{@data} slot of an object created from \code{rgdal::readOGR}
#'   in cases where there are a very large number of features. An 
#'   additional advantage of \code{da_read} is that it can read 
#'   raster attribute tables and stand-alone tables stored in file
#'   geodatabases, which is not supported by \code{rgdal::readOGR}.
#'
#' @examples
#' \dontrun{
#' layer = "path/to/table"
#' fields = c("VALUE", "NOTE")
#' da_read(layer, fields)
#' }
#'
#' @importFrom stats setNames
#' @importFrom reticulate %as% iterate
#' @export
da_read = function(table.path, fields, simplify = TRUE) {
  if (missing(fields))
    fields = da_fields(table.path)
  if (is.numeric(fields))
    fields = da_fields(table.path)[fields]
  # check that fields are valid
  fields_exist(table.path, fields)
  with(arcpy$da$SearchCursor(table.path, fields) %as% cursor, {
    res = iterate(cursor, function(x) x)
  })
  res = lapply(res, setNames, fields)
  if (!simplify)
    return(res)
  # replace NULLs with NAs
  res = lapply(res, function(x) lapply(x, function(xx)
    ifelse(is.null(xx), NA, xx)))
  col.classes = unique(do.call(rbind, lapply(res, lapply, is.atomic)))
  not.valid = sapply(col.classes, isFALSE)
  if (any(not.valid) && simplify) {
    if (!requireNamespace("tibble")) {
      warning('Package "tibble" is required to read list columns. ',
        "The following fields could not be read: ",
        paste(fields[not.valid], collapse = ", "))
      do.call(rbind, lapply(res, function(x)
        as.data.frame(x[!not.valid], stringsAsFactors = FALSE)))
      } else {
#        for (i in seq_along(res))
#          res[[i]][not.valid] = lapply(res[[i]][not.valid], list)
        do.call(rbind, lapply(res, function(x)
          as_tibble(x, stringsAsFactors = FALSE)))
      }
  } else {
    do.call(rbind, lapply(res, function(x)
      as.data.frame(x[!not.valid], stringsAsFactors = FALSE)))
  }
}

#' Update Table with arcpy.da
#'
#' Update a table (e.g. attribute table of a layer) with the 
#' arcpy.da module.
#'
#' @param table.path The file path to the table.
#' @param d The data to write to \code{table.path}, with the same number 
#'   of rows as the table. Column names must match field names 
#'   of the table.
#' @return (Invisible) The path to the table, i.e. \code{table.path}.
#'
#' @examples
#' \dontrun{
#' layer = "path/to/table"
#' fields = c("VALUE", "NOTE")
#' d = da_read(layer, fields)
#' d["VALUE"] = d$VALUE + 5
#' d["NOTE"] = "modified"
#' da_update(layer, d)
#' }
#'
#' @importFrom stats setNames
#' @importFrom reticulate %as% iter_next
#' @export
da_update = function(table.path, d) {

  fields = names(d)
  fields_exist(table.path, fields)

  with(arcpy$da$UpdateCursor(table.path, fields) %as% cursor, {
    i = 0
    while (TRUE) {
    item = iter_next(cursor)
    if (is.null(item))
      break
      i = i + 1
    cursor$updateRow(setNames(as.list(d[i, fields]), NULL))
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
#' @param d The data to write to \code{table.path}, with the same number 
#'   of rows as the table. Column names must match field names 
#'   of the table.
#' @return (Invisible) The path to the table, i.e. \code{table.path}.
#'
#' @examples
#' \dontrun{
#' layer = "path/to/table"
#' fields = c("VALUE", "NOTE")
#' d = da_read(layer, fields)
#' add.d = data.frame(VALUE = 5, NOTE = "NEW",
#'   stringsAsFactors = FALSE)
#' da_insert(layer, add.d)
#' }
#'
#' @importFrom stats setNames
#' @importFrom reticulate %as%
#' @export
da_insert = function(table.path, d) {
  fields = names(d)
  fields_exist(table.path, fields)
  with(arcpy$da$InsertCursor(table.path, fields) %as% cursor, {
    for (i in 1:nrow(d))
      cursor$insertRow(setNames(as.list(d[i, fields]), NULL))
  })
  invisible(table.path)
}
