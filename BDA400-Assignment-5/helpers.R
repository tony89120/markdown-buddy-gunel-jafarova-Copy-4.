validate_series <- function(data) {
  if (!is.numeric(data) || any(!is.finite(data))) stop("data must be a finite numeric vector")
}
validate_period <- function(period) {
  if (!is.numeric(period) || length(period) != 1L || is.na(period) ||
      !is.finite(period) || period < 1 || period != floor(period))
    stop("period must be a positive integer")
}
validate_pair <- function(a,b) {
  if (!is.numeric(a) || !is.numeric(b) || length(a) != length(b))
    stop("Both inputs must be numeric vectors of equal length")
}
