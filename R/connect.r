#' Find ArcGIS Installation
#'
#' Attempt to automatically locate an ArcGIS installation.
#'
#' @param pro If `TRUE`, Search for ArcGIS Pro
#'   Python distribution. Otherwise, search for ArcGIS
#'   Desktop Python distribution.
#' @param required if `TRUE`, return an error if an arcpy
#'   environment cannot be found.
#' @return Path(s) to ArcGIS Python distributions.
#'
#' @seealso [`use_ArcGIS()`]
#'
#' @importFrom reticulate conda_list
#' @export
find_ArcGIS = function(pro = TRUE, required = TRUE) {
  if (required) {
    fail_fun = stop
  } else {
    fail_fun = warning
  }
  if (pro) {
    envpath = dirname(conda_list()[["python"]])
    envpath = envpath[grep("^(?=.*ESRI)(?=.*conda)", envpath,
      perl = TRUE)]
    if (length(envpath) > 1L) {
      warning("Multiple ArcGIS Pro environments found.")
    } else if (length(envpath) < 1L) {
      fail_fun("No ArcGIS Pro environments found.")
    }
    envpath
  } else {
    py_dir = file.path("C:/Python27", dir("C:/Python27"))
    py_dir = py_dir[grepl("ArcGIS.*", py_dir)]
    if (.Platform$r_arch == "x64") {
      py_dir = py_dir[grepl("ArcGIS.*x64", py_dir)]
    } else {
      py_dir = py_dir[!grepl("ArcGIS.*x64", py_dir)]
    }
    if (length(py_dir) > 1) {
      warning("Multiple ArcGIS Desktop Python binaries found.")
    } else if (length(py_dir) < 1) {
      fail_fun("No ArcGIS Desktop Python ", .Platform$r_arch,
        " binaries found.")
    }
    py_dir
  }
}

#' Connect to ArcGIS Python
#'
#' Connect to the ArcGIS Python environment.
#'
#' @param pro If `TRUE`, attempt to connect to an ArcGIS Pro
#'   Python distribution. Otherwise, attempt to connect to an ArcGIS
#'   Desktop Python distribution. Ignored if `pythonpath` is provided.
#' @param pythonpath if `pro = TRUE`, the path to the ArcGIS Pro Conda
#'   environment. If missing, the function will attempt to automatically
#'   detect the default Conda environment. If `Pro = FALSE`, the path to
#'   the ArcGIS Desktop Python binary. If missing, the function will
#'   attempt to automatically detect an appropriate Python installation.
#'
#' @details The following settings from [`options()`] will be used
#'  to populate missing arguments:
#'  * `arcpy.pro`: (Logical) use ArcGIS Pro.
#'  * `arcpy.installpath`: (Character) The install path of
#'     ArcGIS Pro.
#'  * `arcpy.condaenv`: (Character) The path to the
#'     ArcGIS Pro Conda environment.
#'  * `arcpy.pythonpath`: (Character) The path to the
#'     ArcGIS Desktop Python installation.
#'
#' @note (For ArcGIS Pro) The ArcGIS Pro bin folder (typically
#'   `C:\Program Files\ArcGIS\Pro\bin`) must be added to the `PATH`
#'   variable before the Conda Environment is loaded. For users with
#'  adminstrator privileges, `withr::with_path()` is used to temporarily
#'  add the ArcGIS Pro bin folder to the path. Users without
#'  adminstrator privileges may need to manually add the bin folder to
#'   their user `PATH` variable before starting an R session.
#'
#' @seealso [`find_ArcGIS()`]
#'
#' @examples
#' \dontrun{
#' # Try to autodetect ArcGIS Pro installation
#' use_ArcGIS()
#'
#' # connect to the 32-bit ArcGIS Desktop 10.2 Python environment
#' use_ArcGIS("C:/Python27/ArcGIS10.2")
#'
#' }
#'
#' @importFrom reticulate use_python use_condaenv
#' @export
use_ArcGIS = function(pro, pythonpath) {
  if (missing(pro)) {
    pro = getOption("arcpy.pro")
  }
  if (is.null(pro)) {
    pro = TRUE
  }
  if (missing(pythonpath)) {
    pythonpath = getOption("arcpy.pythonpath")
  }
  if (is.null(pythonpath)) {
    pythonpath = find_ArcGIS(pro, TRUE)[[1]]
  }
  if (pro) {
    use_condaenv(pythonpath, required = TRUE)
  } else {
    use_python(pythonpath, required = TRUE)
  }
  installinfo = tryCatch(arcpy$GetInstallInfo(),
    error = function(e) stop("The arcpy module could not be loaded. ",
      "Check that the Product License is available.\n",
      e$message, call. = FALSE))
  with(installinfo,
    message("Connected to ", ProductName,
    " version ", Version, " (build ", BuildNumber, ")."))
  invisible(NULL)
}
