
cong = function(n,a=3,b=64,start=17) {
  x = vector(mode="numeric",length=n)
  x[1] = (a*start) %% b
  for (i in 2:n) {
    x[i] = (a*x[i-1]) %% b
  }
  invisible(x)
}

xBad = cong(200, a = 17, b = 213)
xBest = cong(200, a = 69069, b = 2^32)
n = length(xBad)

 png("cong.png", width = 480, height=900)
 par(mfrow=c(2,1))
 x = xBad
 plot(x[1:(n-1)], x[2:n],xlab="Current value", ylab="Next value", main="Next value = (17 * Current value) mod 213", cex = 0.5)
 x = xBest
 plot(x[1:(n-1)], x[2:n],xlab="Current value", ylab="Next value", main="Next value = (69069 * Current value) mod 2^32", cex =0.5)
 dev.off()

