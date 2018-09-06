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
  if (pro)
    find_pro()
  else
    find_desktop()
}

find_conda = function() {
  conda_exe = "C:/Program Files/ArcGIS/Pro/bin/Python/Scripts/conda.exe"
  if (!file.exists(conda_exe))
    stop("Could not find ArcGIS Pro Conda executable.")
  conda_exe
}

find_pro = function() {
  env_dir = "C:/Program Files/ArcGIS/Pro/bin/Python/envs"
  if (!file.exists(env_dir))
    stop("Could not find ArcGIS Pro Conda Environments directory")
  conda_envs = dir(env_dir)
  if (length(conda_envs) > 1)
    warning("Multiple ArcGIS Pro Conda environments found.")
  if (length(conda_envs) < 1)
    stop("Could not find ArcGIS Pro Conda environment.")
  conda_envs
}

find_desktop = function() {
  if (.Platform$r_arch == "x64") {
    python_folder = file.path("C:/Python27",
        dir("C:/Python27")[grepl("ArcGIS.*x64", dir("C:/Python27"))])
  } else {
    python_folder = file.path("C:/Python27",
        dir("C:/Python27")[grepl("ArcGIS.*", dir("C:/Python27")) &
          !(grepl("ArcGIS.*x64", dir("C:/Python27")))])
  }
  if (length(python_folder) > 1)
    warning("Multiple ArcGIS Desktop Python binaries found.")
  if (length(python_folder) < 1)
    stop("Could not find ArcGIS Desktop Python binary.")
  python_folder
}

#' Connect to ArcGIS Python
#'
#' Connect to the ArcGIS Python environment. 
#'
#' @param pro If \code{TRUE}, attempt to connect to an ArcGIS Pro 
#'   Python distribution. Otherwise, attempt to connect to an ArcGIS 
#'   Desktop Python distribution. Ignored if \code{python} is provided.
#' @param python Path to ArcGIS Python binary.
#'   If missing, the function will attempt to automatically 
#'   detect an appropriate Python installation.
#' @param python Path to ArcGIS Python binary.
#'   If missing, the function will attempt to automatically 
#'   detect an appropriate Python installation.
#' @param conda_exe For use with ArcGIS Pro only. The
#'   path to the ArcGIS Pro Conda executable.
#'   If missing, the function will attempt to automatically 
#'   detect the ArcGIS Pro Conda executable.
#' @param conda_env For use with ArcGIS Pro only. The
#'   the ArcGIS Pro Conda environment to use.
#'   If missing, the function will attempt to automatically 
#'   detect an appropriate Conda environment.
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
#' @importFrom reticulate use_python use_condaenv
#' @export
use_ArcGIS = function(pro = FALSE, python, conda_exe, conda_env) {
  if (!pro) {
    if (missing(python))
      python = find_ArcGIS(pro)
    use_python(python[[1]], required = TRUE)
  } else {
    conda_exe = find_conda()
    conda_env = find_pro()
    use_condaenv(conda_env[[1]], conda_exe, required = TRUE)
  }
  invisible(NULL)
}
