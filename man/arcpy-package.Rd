% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/arcpy.r
\docType{package}
\name{arcpy-package}
\alias{arcpy-package}
\alias{arcpy}
\title{Interface to ArcPy}
\format{
An object of class \code{python.builtin.module}.
}
\usage{
arcpy
}
\description{
An interface to the ArcGIS \code{arcpy} Python module via the
R-Python interface provided by \code{reticulate}. Loading the
packages exposes the \code{arcpy} python module for accessing the
ArcGIS geoprocessor. See the vignettes to get started.
}
\details{
\code{arcpy} uses the following \code{\link[=options]{options()}} to configure behavior:

\itemize{
\item \code{arcpy.pro}: (Logical) use ArcGIS Pro by default.
\item \code{arcpy.installpath}: (Character) The default install path
of ArcGIS Pro.
\item \code{arcpy.condaenv}: (Character) The default path to the
ArcGIS Pro Conda environment.
\item \code{arcpy.pythonpath}: (Character) The default path to the
ArcGIS Desktop Python installation.
}
}
\examples{
\dontrun{
use_ArcGIS()
arcpy$GetInstallInfo()
mygis = arcgis$gis$GIS()
}

}
\seealso{
\code{\link{use_ArcGIS}}, \code{\link{RasterAlgebra}}
}
\keyword{datasets}
