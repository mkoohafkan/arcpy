This is the first submission of this package to CRAN. 

Because this package requires ArcGIS Pro to be
installed, automated testing via CI is not possible. 
Testing is done on the local machine via the generation of the
vignettes and very basic tests of sucessful connection to ArcGIS
using package `testthat` tests. Github Actions is used to verify 
successful package build.


## Test environments

* Local Windows 10 install, R 4.3.1 (including tests)
* Linux-latest (via github actions), R-oldrel, R-release, R-devel (build only)
* Windows-latest (via github actions), R-release (build only)
* MacOS-latest (via github actions), R-release (build only)


## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES
