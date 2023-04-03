#' ArcGIS Environment Loaded
#'
#' Check if ArcGIS Environment is Loaded
#'
#' @keywords internal
arcpy_is_loaded = function() {
  !is.null(get("arcpy_env", NULL, envir = loadenv))
}


#' @rdname arcpy_is_loaded
#' @inheritParams use_arcpy
#' @keywords internal
set_arcpy_env = function(env_name) {
  assign("arcpy_env", env_name, loadenv)
}

#' @rdname arcpy_is_loaded
#' @keywords internal
unset_arcpy_env = function() {
  assign("arcpy_env", NULL, loadenv)
}


#' Create ArcGIS Conda Environment
#'
#' Create a Conda environment with the "arcpy" module.
#'
#' @param env_name The name of the Conda environment to create.
#'   Default is `"arcpy_env"`.
#' @param arcgis_version The ArcGIS Pro version,
#'   in format `<major>.<minor>`.
#' @param python_version The Python version used by ArcGIS Pro,
#'   in format `<major>.<minor>`.
#'
#' @details The Conda environment must be configured to match the
#'   ArcGIS Pro version currently installed, and must be recreated when
#'   ArcGIS Pro is updated.
#'
#' @importFrom reticulate conda_list conda_create
#' @export
create_arcpy_env = function(env_name = "r-arcpy",
  arcgis_version = "", python_version = "") {
  app_version = sprintf("%0.1f", as.numeric(arcgis_version))
  py_version = sprintf("%0.1f", as.numeric(python_version))
  env_list = conda_list()
  if (is.na(app_version)) {
    stop("Could not recognize ArcGIS version ", shQuote(arcgis_version))
  } else if (is.na(py_version)) {
    stop("Could not recognize Python version ", shQuote(python_version))
  } else if (env_name %in% env_list[["name"]]) {
    stop("Conda environment ", shQuote(env_name), " already exists.")
  }
  conda_create(env_name, sprintf("arcpy==%s", app_version),
    channel = "esri", python_version = py_version)
  message("ArcGIS Conda environment ", shQuote(env_name), " created. ",
    "For automatic loading of arcpy, add the following to your ",
    sprintf(".Rprofile:\n options(arcpy.env = %s)", shQuote(env_name)))
  invisible()
}


#' Connect to ArcGIS
#'
#' Connect to an ArcGIS Python environment.
#'
#' @param env_name The name of the ArcGIS Pro Conda environment,
#'   or the path to the ArcGIS Desktop Python binary.
#' @param quietly If `TRUE`, suppress outputs.
#'
#' @details The following settings from [`options()`] will be used
#'  to populate missing arguments:
#'  * `arcpy.env`: (Character) The ArcGIS Pro Conda environment or path
#'     to ArcGIS Desktop Python binary.
#'
#' @examples
#' \dontrun{
#' # Try to autodetect ArcGIS Pro installation
#' use_arcpy()
#'
#' # connect to the 32-bit ArcGIS Desktop 10.2 Python environment
#' use_arcpy("C:/Python27/ArcGIS10.2")
#'
#' }
#'
#' @importFrom reticulate use_python use_condaenv conda_list
#' @export
use_arcpy = function(env_name, quietly = FALSE) {
  if (!arcpy_is_loaded()) {
    if (missing(env_name)) {
      env_name = getOption("arcpy.env")
    }
    if (is.null(env_name)) {
      stop("No ArcGIS python environment specified.")
    }
    if (env_name %in% conda_list()[["name"]]) {
      use_condaenv(env_name)
    } else if(file.exists(env_name)) {
      use_python(env_name)
    } else {
      stop("Could not find Python environment %s.",
        shQuote(env_name))
    }
    set_arcpy_env(env_name)
  }
  installinfo = tryCatch(arcpy$GetInstallInfo(),
    error = function(e) stop("The arcpy module could not be loaded. ",
      "Check that the Product License is available.\n",
      e$message, call. = FALSE))
  if (!quietly) {
    message(sprintf("Connected to %s version %s (build %s)",
      installinfo$ProductName, installinfo$Version,
      installinfo$BuildNumber))
  }
  invisible()

}


#' @rdname use_arcpy
#' @export
require_arcpy = function(env_name, quietly = TRUE) {
  result = try(use_arcpy(env_name, quietly))
  if (inherits(result, "try-error")) {
    if (!quietly) {
      warning(conditionMessage(result))
    }
    FALSE
  } else {
    TRUE
  }
}
