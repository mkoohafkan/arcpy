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
