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
#' @name RasterAlgebra
#' @seealso \code{\link[base]{Arithmetic}}, \code{\link[base]{Comparison}}, 
#'  \code{\link[base]{bitwNot}}.
NULL

# arithmetic operators

#' @export
"+.python.builtin.Raster" <- function(a, b) {
  if (missing(b))
    ops$pos(a)
  else
    ops$add(a, b)
}

#' @export
"-.python.builtin.Raster" <- function(a, b) {
  if (missing(b))
    ops$neg(a)
  else
    ops$sub(a, b)
  }


#' @export
"*.python.builtin.Raster" <- function(a, b) {
  ops$mul(a, b)
}

#' @export
"/.python.builtin.Raster" <- function(a, b) {
  ops$truediv(a, b)
}

#' @export
"^.python.builtin.Raster" <- function(a, b) {
  ops$pow(a, b)
}

#' @export
"**.python.builtin.Raster" <- function(a, b) {
  ops$pow(a, b)
}

#' @export
"%/%.python.builtin.Raster" <- function(a, b) {
  ops$floordiv(a, b)
}

#' @export
"%%.python.builtin.Raster" <- function(a, b) {
  ops$mod(a, b)
}


# logical operators

#' @export
"<.python.builtin.Raster" <- function(a, b) {
  ops$lt(a, b)
}

#' @export
">.python.builtin.Raster" <- function(a, b) {
  ops$gt(a, b)
}

#' @export
"<=.python.builtin.Raster" <- function(a, b) {
  ops$le(a, b)
}

#' @export
">=.python.builtin.Raster" <- function(a, b) {
  ops$ge(a, b)
}

#' @export
"!=.python.builtin.Raster" <- function(a, b) {
  ops$ne(a, b)
}

#' @export
"==.python.builtin.Raster" <- function(a, b) {
  ops$eq(a, b)
}

#' @export
"!.python.builtin.Raster" <- function(a) {
  ops$not_(a)
}

#' @export
"&.python.builtin.Raster" <- function(a, b) {
  ops$and_(a, b)
}

#' @export
"|.python.builtin.Raster" <- function(a, b) {
  ops$or_(a, b)
}

#' @export
xor.python.builtin.Raster <- function(a, b) {
  ops$xor(a, b)
}


# bitwise operators

#' @export
bitwNot.python.builtin.Raster <- function(a) {
  ops$invert(a)
}

#' @export
bitwAnd.python.builtin.Raster <- function(a, b) {
  ops$and_(a, b)
}

#' @export
bitwOr.python.builtin.Raster <- function(a, b) {
  ops$or_(a, b)
}

#' @export
bitwXor.python.builtin.Raster <- function(a, b) {
  ops$xor_(a, b)
}

#' @export
bitwShiftL.python.builtin.Raster <- function(a, n) {
  ops$lshift(a, n)
}

#' @export
bitwShiftR.python.builtin.Raster <- function(a, n) {
  ops$rshift(a, n)
}
