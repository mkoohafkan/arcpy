ops = reticulate::import("operator")


#' @export
"+.python.builtin.Raster" <- function(a, b) {
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
  ops$xor(a, b)
}

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
  ops$and(a, b)
}

#' @export
"|.python.builtin.Raster" <- function(a, b) {
  ops$or(a, b)
}

#' @export
"%/%.python.builtin.Raster" <- function(a, b) {
  ops$floordiv(a, b)
}

#' @export
"%%.python.builtin.Raster" <- function(a, b) {
  ops$mod(a, b)
}

#' @export
"pow.python.builtin.Raster" <- function(a, b) {
  ops$pow(a, b)
}
