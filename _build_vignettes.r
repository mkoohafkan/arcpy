devtools::load_all()
use_ArcGIS(TRUE)

knitr::knit("vignettes/_quickstart.rmd", "vignettes/quickstart.rmd")
knitr::knit("vignettes/_helper-functions.rmd", "vignettes/helper-functions.rmd")
knitr::knit("vignettes/_raster-math.rmd", "vignettes/raster-math.rmd")
knitr::knit("vignettes/_manipulating-arcobjects.rmd", "vignettes/manipulating-arcobjects.rmd")
