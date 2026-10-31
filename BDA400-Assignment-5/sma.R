sma <- function(data, period) {
  validate_series(data); validate_period(period)
  if (length(data) < period) stop("Data length must be at least period")
  result <- numeric(length(data)-period+1L)
  for (i in seq_along(result)) result[i] <- sum(data[i:(i+period-1L)])/period
  result
}
