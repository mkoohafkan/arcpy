ops = reticulate::import("operator", delay_load = TRUE)

#' Arcpy Raster Algebra
#'
#' Operators for arcpy raster algebra.
#'
#' @param a,b arcpy raster objects.
#' @param n non-negative integer.
#'
#' @details The following operators are supported:
#'
#' Arithmetic Operators:
#' * `+`, `-`, and`/`
#' * `**` and `^`
#' * `%%` and `%/%`
#'
#' Logical Operators:
#' * `!`, `&`, `|`, and `xor`
#' * `!=` and `==`
#' * `<`, `<=`, `>`, and `>=`
#'
#' Bitwise Operators
#' * `bitwNot`, `bitwAnd`, `bitwOr` and `bitwXor`
#' * `bitwShiftL` and `bitwShiftR`
#'
#' @examples
#' \dontrun{
#' use_arcpy()
#' arcpy$env$workspace = tempdir()
#' arcpy$env$scratchWorkspace = tempdir()
#' arcpy$CheckOutExtension("Spatial")
#'
#' cellSize = 2
#' outExtent = arcpy$Extent(0, 0, 250, 250)

#' raster1 = arcpy$sa$CreateConstantRaster(12, "FLOAT",
#'   cellSize, outExtent)
#'
#' raster2 = arcpy$sa$CreateConstantRaster(6, "FLOAT",
#'   cellSize, outExtent)
#'
#' raster1 + raster2
#' raster1 * raster2
#' raster1 ^ raster2
#' raster1 %% raster2
#'
#' raster1 > raster2
#' (raster1 > raster2) & (raster2 > 7)
#' (raster1 > raster2) | (raster2 > 7)
#'
#' arcpy$CheckInExtension("Spatial")
#' }
#'
#' @name RasterAlgebra
#' @seealso \code{\link[base]{Arithmetic}},
#'   \code{\link[base]{Comparison}}, \code{\link[base]{bitwNot}}.
NULL


### Arithmetic Operators ###


#' @rdname RasterAlgebra
#' @export
"+.python.builtin.Raster" <- function(a, b) {
  if (missing(b))
    ops$pos(a)
  else
    ops$add(a, b)
}

#' @rdname RasterAlgebra
#' @export
"-.python.builtin.Raster" <- function(a, b) {
  if (missing(b))
    ops$neg(a)
  else
    ops$sub(a, b)
  }


#' @rdname RasterAlgebra
#' @export
"*.python.builtin.Raster" <- function(a, b) {
  ops$mul(a, b)
}

#' @rdname RasterAlgebra
#' @export
"/.python.builtin.Raster" <- function(a, b) {
  ops$truediv(a, b)
}

#' @rdname RasterAlgebra
#' @export
"^.python.builtin.Raster" <- function(a, b) {
  ops$pow(a, b)
}

#' @rdname RasterAlgebra
#' @export
"%/%.python.builtin.Raster" <- function(a, b) {
  ops$floordiv(a, b)
}

#' @rdname RasterAlgebra
#' @export
"%%.python.builtin.Raster" <- function(a, b) {
  ops$mod(a, b)
}


### logical operators ###


#' @rdname RasterAlgebra
#' @export
"<.python.builtin.Raster" <- function(a, b) {
  ops$lt(a, b)
}

#' @rdname RasterAlgebra
#' @export
">.python.builtin.Raster" <- function(a, b) {
  ops$gt(a, b)
}

#' @rdname RasterAlgebra
#' @export
"<=.python.builtin.Raster" <- function(a, b) {
  ops$le(a, b)
}

#' @rdname RasterAlgebra
#' @export
">=.python.builtin.Raster" <- function(a, b) {
  ops$ge(a, b)
}

#' @rdname RasterAlgebra
#' @export
"!=.python.builtin.Raster" <- function(a, b) {
  ops$ne(a, b)
}

#' @rdname RasterAlgebra
#' @export
"==.python.builtin.Raster" <- function(a, b) {
  ops$eq(a, b)
}

#' @rdname RasterAlgebra
#' @export
"!.python.builtin.Raster" <- function(a) {
  ops$not_(a)
}

#' @rdname RasterAlgebra
#' @export
"&.python.builtin.Raster" <- function(a, b) {
  ops$and_(a, b)
}

#' @rdname RasterAlgebra
#' @export
"|.python.builtin.Raster" <- function(a, b) {
  ops$or_(a, b)
}

#' @rdname RasterAlgebra
#' @method xor python.builtin.Raster
#' @export
"xor.python.builtin.Raster" <- function(a, b) {
  ops$xor(a, b)
}


### bitwise operators ###


#' @rdname RasterAlgebra
#' @method bitwNot python.builtin.Raster
#' @export
"bitwNot.python.builtin.Raster" <- function(a) {
  ops$invert(a)
}

#' @rdname RasterAlgebra
#' @method bitwAnd python.builtin.Raster
#' @export
"bitwAnd.python.builtin.Raster" <- function(a, b) {
  ops$and_(a, b)
}

#' @rdname RasterAlgebra
#' @method bitwOr python.builtin.Raster
#' @export
"bitwOr.python.builtin.Raster" <- function(a, b) {
  ops$or_(a, b)
}

#' @rdname RasterAlgebra
#' @method bitwXor python.builtin.Raster
#' @export
"bitwXor.python.builtin.Raster" <- function(a, b) {
  ops$xor_(a, b)
}

#' @rdname RasterAlgebra
#' @method bitwShiftL python.builtin.Raster
#' @export
"bitwShiftL.python.builtin.Raster" <- function(a, n) {
  ops$lshift(a, n)
}

#' @rdname RasterAlgebra
#' @method bitwShiftR python.builtin.Raster
#' @export
"bitwShiftR.python.builtin.Raster" <- function(a, n) {
  ops$rshift(a, n)
}
