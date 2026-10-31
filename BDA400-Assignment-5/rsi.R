rsi <- function(data,period) {
  validate_series(data);validate_period(period)
  n <- length(data); result <- rep(NA_real_,n)
  if(n<=period) return(result)
  changes <- diff(data);gains <- pmax(changes,0);losses <- pmax(-changes,0)
  avg_gain <- sum(gains[1:period])/period
  avg_loss <- sum(losses[1:period])/period
  calc_rsi <- function(g,l) {
    if(l==0) return(if(g==0) 50 else 100)
    100-100/(1+g/l)
  }
  result[period+1L] <- calc_rsi(avg_gain,avg_loss)
  if(n>period+1L) for(i in (period+2L):n) {
    avg_gain <- (avg_gain*(period-1)+gains[i-1L])/period
    avg_loss <- (avg_loss*(period-1)+losses[i-1L])/period
    result[i] <- calc_rsi(avg_gain,avg_loss)
  }
  result
}
