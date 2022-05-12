
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


# area of interest
liberia.bndrs <- read.csv(file = 'docs/BGM/liberia_boundaries.csv')
liberia.grid <- splancs::gridpts(as.matrix(liberia.bndrs[, c('utm_x', 'utm_y')])/1000, xs = 3, ys = 3)

elevation <- raster(x = 'data/shapes/liberia/LBR_alt/LBR_alt.gri')
elevation <- projectRaster(elevation, crs = CRS(projargs = '+init=epsg:32629'))
tm_shape(elevation) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_raster(title = 'Elevation')


# review
elevation.pred <- extract(elevation, liberia.grid*1000)

ind.na <- which(is.na(elevation.pred))
liberia.grid <- liberia.grid[-ind.na,]
elevation.pred <- elevation.pred[-ind.na]

predictors.rb <- data.frame(elevation=elevation.pred)
  
pred.mle <- spatial.pred.binomial.MCML(fit.mle,
                                       grid.pred = liberia.grid,
                                       predictors = predictors.rb,
                                       control.mcmc = mcml,
                                       scale.predictions = c('logit', 'prevalence'),
                                       thresholds = 0.2,
                                       scale.thresholds = 'prevalence')

plot(pred.mle, "prevalence", "predictions")
plot(pred.mle, summary="exceedance.prob")
