# arcpy
ArcPy: R interface to ArcPy

An R interface for the ArcGIS Python module arcpy using
the R-Python bridge provided by 
[reticulate](https://cran.r-project.org/package=reticulate).
The Python functions and classes provided by the `arcpy` 
module are accessible through the `arcpy` object. S3
classes are defined to support raster math. Helper 
functions for transferring data between R `data.frame`s and
attribute tables are also provided.