This is the first submission of this package to CRAN. 

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
