<br>

**Geostatistics**

Building on ``CHIC563: Geostatistics``

<br>

### Notes

Next, focus on **(a)** Chapters 7, 8, & 9 of [Geocomputation with R](https://geocompr.robinlovelace.net/index.html), 
**(b)** [P Diggle](https://www.lancaster.ac.uk/staff/diggle/), and **(c)** the [vignettes](https://r-spatial.github.io/sf/articles/) of simple features.

<br>

Books:
* [Geocomputation with R](https://geocompr.robinlovelace.net/index.html)
* [Model-based Geostatistics: Methods and Applications in Global Public Health](https://sites.google.com/view/mbgglobalhealth/home)
* [*bookdown*](https://bookdown.org)

<br>

Geography:
* [Projections](https://proj-tmp.readthedocs.io/en/docs/operations/projections/index.html)
* [Geographic vs. Co&#246;rdinated Reference Systems](https://www.earthdatascience.org/courses/use-data-open-source-python/intro-vector-data-python/spatial-data-vector-shapefiles/geographic-vs-projected-coordinate-reference-systems-python/)  
* [``tmap`` Reference](https://r-tmap.github.io/tmap/reference/index.html)
* https://www.diva-gis.org
* https://epsg.io
* https://hub.arcgis.com/datasets/esri::world-utm-grid/explore?location=-0.000000%2C0.000000%2C1.92

<br>

Tools:

* Simple Features
  * [Vignettes](https://r-spatial.github.io/sf/articles/): [*geometry types*](https://r-spatial.github.io/sf/articles/sf1.html)
  * [Simple Features](https://r-spatial.github.io/sf/index.html)
  * [Simple Features Reference](https://r-spatial.github.io/sf/reference/index.html)
  * [Geometry Types](http://postgis.net/docs/using_postgis_dbmanagement.html) &Rarr; Chapter 4 of [PostGIS](http://postgis.net/docs/)

* Thematic Maps
  * [Vignette: Getting Started](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html) &Rarr; *facets*, 
    *multiple shapes & layers*, *interactive maps*, etc.
  * [Layers](https://r-tmap.github.io/tmap-book/layers.html#layers) &Rarr; *polygons*, *symbols*, *lines*, *text*, *raster*, *tiles*    

* [Conversions between different spatial classes in R](https://geocompr.github.io/post/2021/spatial-classes-conversion/)

* [File Formats](https://geocompr.robinlovelace.net/read-write.html#file-formats)

* [Journal of maps style guide](https://files.taylorandfrancis.com/TJOM-suppmaterial-quick-guide.pdf)  
  
* [HTML Symbols, Entities, Special Characters](https://www.toptal.com/designers/htmlarrows/)  
  
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

<br>
<br>

<br>
<br>

<br>
<br>
