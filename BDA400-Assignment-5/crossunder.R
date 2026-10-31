crossunder <- function(arr1,arr2) {
  validate_pair(arr1,arr2);n <- length(arr1);result <- rep(FALSE,n)
  if(n>1L) for(i in 2:n) {
    if(all(is.finite(c(arr1[i-1L],arr2[i-1L],arr1[i],arr2[i]))))
      result[i] <- arr1[i]<arr2[i] && arr1[i-1L]>=arr2[i-1L]
  }
  result
}
