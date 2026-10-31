source("helpers.R")
for(indicator in c("sma","ema","macd","stdev","linreg","rsi","stoch_rsi","crossover","crossunder"))
  source(paste0(indicator,".R"))
source("test_indicators.R")
