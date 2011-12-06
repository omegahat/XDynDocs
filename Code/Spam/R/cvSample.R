simpleCrossValidationSample =
function(n, K = 10) {
  matrix(sample(1:n, n, replace = FALSE), , K)
}

constantRateCrossValidationSample =
  #
  # Attempt to get balanced test sets 
  # with the same proportion of SPAM
  # as the original sample.
  #
function(indicator, K = 10) {

  i = 1:length(indicator)

  
  on = matrix(sample(i[indicator]) , floor(sum(indicator)/K), K)
  off = matrix(sample(i[!indicator]), floor(sum(!indicator)/K), K)

  S = rbind(on, off)

  S
}


constantRateCrossValidationSample =
function(indicator, K = 10) {

  i = 1:length(indicator)

  # S = matrix(0, ceiling(length(indicator)/K), K)

  
  n = ceiling(sum(indicator)/K) * K
  x = c(sample(i[indicator]), rep(0, n - sum(indicator)))
  on = matrix(x, , K, byrow = TRUE)

  n = ceiling(sum(!indicator)/K) * K
  x = c(sample(i[!indicator]), rep(0, n - sum(!indicator)))
  off = matrix(x, , K, byrow=TRUE)

  S = rbind(on, off)

  S
}
