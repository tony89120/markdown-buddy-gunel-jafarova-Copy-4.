macd <- function(data,short_period,long_period,signal_period) {
  validate_period(short_period);validate_period(long_period);validate_period(signal_period)
  if(short_period>=long_period) stop("short_period must be less than long_period")
  macd_line <- ema(data,short_period)-ema(data,long_period)
  signal_line <- ema(macd_line,signal_period)
  list(macd_line=macd_line,signal_line=signal_line,histogram=macd_line-signal_line)
}
