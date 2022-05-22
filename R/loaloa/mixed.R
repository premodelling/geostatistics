# Title     : mixed.R
# Objective : Mixed models
# Created by: greyhypotheses
# Created on: 04/05/2022



# data
data(loaloa)
str(object = loaloa)
coordinates <- loaloa[, c('LONGITUDE', 'LATITUDE')]


# geography
loaloa <- loaloa %>% st_as_sf(coords = c('LONGITUDE', 'LATITUDE')) %>%
  st_set_crs(value = 'EPSG:4326')
loaloa <- st_transform(loaloa, crs = 32632)

loaloa$utm_x <- as.numeric(st_coordinates(loaloa, UTM)[, 1])
loaloa$utm_y <- as.numeric(st_coordinates(loaloa, UTM)[, 2])


# What?
# loaloa$geometry <- NULL
# loaloa <- base::merge(x = loaloa, y = coordinates)


# Aside.
loaloa$logit <- log((loaloa$NO_INF + 0.5)/(loaloa$NO_EXAM - loaloa$NO_INF + 0.5))
baseline <- lm(logit ~ ELEVATION + I(ELEVATION^2), data = st_drop_geometry(loaloa))
variograms <- variog(
  coords = loaloa %>% dplyr::select('utm_x', 'utm_y') %>% st_drop_geometry() %>% dplyr::select('utm_x', 'utm_y')/1000,
  data = residuals(baseline))





# 5. index level random intercept
model <- glmer(formula = cbind(NO_INF, NO_EXAM - NO_INF) ~ MEAN9901 + (1|ROW),
               family = binomial(link = 'logit'), data = loaloa)
estimates <- summary(model)
effects <- ranef(object = model)

# ... sigma^2
sigmasqr <- attr(estimates$varcor['ROW']$ROW, which = 'stddev')^2



# 6
diagnostics <- spat.corr.diagnostic(NO_INF ~ MEAN9901,
                                    units.m = ~NO_EXAM,
                                    coords = ~I(utm_x / 1000) + I(utm_y / 1000),
                                    data = loaloa,
                                    ID.coords = loaloa$ROW,
                                    likelihood = 'Binomial', lse.variogram = TRUE)

effects.intercept <- effects$ROW$`(Intercept)`
frame <- data.frame(intercept = effects.intercept, easting = loaloa$utm_x, northing = loaloa$utm_y)
effects.variogram <- variogram(frame, ~ intercept, ~ easting + northing)
plot(effects.variogram, typ = 'b', frame.plot = FALSE)












