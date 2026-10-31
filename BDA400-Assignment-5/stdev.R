stdev <- function(data) {
  validate_series(data)
  if(!length(data)) stop("data must not be empty")
  mu <- sum(data)/length(data)
  sqrt(sum((data-mu)^2)/length(data))
}
