# Title     : main.R
# Objective : Play ground
# Created by: greyhypotheses
# Created on: 09/05/2022



#' Geography
#'

# setting the reference coordinates
utm <- 32629
liberia <- st_as_sf(frame, coords = c('utm_x', 'utm_y'))
st_crs(liberia) <- utm

# reading-in the shape file of Liberia's country border
liberia.adm0 <- st_read(dsn = 'data/shapes/Liberia/LBR_adm/LBR_adm0.shp')
liberia.adm0 <- st_transform(liberia.adm0, crs = utm)

# grid
liberia.grid <- sf::st_make_grid(liberia.adm0, cellsize = 2000, what = 'centers')
class(liberia.grid)
tm_shape(liberia.grid) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_dots() +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)

# the grid cells within Liberia ONLY
liberia.inside <- sf::st_intersects(liberia.grid, liberia.adm0, sparse = FALSE)
liberia.grid <- liberia.grid[liberia.inside]
class(liberia.grid)
tm_shape(liberia.grid) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_dots() +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)




#' Preliminaries
#'

# the data
blindness <- read.csv(file = 'data/frames/LiberiaRemoData.csv')
str(blindness)

# empirical logit
blindness$nneg <- blindness$ntest - blindness$npos
blindness$EL <- log( (blindness$npos + 0.5)/(blindness$nneg + 0.5) )

# model
model <- glm( cbind(npos, nneg) ~ I(log(elevation)),
              family = binomial(link = 'logit'), data = blindness )
summary(model)


# Herein, "logit" means "prediction on the scale of the linear regression"
predictions <- predict.glm(object = model)







#' Q.2.
#'


# starting values
estimations <- spat.corr.diagnostic(
  EL ~ 1, data = blindness, coords = ~ I(utm_x/1000) + I(utm_y/1000),
  likelihood = 'Gaussian', ID.coords = 1:nrow(blindness),
  lse.variogram = TRUE, uvec = seq(1, 80, length=15), which.test = 'variogram', plot.results = FALSE)
estimations$lse.variogram
initial.phi <- estimations$lse.variogram['phi']
initial.sigmasqr <- estimations$lse.variogram['sigma^2']
initial.tausqr <- estimations$lse.variogram['tau^2']


# model
model <- linear.model.MLE(formula = EL ~ I(log(elevation)) , coords = ~ I(utm_x/1000) + I(utm_y/1000),
                          data = blindness, start.cov.pars = c(initial.phi, initial.tausqr/initial.sigmasqr ),
                          kappa = 0.5, method="nlminb")
summary(model, log.cov.pars=TRUE)



# predicting
points <- blindness[, c('utm_x', 'utm_y')]
gridpoints <- gridpts(as.matrix(points), xs=5000, ys=5000)/1000

predictions <- spatial.pred.linear.MLE(
  model, grid.pred = gridpoints, predictors = blindness, standard.errors = TRUE,
  scale.predictions = 'logit', n.sim.prev = 1000)






