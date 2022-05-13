
# clear
rm(list = ls())



# the data
rb <- read.csv(file = 'data/frames/LiberiaRemoData.csv')


# inspect spatial dependence
spat.corr.diagnostic(npos ~ log(elevation),
                     units.m = ~ ntest,
                     data = rb,
                     coords = ~ I(utm_x/1000) + I(utm_y/1000),
                     likelihood = 'Binomial',
                     lse.variogram = TRUE)


# initial coefficient values
beta.guess <- coef(glm(cbind(npos,ntest-npos) ~ log(elevation),
                       family=binomial, data = rb))


# initial parameter values
sigma2.guess <- 0.02
phi.guess <- 36.95
tau2.guess <-0.01


# MCMC Settings
mcml <- control.mcmc.MCML(n.sim = 10000, burnin = 2000, thin = 8)


# model
par0.rb <- c(beta.guess, sigma2.guess, phi.guess, tau2.guess)
fit.mle <- binomial.logistic.MCML(npos ~ log(elevation),
                                  units.m = ~ ntest,
                                  coords = ~ I(utm_x/1000) + I(utm_y/1000),
                                  par0 = par0.rb,
                                  control.mcmc = mcml,
                                  kappa = 0.5,
                                  start.cov.pars = c(phi.guess, tau2.guess/sigma2.guess),
                                  data = rb,
                                  method = 'nlminb')
summary(fit.mle)


# model
par0.rb <- c(beta.guess, sigma2.guess, phi.guess)
fit.mle <- binomial.logistic.MCML(npos ~ I(log(elevation)),
                                  units.m = ~ ntest,
                                  coords = ~ I(utm_x/1000) + I(utm_y/1000),
                                  par0 = par0.rb,
                                  control.mcmc = mcml,
                                  kappa = 0.5,
                                  fixed.rel.nugget = 0,
                                  start.cov.pars = phi.guess,
                                  data = rb,
                                  method = 'nlminb')
summary(fit.mle)





#' Spatial predictions within Liberia
#'
#'


# ... the country border
utm <- 32629
liberia.adm0 <- st_read(dsn = 'data/shapes/Liberia/LBR_adm/LBR_adm0.shp')
liberia.adm0 <- st_transform(liberia.adm0, crs = utm)
tm_shape(liberia.adm0) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_borders(lwd = 3)

# ... a within-border grid that has a resolution of 3 km by 3 km
liberia.grid <- sf::st_make_grid(liberia.adm0, cellsize = 3000, what = 'centers')
liberia.inside <- sf::st_intersects(liberia.grid, liberia.adm0, sparse = FALSE)
liberia.grid <- liberia.grid[liberia.inside]
tm_shape(liberia.grid) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_dots()

# ... elevations map ... terra::mask() excludes elevations outwith Liberia
liberia.alt <- terra::rast('data/shapes/Liberia/LBR_alt/LBR_alt.vrt')
liberia.alt <- terra::project(liberia.alt, paste0('EPSG:', utm), method = 'bilinear')
liberia.alt <- terra::mask(liberia.alt, terra::vect(liberia.adm0))
tm_shape(liberia.alt) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_raster(title = 'Elevation (m)')

# ... the elevation value per Liberia grid point
P <- terra::extract(liberia.alt, terra::vect(liberia.grid), xy = TRUE) %>%
  dplyr::select(!ID)
P <- rename(P, 'elevation' = 'LBR_alt', 'utm_x' = 'x', 'utm_y' = 'y')
H <- P[complete.cases(P), ]


# predict
pred.mle <- spatial.pred.binomial.MCML(fit.mle,
                                       grid.pred = H[, c('utm_x', 'utm_y')],
                                       predictors = H,
                                       control.mcmc = mcml,
                                       scale.predictions = c('logit', 'prevalence'),
                                       thresholds = 0.2,
                                       scale.thresholds = 'prevalence')

plot(pred.mle, "prevalence", "predictions")
plot(pred.mle, summary="exceedance.prob")
