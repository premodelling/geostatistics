# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 25/04/2022

data(loaloa)
str(object = loaloa)


# The models
A <- glm(formula = cbind(NO_INF, NO_EXAM - NO_INF) ~ ELEVATION + pmax(ELEVATION - 650, 0),
         family = binomial(link = 'logit'), data = loaloa)

B <- glm(formula = cbind(NO_INF, NO_EXAM - NO_INF) ~ ELEVATION + pmax(ELEVATION - 700, 0),
         family = binomial(link = 'logit'), data = loaloa)

C <- glm(formula = cbind(NO_INF, NO_EXAM - NO_INF) ~ ELEVATION + pmax(ELEVATION - 750, 0),
         family = binomial(link = 'logit'), data = loaloa)


# Model B has the largest ln(likelihood)
list(A = as.numeric(logLik(A)), B = as.numeric(logLik(B)), C = as.numeric(logLik(C)))


# Graph
EL <- function (positive, negative) {
  values <- log((positive + 0.5)/(negative + 0.5))
  return(values)
}

loaloa$empirical.logit <- EL(positive = loaloa$NO_INF, negative = loaloa$NO_EXAM - loaloa$NO_INF)
loaloa$fitted.values <- B$fitted.values

ggplot(data = loaloa, mapping = aes(x = ELEVATION, y = empirical.logit)) +
  geom_point(alpha = 0.35) +
  geom_smooth(mapping = aes(x = ELEVATION, y = log(fitted.values)), method = 'lm', formula = y ~ splines::bs(x, df = 3)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(size = 0.05))





# 3 a & b
# d{beta_{0} + beta_{1}e + beta_{2}e2}/de = 0
E <- glm(formula = cbind(NO_INF, NO_EXAM - NO_INF) ~ ELEVATION + I(ELEVATION*ELEVATION),
         family = binomial(link = 'logit'), data = loaloa)
template <- summary(E)
-template$coefficients['ELEVATION', 'Estimate'] / (2*template$coefficients['I(ELEVATION * ELEVATION)', 'Estimate'])


# 4
ggplot(data = loaloa, mapping = aes(x = ELEVATION, y = empirical.logit)) +
  geom_point(alpha = 0.35) +
  geom_smooth(mapping = aes(x = ELEVATION, y = log(fitted.values)),
              method = 'lm', formula = y ~ splines::bs(x, df = 3)) +
  geom_smooth(mapping = aes(x = ELEVATION, y = log(E$fitted.values)),
              method = 'lm', formula = y ~ splines::bs(x, df = 3), colour = 'green') +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(size = 0.05))

# 4b: The deviance of B is lower
anova(B, E)



# 5
ggplot(data = loaloa, mapping = aes(x = MEAN9901, y = empirical.logit)) +
  geom_point(alpha = 0.35) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(size = 0.05))






