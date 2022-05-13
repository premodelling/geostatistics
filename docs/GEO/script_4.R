rm(list = ls())


#' Preliminaries
#'
#'

# Survey
galicia <- read.csv(file = 'data/frames/GaliciaData.csv')
galicia <- galicia[galicia$survey == 2000,]

# Boundary
galicia.bndrs <- read.csv(file = 'docs/GEO/galicia_boundaries.csv')

point.map(galicia, ~log(lead), coords = ~ x + y, pt.divide = 'quintiles', frame.plot = FALSE)
lines(galicia.bndrs, type = 'l')

# A variogram w.r.t. ln(lead): Is the aim structural dependence determination?
vari <- variogram(galicia, ~log(lead), coords = ~ I(x/1000) + I(y/1000),
                  uvec = seq(10, 150, length=15))
plot(vari, type = 'b', frame.plot = FALSE)




#' Starting Values
#'
#'

# The rationale for eyefit() is unclear
# eyefit(vari)

# A systematic approach
par(bty = 'n')
initial.values <- spat.corr.diagnostic(
  formula = log(lead) ~ 1, data = galicia, coords = ~ I(x/1000) + I(y/1000),
  likelihood = 'Gaussian', ID.coords = 1:nrow(galicia), lse.variogram = TRUE,
  uvec = seq(10, 120, length=15), which.test = 'variogram')

# variance of the spatial Gaussian processs S(x)
sigma2.start <- initial.values$lse.variogram['sigma^2']

# scale of the spatial correlation
phi.start <-  initial.values$lse.variogram['phi']

# the variance of the nugget effect
tau2.start <- initial.values$lse.variogram['tau^2']



#' Modelling
#'
#'

# Model A:
#     kappa = 5 implies exponential correlation function
lgm.fit.mle <- linear.model.MLE(log(lead) ~ 1,
                                coords = ~ I(x/1000) + I(y/1000),
                                data = galicia,
                                start.cov.pars = c(phi.start, tau2.start/sigma2.start),
                                kappa = 0.5, method = 'nlminb')
# summary(lgm.fit.mle, log.cov.pars = FALSE)
# summary(lgm.fit.mle, log.cov.pars = TRUE)

# Model B:
#     Excludes the nugget term Z_{i}, therefore Y_{i} = \alpha + S(x_{i})
lgm.fit.mle <- linear.model.MLE(log(lead) ~ 1,
                                coords = ~ I(x/1000) + I(y/1000),
                                data = galicia,
                                start.cov.pars = phi.start,
                                fixed.rel.nugget = 0,
                                kappa = 0.5, method = 'nlminb')
summary(lgm.fit.mle, log.cov.pars = FALSE)
summary(lgm.fit.mle, log.cov.pars = TRUE)



#' Estimates
#'
#'

# Summary of estimates, covariance parameters
E <- summary(lgm.fit.mle, log.cov.pars = TRUE)
V <-data.frame(E$cov.pars)

# Estimate for phi (scale parameter)
phi.hat <- exp(x = V['log(phi)', 'Estimate'])

# The curve of spatial correlations w.r.t. distance ∈ [0, 50] and function ρ(u) = exp(-u/φ)
curve(exp(-x/phi.hat), xlim = c(0,50))

# Practical range (distance at which the spatial correlation is 0.05)
spatial.correlation.limit <- 0.05
practical.distance <- - phi.hat * log(spatial.correlation.limit)
practical.distance

# Confidence intervals
interval <- qnorm(p = 0.975, lower.tail = TRUE)*V[, 'StdErr']
V[, c('lower.c.i', 'upper.c.i')] <- V[, 'Estimate'] +
  (matrix(interval, nrow = length(interval), ncol = 1) %*% matrix(c(-1, 1), nrow = 1, ncol = 2))

# ... phi
exp(V['log(phi)', c('lower.c.i', 'upper.c.i')])
exp(V['log(phi)', 'Estimate'] + c(-1, 1)*qnorm(p= 0.975)*V['log(phi)', 'StdErr'])




#' Predicting
#'
#'

# Generating prediction points within an area's polygon
grid.pred.galicia <- splancs::gridpts(as.matrix(galicia.bndrs),
                                      xs = 5000, ys = 5000)/1000

# "logit" here means "prediction on the scale of the linear regression"
pred.lead.MLE <- spatial.pred.linear.MLE(lgm.fit.mle,
                                         grid.pred = grid.pred.galicia,
                                         standard.errors = TRUE,
                                         scale.predictions = 'logit',
                                         n.sim.prev = 1000)

# ... predictions
plot(pred.lead.MLE, type = 'logit', summary = 'predictions')

# ... standard errors
plot(pred.lead.MLE, type = 'logit', summary = 'standard.errors')
points(galicia[, c('x','y')]/1000, pch = 20)

# ... the samples
lead.pred.samples <- exp(pred.lead.MLE$samples)
dim(lead.pred.samples)
hist(lead.pred.samples[3,])
hist(lead.pred.samples[1009,])
hist(lead.pred.samples[1179,])




#' Predictions Based on Predicted Samples
#'
#'

# Predicted lead
pred.lead <- apply(lead.pred.samples, MARGIN = 1, mean)

# Standard errors (lead concentration un-logged scale)
sd.lead <- apply(lead.pred.samples, MARGIN = 1, sd)

# Fraction exceeding 4:
#     apply(lead.pred.samples, MARGIN = 1, FUN = function(x) sum(x > 4)/length(x))
lead.above4 <- apply(lead.pred.samples, MARGIN = 1, FUN = function(x) mean(x > 4))



#' Hence, Maps
#'
#'

class(grid.pred.galicia)

# ... A raster object w.r.t. the created grid points, and their lead prediction values
r.lead <- raster::rasterFromXYZ(cbind(grid.pred.galicia, pred.lead))

# ... A raster object w.r.t. the created grid points, and the uncertainty of the predicted lead values
r.sd <- raster::rasterFromXYZ(cbind(grid.pred.galicia, sd.lead))

# ... A raster object w.r.t. the created grid points, and chance of exceeding 4
r.above4 <- raster::rasterFromXYZ(cbind(grid.pred.galicia, lead.above4))

plot(r.lead, main = 'Lead')
plot(r.above4, main = 'Chance of lead quantities exc. 4')





#' Extra: Bayesian Modelling
#'
#'

# ... priors
log.prior.sigma2.galicia <- function(sigma2) {
  dunif(sigma2, min = 0,max = , log = TRUE)
}
log.prior.phi.galicia <- function(phi) {
  dunif(phi, min = 0,max = 50, log = TRUE)
}
cp <- control.prior(beta.mean = 0, beta.covar = 10^10,
                    log.prior.sigma2 = log.prior.sigma2.galicia,
                    log.prior.phi = log.prior.phi.galicia)

# ... MCMC settings
bayes.mcmc <- control.mcmc.Bayes(n.sim = 2000, burnin = 1000, thin = 1,
                                 epsilon.S.lim = 0.1,
                                 start.nugget = NULL, L.S.lim = 5)

# ... model
lgm.fit.bayes <- linear.model.Bayes(lead ~ 1, coords = ~I(x/1000) + I(y/1000),
                                    data = galicia, kappa = 0.5, control.prior = cp,
                                    control.mcmc = bayes.mcmc)

# ... hence, the trace plots
trace.plot(lgm.fit.bayes, param = 'beta', component.beta = 1)
autocor.plot(lgm.fit.bayes, param = 'beta',component.beta = 1)

trace.plot(lgm.fit.bayes, param = 'sigma2')
autocor.plot(lgm.fit.bayes, param = 'sigma2', component.beta = 1)

trace.plot(lgm.fit.bayes, param = 'phi')
autocor.plot(lgm.fit.bayes, param = 'phi', component.beta = 1)




#' Extra: Bayesian Modelling (Predictions)
#'
#'

pred.lead.Bayes <- spatial.pred.linear.Bayes(lgm.fit.bayes, grid.pred = grid.pred.galicia,
                                             scale.predictions = 'logit', standard.errors = TRUE)
plot(pred.lead.Bayes, 'logit', 'predictions')
plot(pred.lead.Bayes, 'logit', 'standard.errors')




#' The plain & Bayesian Models
#'
#'

plot(pred.lead.MLE$logit$predictions,
     pred.lead.Bayes$logit$predictions,
     xlab = 'MLE', ylab = 'Bayes', main = 'Predictions')
abline(a = 0, b = 1, col = 2, lwd = 2)

plot(pred.lead.MLE$logit$standard.errors,
     pred.lead.Bayes$logit$standard.errors,
     xlab = 'MLE', ylab = 'Bayes', main = 'Predictions')
abline(a = 0, b = 1, col = 2, lwd = 2)



###

library(help=PrevMap)
variog.diagnostic.lm(lgm.fit.mle)
