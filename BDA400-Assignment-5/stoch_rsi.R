stoch_rsi <- function(data,period,k_period,d_period) {
  validate_period(k_period);validate_period(d_period)
  r <- rsi(data,period);n <- length(r)
  raw_k <- rep(NA_real_,n)
  if(n>=k_period) for(i in k_period:n) {
    window <- r[(i-k_period+1L):i]
    if(all(is.finite(window))) {
      lo <- min(window);hi <- max(window)
      raw_k[i] <- if(hi==lo) 0 else (r[i]-lo)/(hi-lo)
    }
  }
  d_line <- rep(NA_real_,n)
  if(n>=d_period) for(i in d_period:n) {
    window <- raw_k[(i-d_period+1L):i]
    if(all(is.finite(window))) d_line[i] <- sum(window)/d_period
  }
  list(k_line=raw_k,d_line=d_line)
}
