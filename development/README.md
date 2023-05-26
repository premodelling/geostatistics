
<br>

### Independent Development Environment

* Edit the help file skeletons in 'man', possibly combining help files
  for multiple functions.
* Edit the exports in 'NAMESPACE', and add necessary imports.
* Put any C/C++/Fortran code in 'src'.
* If you have compiled code, add a useDynLib() directive to
  'NAMESPACE'.
* Run R CMD build to build the package tarball.
* Run R CMD check to check the package tarball.

Read "Writing R Extensions" for more information.

<br>
<br>

### Snippets

About simple features ([sf](https://r-spatial.github.io/sf/index.html)) & spatial data ([sp](https://cran.r-project.org/web/packages/sp/index.html)) objects

```R
library(sp)

# from an sf object to sp object
SP <- as(world, "Spatial") 

# from sp object to sf object
SF <- st_as_sf(SP)
```

<br>

About raster objects

```R
template <- terra::rast()

class(template)
terra::crs(template) %>% 
  cat()
```

<br>
<br>

<br>
<br>

<br>
<br>

<br>
<br>
