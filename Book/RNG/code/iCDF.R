dtriang =
function(x, a, b, c)
{
  l = x < c

  ans = numeric(length(x))
  ans[l] = 2*(x[l] - a)/((b-a)*(c-a))
  ans[!l] = 2*(b - x[!l])/((b-a)*(b - c))  
  ans
}

icdf = function(n, lambda= 0.25) {
  u  = runif(n)
  y.e = - log(1 - u)/ lambda
  oldpar = par(mfrow=c(1,2), mar=c(3,3,2,1))
  hist(y.e, prob = TRUE, breaks = 15, xlim = c(0, 25),
     main = paste("Histogram"),
#    xlab = expression(paste("Exponential: ", lambda == 0.25, " and n = 200"))
     xlab="", cex = 0.5)
  curve(dexp(x, lambda), 0, max(y.e), add=TRUE, col = "red")
  plot(ecdf(y.e), verticals=TRUE, do.p =FALSE,
     xlim = c(0, 25), ylab=" ", 
#    xlab = expression(paste("Exponential: ", lambda == 0.25, " and  n = 200")),
     xlab="",
     main = paste("Empirical CDF"), cex=0.5)
  curve(pexp(x, lambda), 0, max(y.e), col="red", add=TRUE)
  rug(y.e)
  rug(u, side =2)
  par(oldpar)
  invisible(y.e)
}

