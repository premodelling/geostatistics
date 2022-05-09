rm(list = ls())
library(PrevMap)

galicia <- read.csv("galicia.csv")
galicia <- galicia[galicia$survey==2000,]
galicia.bndrs <- read.csv("galicia_bndrs.csv")

point.map(galicia,~log(lead),coords=~x+y,
          pt.divide="quintiles")
lines(galicia.bndrs,type="l")

vari <- variogram(galicia,~log(lead),
          coords=~I(x/1000)+I(y/1000),
          uvec=seq(10,150,length=15))
plot(vari,type="b")

library(geoR)
eyefit(vari)
#     cov.model sigmasq   phi tausq kappa kappa2   practicalRange
# exponential    1.39 16.22  0.16  <NA>   <NA> 48.5907774765683

spat.corr.diagnostic(log(lead)~1, 
                     data=galicia,
                     coords=~I(x/1000)+I(y/1000),
                     likelihood = "Gaussian",
                     ID.coords = 1:nrow(galicia),
                     lse.variogram = TRUE,
                     uvec=seq(10,120,length=15),
                     which.test = "variogram")

sigma2.start <- 0.18 # variance of the spatial Gaussian processs S(x)
phi.start <-  30 # scale of the spatial correlation
tau2.start <- 0.03 # the variance of the nugget effect

lgm.fit.mle <- 
  linear.model.MLE(log(lead)~1, coords=~I(x/1000)+I(y/1000), 
                   data = galicia,
                   start.cov.pars = c(phi.start,
                                      tau2.start/sigma2.start),
                   kappa=0.5,# exponential correlation function
                   method="nlminb") 

summary(lgm.fit.mle,log.cov.pars=FALSE)

# I am excluding the nugget from th model 
# Y_i = alpha + S(x_i)
lgm.fit.mle <- 
linear.model.MLE(log(lead)~1, coords=~I(x/1000)+I(y/1000), 
                 data = galicia,
                 start.cov.pars = phi.start,
                 fixed.rel.nugget = 0,
                 kappa=0.5,
                 method="nlminb")

summary(lgm.fit.mle,log.cov.pars=TRUE)

# Estimate for phi (scale parameter)
phi.hat <- exp(3.0242)

# Function of the estimated correlation function
curve(exp(-x/phi.hat),xlim=c(0,50))

# Practical range (distance at which the spatial correlation is 0.05)
3*phi.hat

# Confidence interval for phi
exp(3.0242+c(-1,1)*qnorm(0.975)*0.2556)


library(splancs)
grid.pred.galicia <- gridpts(as.matrix(galicia.bndrs),
                             xs=5000,ys=5000)/1000


pred.lead.MLE <- spatial.pred.linear.MLE(lgm.fit.mle,
                                     grid.pred = grid.pred.galicia,
                                     standard.errors = TRUE,
                                    
                              #"logit" here means "prediction on the scale of the linear
                              #                    regression"
                                     
                                     scale.predictions = "logit",
                                     n.sim.prev = 1000)

plot(pred.lead.MLE,type="logit",summary="predictions")
plot(pred.lead.MLE,type="logit",summary="standard.errors")

points(galicia[,c("x","y")]/1000,pch=20)

lead.pred.samples <- exp(pred.lead.MLE$samples)
dim(lead.pred.samples)

hist(lead.pred.samples[3,])

# Predicted lead
pred.lead <- apply(lead.pred.samples, 1, mean)
length(pred.lead)

# Standard errors (lead concentration un-logged scale)
sd.lead <- apply(lead.pred.samples, 1, sd)

# Exceeding 4 
lead.above4 <- apply(lead.pred.samples, 1, function(x) mean(x>4))

r.lead <- rasterFromXYZ(cbind(grid.pred.galicia,pred.lead))
r.sd <- rasterFromXYZ(cbind(grid.pred.galicia,sd.lead))
r.above4 <- rasterFromXYZ(cbind(grid.pred.galicia,lead.above4))

plot(r.lead)
plot(r.above4)

####

log.prior.sigma2.galicia <- function(sigma2) {
  dunif(sigma2,0,10,log=TRUE)
}

log.prior.phi.galicia <- function(phi) {
  dunif(phi,0,50,log=TRUE)
}

cp <- 
control.prior(beta.mean = 0,beta.covar = 10^10,
              log.prior.sigma2 = log.prior.sigma2.galicia,
              log.prior.phi = log.prior.phi.galicia)


bayes.mcmc <- 
control.mcmc.Bayes(n.sim=2000,burnin=1000,thin=1,
                   epsilon.S.lim = 0.1,
                   start.nugget = NULL,
                   L.S.lim = 5)

lgm.fit.bayes <- 
linear.model.Bayes(lead~1, coords=~I(x/1000)+I(y/1000),
                   data=galicia,kappa=0.5,
                   control.prior = cp,
                   control.mcmc = bayes.mcmc)

trace.plot(lgm.fit.bayes,"beta",component.beta = 1)
autocor.plot(lgm.fit.bayes,"beta",component.beta = 1)

trace.plot(lgm.fit.bayes,"sigma2")
autocor.plot(lgm.fit.bayes,"sigma2",component.beta = 1)

trace.plot(lgm.fit.bayes,"phi")
autocor.plot(lgm.fit.bayes,"phi",component.beta = 1)

pred.lead.Bayes <- 
spatial.pred.linear.Bayes(lgm.fit.bayes,
                            grid.pred = grid.pred.galicia,
                            scale.predictions = "logit",
                          standard.errors = TRUE)
plot(pred.lead.Bayes,"logit","predictions")
plot(pred.lead.Bayes,"logit","standard.errors")


###

plot(pred.lead.MLE$logit$predictions,
     pred.lead.Bayes$logit$predictions,
     xlab="MLE",ylab="Bayes",
     main="Predictions")
abline(0,1,col=2,lwd=2)

plot(pred.lead.MLE$logit$standard.errors,
     pred.lead.Bayes$logit$standard.errors,
     xlab="MLE",ylab="Bayes",
     main="Predictions")
abline(0,1,col=2,lwd=2)

###

library(help=PrevMap)
variog.diagnostic.lm(lgm.fit.mle)
