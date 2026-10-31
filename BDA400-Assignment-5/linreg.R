linreg <- function(regressionSource,regressionLength,regressionOffset) {
  validate_series(regressionSource);validate_period(regressionLength)
  if (!is.numeric(regressionOffset) || length(regressionOffset)!=1L ||
      is.na(regressionOffset) || !is.finite(regressionOffset) ||
      regressionOffset<0 || regressionOffset!=floor(regressionOffset))
    stop("Invalid regressionOffset")
  n <- length(regressionSource)
  if (regressionLength>n) stop("regressionLength exceeds available observations")
  if (regressionOffset>=regressionLength) stop("regressionOffset must be less than regressionLength")
  end_index <- n-regressionOffset
  start_index <- end_index-regressionLength+1L
  if (start_index<1L) stop("Not enough data for requested offset")
  y <- regressionSource[start_index:end_index]
  x <- seq_along(y)
  x_mean <- sum(x)/length(x); y_mean <- sum(y)/length(y)
  denominator <- sum((x-x_mean)^2)
  if(denominator==0) stop("At least two points are needed for regression")
  slope <- sum((x-x_mean)*(y-y_mean))/denominator
  intercept <- y_mean-slope*x_mean
  list(slope=slope,intercept=intercept,predicted_values=intercept+slope*x)
}
