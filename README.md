# arcpy: R Interface to ArcGIS Geoprocessing Tools

<!-- badges: start -->
[![R-CMD-check](https://github.com/mkoohafkan/arcpy/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mkoohafkan/arcpy/actions/workflows/R-CMD-check.yaml)
![CRAN Release](https://www.r-pkg.org/badges/version-last-release/arcpy)
<!-- badges: end -->

An R interface for the ArcGIS Python module `arcpy` using
the R-Python bridge provided by 
[reticulate](https://cran.r-project.org/package=reticulate).
The ArcGIS geoprocessing functions and classes are accessible 
through the `arcpy` object. S3 classes are defined to support 
raster math. Helper functions for reading and modifying attribute
tables are also provided.

This package has several significant differences from the existing 
(now dormant) R-ArcGIS interface provided by package "RPyGeo".
Most importantly, package "arcpy" treats arcobjects as first-class
R objects, with the ability to access methods and iterate over using
existing functionality in package "reticulate". S3 methods are
defined for Raster arcobjects to allow math and logical operations 
on rasters (raster algebra) to be accomplished without any special 
treatment. Finally, helper functions are provided for easy manipulation 
of attribute tables as dataframes. The vignettes provide a variety of 
demonstrations of high-level features and low-level arcobject manipulation.
