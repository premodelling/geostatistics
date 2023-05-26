# Title     : Modelling.R
# Objective : Modelling
# Created by: greyhypotheses
# Created on: 09/05/2022



#' Generalised Linear Model
#'
#' @param blindness: A dataframe of river blindness modelling variables
#'
GLM <- function (blindness) {

  # model
  model <- glm( cbind(npos, nneg) ~ I(log(elevation)),
                family = binomial(link = 'logit'), data = blindness )
  summary(model)


  # Herein, "logit" means "prediction on the scale of the linear regression"
  predictions <- predict.glm(object = model)


  return(list(model = model, predictions = predictions))
}



#' Geostatistical Linear Gaussian Model
#'
#' @param blindness: A dataframe of river blindness modelling variables
#'
GeostatisticalLGM <- function (blindness) {

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


  # predict
  points <- blindness[, c('utm_x', 'utm_y')]
  gridpoints <- gridpts(as.matrix(points), xs=5000, ys=5000)/1000

  predictions <- spatial.pred.linear.MLE(
    model, grid.pred = gridpoints, predictors = blindness, standard.errors = TRUE,
    scale.predictions = 'logit', n.sim.prev = 1000)


  return(list(model = model, predictions = predictions))

}
