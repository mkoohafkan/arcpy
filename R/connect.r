#' Find ArcGIS Installation
#'
#' Attempt to automatically locate an ArcGIS installation.
#'
#' @param pro If \code{TRUE}, Search for ArcGIS Pro
#'   Python distribution. Otherwise, search for ArcGIS
#'   Desktop Python distribution.
#' @return Path(s) to ArcGIS Python distributions.
#'
#' @seealso \code{\link{use_ArcGIS}}
#'
#' @export
find_ArcGIS = function(pro = TRUE) {
  if (pro) {
    installpath = find_install("warn")
    list(
      installpath = installpath,
      env = find_env(installpath, "warn")
    )
  } else {
    list(python = find_python("warn"))
  }
}

on_fail = function(on.fail) {
  on.fail = match.arg(on.fail, c("stop", "warn"))
  if (on.fail == "stop") {
    function(..., call. = FALSE) stop(..., call. = call.)
  } else {
    function(..., call. = FALSE) warning(..., call. = call.)
  }
}

#' Find ArcGIS Pro Install Directory
#'
#' @keywords internal
find_install = function(on.fail = c("stop", "warn")) {
  fail_fun = on_fail(on.fail)
  path = normalizePath("C:/Program Files/ArcGIS/Pro", mustWork = FALSE)
  if (!dir.exists(path)) {
    fail_fun("Could not find ArcGIS Pro installation.")
    ""
  } else {
    path
  }
}

#' Find ArcGIS Desktop Python Distribution
#'
#' @keywords internal
find_python = function(on.fail = c("stop", "warn")) {
  fail_fun = on_fail(on.fail)
  if (.Platform$r_arch == "x64") {
    python_folder = file.path("C:/Python27",
        dir("C:/Python27")[grepl("ArcGIS.*x64", dir("C:/Python27"))])
  } else {
    python_folder = file.path("C:/Python27",
        dir("C:/Python27")[grepl("ArcGIS.*", dir("C:/Python27")) &
          !(grepl("ArcGIS.*x64", dir("C:/Python27")))])
  }
  if (length(python_folder) > 1) {
    warning("Multiple ArcGIS Desktop Python binaries found.")
  } else if (length(python_folder) < 1) {
    fail_fun("Could not find ArcGIS Desktop Python ",
      .Platform$r_arch, " binary.")
    ""
  } else {
    python_folder
  }
}

#' Find ArcGIS Pro Conda Environment
#'
#' @keywords internal
find_env = function(installpath, on.fail = c("stop", "warn")) {
  fail_fun = on_fail(on.fail)
  env_dir = normalizePath(file.path(installpath, "bin/Python/envs"),
    mustWork = FALSE)
  if (!dir.exists(env_dir)) {
    fail_fun("Could not find ArcGIS Pro Conda Environments directory")
    return("")
  }
  conda_envs = normalizePath(dir(env_dir, full.names = TRUE),
    mustWork = FALSE)
  if (length(conda_envs) > 1) {
    warning("Multiple ArcGIS Pro Conda environments found.")
  } else if (length(conda_envs) < 1) {
    fail_fun("Could not find an ArcGIS Pro Conda environment.")
    ""
  } else {
    conda_envs
  }
}

#' Find ArcGIS Pro Conda Executable
#'
#' DEPRECATED?
#'
#' @keywords internal
find_conda = function(installpath, on.fail = c("stop", "warn")) {
  fail_fun = on_fail(on.fail)
  conda_exe = normalizePath(file.path(installpath,
    "bin/Python/Scripts/conda.exe"), mustWork = FALSE)
  if (!file.exists(conda_exe)) {
    fail_fun("Could not find ArcGIS Pro Conda executable.")
  }
  conda_exe
}


#' Connect to ArcGIS Python
#'
#' Connect to the ArcGIS Python environment.
#'
#' @param pro If \code{TRUE}, attempt to connect to an ArcGIS Pro
#'   Python distribution. Otherwise, attempt to connect to an ArcGIS
#'   Desktop Python distribution. Ignored if \code{python} is provided.
#' @param condaenv (ArcGIS Pro only). The ArcGIS Pro Conda environment
#'   to use. If missing, the function will attempt to automatically
#'   detect the default Conda environment.
#' @param installpath (ArcGIS Pro only). The ArcGIS Pro installation
#'   directory. If missing, the function will attempt to
#'   automatically detect the installation directory.
#' @param python (ArcGIS Desktop only) Path to the ArcGIS Desktop
#'   Python binary. If missing, the function will attempt to
#'   automatically detect an appropriate Python installation.
#' @return No return value.
#'
#' @note (For ArcGIS Pro) The ArcGIS Pro bin folder (typically
#'   `C:\Program Files\ArcGIS\Pro\bin`) must be added to the PATH
#'   variable before the Conda Environment is loaded. For users with
#'  adminstrator privileges, `withr::with_path()` is used to temporarily
#'  add the ArcGIS Pro bin folder to the path. Users without
#'  adminstrator may need to manually add the bin folder to their user 
#'  PATH variable before starting an R session.
#'
#' @seealso \code{\link{find_ArcGIS}}
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
#' @importFrom withr with_path
#' @export
use_ArcGIS = function(pro = TRUE, condaenv, installpath, python) {
  if (!pro) {
    if (missing(python)) {
      python = find_python()
    }
    use_python(python[[1]], required = TRUE)
    installinfo = arcpy$GetInstallInfo()
  } else {
    if (missing(installpath)) {
      installpath = find_install()
    }
    # update PATH
    pro.bin = normalizePath(file.path(installpath, "bin"))
    if (missing(condaenv)) {
      condaenv = find_env(installpath)[[1]]
    }
    installinfo = with_path(pro.bin, {
      use_condaenv(condaenv = condaenv[[1]], required = TRUE)
      # need to access arcpy while path is modified to load correctly
      installinfo = try(arcpy$GetInstallInfo())
    })
  }
  if (class(installinfo) == "try-error") {
    stop("The arcpy module could not be loaded.\n",
      "If your user account does not have adminstrator privileges, ",
      "try adding ", shQuote(pro.bin), " to your user PATH variable ",
      "and retry.\nYou may also need to restart your R session.")
  }
  with(installinfo,
    message("Connected to ", ProductName,
    " version ", Version, " (build ", BuildNumber, ")."))
  invisible(NULL)
}
