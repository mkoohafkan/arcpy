#' Find ArcGIS Installation
#'
#' Attempt to automatically locate an ArcGIS installation.
#'
#' @param pro If \code{TRUE}, Search for ArcGIS Pro 
#'   Python distribution. Otherwise, search for ArcGIS 
#'   Desktop Python distribution. 
#' @return Path(s) to ArcGIS Python distributions.
#'
#' @export
find_ArcGIS = function(pro = FALSE) {
  if (!pro) {
    if (.Platform$r_arch == "x64") {
      python_folder = file.path("C:/Python27",
        dir("C:/Python27")[grepl("ArcGIS.*x64", dir("C:/Python27"))])
      arch = "64bit"
    } else {
      python_folder = file.path("C:/Python27",
        dir("C:/Python27")[grepl("ArcGIS.*", dir("C:/Python27")) &
          !(grepl("ArcGIS.*x64", dir("C:/Python27")))])
      arch = "32bit"
    }
    if (length(python_folder) > 1)
      warning("Multiple ArcGIS Desktop Python binaries found.")
    if (length(python_folder) < 1)
      stop("Could not find ArcGIS Desktop Python binary.")
    return(python_folder)
  } else {
    stop("ArcGIS Pro not supported")
  }
}

#' Connect to ArcGIS Python
#'
#' Connect to the ArcGIS Python environment. 
#'
#' @param python Path to ArcGIS Python binary.
#'   If missing, the function will attempt to automatically 
#'   detect an appropriate Python installation.
#' @param pro If \code{TRUE}, attempt to connect to an ArcGIS Pro 
#'   Python distribution. Otherwise, attempt to connect to an ArcGIS 
#'   Desktop Python distribution. Ignored if \code{python} is provided.
#' @return No return value.
#'
#' @examples
#' \dontrun{
#' # Try to autodetect
#' use_ArcGIS()
#'
#' # connect to the 32-bit ArcGIS Desktop 10.2 Python environment
#' use_ArcGIS("C:/Python27/ArcGIS10.2")
#'
#' }
#'
#' @export
use_ArcGIS = function(python, pro = FALSE) {
  if (missing(python))
    python = find_ArcGIS(pro)
  if (length(python) > 1)
    warning("Multiple Python binaries provided. Using ", python[[1]])
  reticulate::use_python(python[[1]], require = TRUE)
  invisible(NULL)
}
