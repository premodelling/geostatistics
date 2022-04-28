rm(list=ls())

library(lme4)

rb <- read.csv(file = 'data/LiberiaRemoData.csv')

str(rb)

rb$prev <- rb$npos/rb$ntest

plot(rb$elevation,rb$prev,
     xlab="Elevation", ylab="Prevalence")
rb$e.logit <- log((rb$npos+0.5)/(rb$ntest-rb$npos+0.5))
plot(rb$elevation,rb$e.logit,
     xlab="log(Elevation)",
     ylab="Empirical logit")

plot(log(rb$elevation),rb$e.logit,
     xlab="log(Elevation)",
     ylab="Empirical logit")

library(mgcv)
library(ggplot2)
gam.fit <- gam(e.logit ~ s(log(elevation)),data=rb)
lines(gam(e.logit ~ s(log(elevation)),data=rb))

rb$log.elevation <- log(rb$elevation)
plot.elev <- ggplot(rb, aes(x = log.elevation, 
                            y = e.logit)) + geom_point() +
  labs(x="Elevation",y="Empirical logit")+
  stat_smooth(method = "gam", formula = y ~ s(x),se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x,
              col="red",lty="dashed",se=FALSE)

plot.elev


plot.elev2 <- ggplot(rb, aes(x = elevation, 
                            y = e.logit)) + geom_point() +
  labs(x="Elevation",y="Empirical logit")+
  stat_smooth(method = "gam", formula = y ~ s(x),se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x + I((x-160)*(x>160)),
              col="red",lty="dashed",se=FALSE)

plot.elev2


glm.fit <- glm(cbind(npos,ntest-npos) ~ elevation + I((elevation-160)*(elevation>160)),
               data = rb,family = binomial)

summary(glm.fit)



glm.fit0 <- glm(cbind(npos,ntest-npos) ~ elevation,
               data = rb,family = binomial)

D.obs <- 2*(logLik(glm.fit)-logLik(glm.fit0))

1-pchisq(D.obs,1)

