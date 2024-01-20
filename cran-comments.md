Resubmission to CRAN. Fixes the following notes:

- All references to package names, software names and
  API names are in single quotes in title and description.
- Added more details about the package functionality
  and implemented methods in the Description text.
- Added missing "value" Rd-tag to `install_arcpy()`
  documentation.
- Added ArcGIS API reference to DESCRIPTION.

Because this package requires ArcGIS Pro to be
installed, \dontrun{} is used to wrap all examples
as they cannot be executed without it. For the same
reason, automated testing via CI is not possible. 
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
