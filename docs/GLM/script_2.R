rm(list=ls())

library(lme4)

rb <- read.csv("LiberiaRemoData.csv")

str(rb)

rb$ID <- 1:nrow(rb)


glm.fit <- glm(cbind(npos,ntest-npos) ~ log(elevation),
               data = rb,family = binomial)

glmer.fit <- glmer(cbind(npos,ntest-npos) ~ log(elevation) + (1|ID),data=rb,
                   family=binomial)

summary(glm.fit)
summary(glmer.fit)
