# Title     : alternative.R
# Objective : Alternative
# Created by: greyhypotheses
# Created on: 21/05/2022

par(bty = 'n')

# data
data(loaloa)
str(object = loaloa)
loaloa$logit <- log((loaloa$NO_INF+0.5)/(loaloa$NO_EXAM-loaloa$NO_INF+0.5))

# baseline model
lm.fit <- lm(logit ~ ELEVATION + I(ELEVATION^2), data = loaloa)
summary(lm.fit)

# settig coordinates
coords <- sp::SpatialPoints(loaloa[,c('LONGITUDE', 'LATITUDE')], CRS(projargs = '+init=epsg:4236'))
coords.utm <- sp::spTransform(coords, CRS(projargs = '+init=epsg:32632'))
loaloa$utm_x <- coordinates(coords.utm)[,1]/1000
loaloa$utm_y <- coordinates(coords.utm)[,2]/1000



# variogram
vari <- variog(coords=loaloa[,c('utm_x','utm_y')],
               data = residuals(lm.fit),
               uvec = seq(0, 200, length=15))
plot(vari)
vari.fit <- variofit(vari)
vari.fit
lines(vari.fit)


# linear model
lm.geo.fit <- linear.model.MLE(logit ~ ELEVATION + I(ELEVATION^2),
                               coords = ~utm_x + utm_y,
                               data = loaloa, kappa = 0.5,
                               start.cov.pars = c(vari.fit$cov.pars[2],
                                                  vari.fit$nugget / vari.fit$cov.pars[1]),
                               method = 'nlminb', messages = FALSE)
summary(lm.geo.fit)



#' Modelling
#'
#'

# starting regression coefficients, sigmasqr, phi;  excl. nugget effect variance
parameters <- coef(lm.geo.fit)[-6]

c.mcmc <- control.mcmc.MCML(n.sim = 10000, burnin = 2000, thin = 8,
                            h = 1.65 / (nrow(loaloa)^(1 / 6)))

starting <- parameters
L <- list()
for (i in seq(from = 1, to = 5)) {
  bin.geo.fit <- binomial.logistic.MCML(NO_INF ~ ELEVATION + I(ELEVATION^2),
                                        units.m = ~NO_EXAM,
                                        coords = ~utm_x + utm_y,
                                        data = loaloa,
                                        fixed.rel.nugget = 0,
                                        control.mcmc = c.mcmc,
                                        par0 = starting, kappa = 0.5,
                                        start.cov.pars = starting['phi'],
                                        messages = FALSE, plot.correlogram = FALSE)
  starting <- coef(bin.geo.fit)
  L <- append(x = L, values = bin.geo.fit$log.lik)
  print(starting)
}

summary(bin.geo.fit)



#' Bayesian Model
#'
#'

E <- summary(bin.geo.fit)
as.vector(E$cov.pars['log(sigma^2)', ])
as.vector(E$cov.pars['log(phi)', ])

c.prior <- control.prior(beta.mean = rep(0, 3),
                         beta.covar = diag(1000, 3),
                         log.normal.sigma2 = as.vector(E$cov.pars['log(sigma^2)', ]),
                         log.normal.phi = as.vector(E$cov.pars['log(phi)', ]),
                         log.normal.nugget = NULL)

c.mcmc.Bayes <- control.mcmc.Bayes(n.sim = 1000, burnin = 0, thin = 1,
                                   h.theta1 = 0.05, h.theta2 = 0.05,
                                   L.S.lim = c(5, 30), epsilon.S.lim = c(0.05, 0.12),
                                   start.S = predict(lm.fit), start.beta = rep(0, 3),
                                   start.sigma2 = exp(x = E$cov.pars['log(sigma^2)', 'Estimate']),
                                   start.phi = exp(x = E$cov.pars['log(phi)', 'Estimate']),
                                   start.nugget = NULL)

bin.geo.Bayes <- binomial.logistic.Bayes(NO_INF ~ ELEVATION + I(ELEVATION^2),
                                         units.m = ~NO_EXAM,
                                         coords = ~utm_x + utm_y,
                                         data = loaloa,
                                         control.mcmc = c.mcmc.Bayes,
                                         control.prior = c.prior,
                                         kappa = 0.5)
# Estimates
summary(bin.geo.Bayes)

# Autocorrelations
par(mfrow = c(2, 3))
autocor.plot(bin.geo.Bayes, param = 'beta', component.beta = 1)
autocor.plot(bin.geo.Bayes, param = 'beta', component.beta = 2)
autocor.plot(bin.geo.Bayes, param = 'beta', component.beta = 3)
autocor.plot(bin.geo.Bayes, param = 'sigma2')
autocor.plot(bin.geo.Bayes, param = 'phi')
autocor.plot(bin.geo.Bayes, param = 'S', component.S = 'all')

# Trace curves
par(mfrow = c(3, 3))
trace.plot(bin.geo.Bayes, param = 'beta', component.beta = 1)
trace.plot(bin.geo.Bayes, param = 'beta', component.beta = 2)
trace.plot(bin.geo.Bayes, param = 'beta', component.beta = 3)
trace.plot(bin.geo.Bayes, param = 'sigma2')
trace.plot(bin.geo.Bayes, param = 'phi')
trace.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))
trace.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))
trace.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))
trace.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))

# Densities
par(mfrow = c(3, 3))
dens.plot(bin.geo.Bayes, param = 'beta', component.beta = 1)
dens.plot(bin.geo.Bayes, param = 'beta', component.beta = 2)
dens.plot(bin.geo.Bayes, param = 'beta', component.beta = 3)
dens.plot(bin.geo.Bayes, param = 'sigma2')
dens.plot(bin.geo.Bayes, param = 'phi')
dens.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))
dens.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))
dens.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))
dens.plot(bin.geo.Bayes, param = 'S', component.S = sample(1:nrow(loaloa), size = 1))


P <- PrevMap::spatial.pred.binomial.Bayes(
  bin.geo.Bayes,
  grid.pred = 1000*as.matrix(loaloa[, c('utm_x', 'utm_y')]),
  predictors = loaloa[, c('ELEVATION', 'NO_INF', 'NO_EXAM')],
  type = 'marginal',
  scale.predictions = 'prevalence',
  quantiles = c(0.025, 0.975),
  standard.errors = TRUE
)




