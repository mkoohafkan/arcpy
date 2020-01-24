This is the first submission of this package to CRAN. 

This package has  number of significant differences from the existing 
R-ArcGIS interface provided by package "RPyGeo". Most importantly,
package "arcpy" treats arcobjects as first-class
R objects, with the ability to access methods and iterate over using
existing functionality in package "reticulate". S3 methods are
defined for Raster arcobjects to allow math and logical operations 
on rasters (raster algebra) to be accomplished without any special 
treatment. Finally, helper functions are provided for easy manipulation 
of attribute tables as dataframes. The vignettes provide a variety of 
demonstrations of high-level features and low-level arcobject manipulation.

Because this package requires ArcGIS Pro or ArcGIS Desktop to be
installed, automated testing on e.g. Travis-CI is not possible. 
Testing is done on the local machine via the generation of the
vignettes and very basic tests of sucessful connection to ArcGIS
using package `testthat` tests. Travis-CI is used to verify 
successful package build.

## Test environments

* Local Windows 10 install, R 3.6.2
* Ubuntu 14.04 (on travis-ci), R-oldrel, R-release, R-devel

## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES
