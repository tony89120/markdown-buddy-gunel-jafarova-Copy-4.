ema <- function(data,period) {
  validate_series(data); validate_period(period)
  if (!length(data)) return(numeric(0))
  multiplier <- 2/(period+1)
  result <- numeric(length(data)); result[1] <- data[1]
  if (length(data)>1L) for (i in 2:length(data))
    result[i] <- (data[i]-result[i-1L])*multiplier+result[i-1L]
  result
}
