<br>

**Geostatistics**

<br>
<br>

### Notes

Books:
* [Geocomputation with R](https://geocompr.robinlovelace.net/index.html)

<br>

Geography:
* [Projections](https://proj-tmp.readthedocs.io/en/docs/operations/projections/index.html)
* https://www.diva-gis.org
* https://epsg.io
* https://hub.arcgis.com/datasets/esri::world-utm-grid/explore?location=-0.000000%2C0.000000%2C1.92

<br>

Tools:
* Simple Features
  * [Simple Features](https://r-spatial.github.io/sf/index.html)
  * [Simple Features Reference](https://r-spatial.github.io/sf/reference/index.html)
  * [Geometry Types](http://postgis.net/docs/using_postgis_dbmanagement.html) &Rarr; Chapter 4 of [PostGIS](http://postgis.net/docs/)
  
<br>
<br>

### Snippets

```R
library(sp)

# from an sf object to sp object
SP <- as(world, "Spatial") 

# from sp object to sf object
SF <- st_as_sf(SP)           
```

<br>
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

<br>
<br>

<br>
<br>

<br>
<br>