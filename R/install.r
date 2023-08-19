#' Get Arcpy Version
#'
#' Verify the supplied arcpy module version and identify the required
#' Python version.
#'
#' @param version The arcpy module version.
#' @inheritParams reticulate::conda_search
#' @return A named list providing version numbers of arcpy and Python.
#'
#' @importFrom reticulate conda_search
#' @keywords internal
arcpy_version = function(version, conda = "auto", channel = "esri", forge = TRUE) {
    version = as.character(version)[1]
    if (is.na(version)) {
      stop("Could not coerce argument 'version' to a valid string.")
    }
    arcpy_available = conda_search("arcpy", forge = forge,
      channel = channel, conda = conda)
    # get all modules matching specified version
    arcpy_selected = arcpy_available[arcpy_available$version == version,]
    if (nrow(arcpy_selected) < 1L) {
        stop("No arcpy module matching version ", version, " found.")
    }
    # get latest build
    arcpy_selected = arcpy_selected[order(arcpy_selected$build),]
    arcpy_selected = arcpy_selected[nrow(arcpy_selected),]
    arcpy_version = arcpy_selected$version
    # get python version
    arcpy_build = arcpy_selected$build
    python_version = regmatches(arcpy_build,
      regexpr("(?<=py)([0-9]{2})(?=_arcgispro_[0-9]+)",
      arcpy_build, perl = TRUE))
    python_version = gsub("([0-9]{1})([0-9]{1})", "\\1.\\2", python_version)
    list(arcpy = arcpy_version, python = python_version)
}


#' Install ArcGIS Conda Environment
#'
#' Create a Conda environment with the "arcpy" module.
#'
#' @inheritParams reticulate::py_install
#' @inheritParams reticulate::conda_install
#' @param version Arcpy version to install. Note that the requested
#'   arcpy version must match your ArcGIS Pro version.
#' @param extra_packages Additional Python packages to install along with
#'   arcpy.
#' @param restart_session Restart R session after installing (note this will
#'   only occur within RStudio).
#' @param python_version Pass a string like "3.9" to request that
#'   conda install a specific Python version. Note that the Python
#'   version must be compatible with the requested arcpy version. If
#'   `NULL`, the latest compatible Python version will be used.
#' 
#' @param new_env If `TRUE`, any existing Python conda environment
#'   specified by `envname` is deleted first.
#'
#' @param ... other arguments passed to [`reticulate::conda_install()`].
#' 
#' @details The Conda environment must be configured to match the
#'   ArcGIS Pro version currently installed. If ArcGIS Pro is updated,
#'   the Conda environment must be recreated.
#'
#' @importFrom reticulate conda_remove conda_python py_install
#' @export
install_arcpy = function(method = "conda", conda = "auto",
  version = NULL, envname = "r-arcpy", extra_packages = NULL,
  restart_session = TRUE, python_version = NULL, channel = "esri",
  forge = TRUE, ..., new_env = identical(envname, "r-arcpy")) {

  if (isTRUE(new_env)) {
    # remove environment if it exists
    if (method %in% c("auto", "conda")) {
      if (!is.null(tryCatch(conda_python(envname, conda = conda),
                            error = function(e) NULL)))
        conda_remove(envname, conda = conda)
    }
  }
  # identify arcpy and python versions
  env_versions = arcpy_version(version, conda = conda)
  if (is.null(python_version)) {
    python_version = env_versions$python
  }
  packages = c(sprintf("arcpy==%s", env_versions$arcpy), extra_packages)  

  # set pip to FALSE, arcpy installed via Conda
  py_install(packages = packages, envname = envname,
    method = method, conda = conda, python_version = python_version,
    pip = FALSE, channel = channel, forge = forge, ...)

  message("\nInstallation complete.\n\n")

  if (restart_session &&
      requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()

  invisible(TRUE)
}
