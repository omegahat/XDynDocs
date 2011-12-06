#
# Taken from Gentle
#
#
ars.eg =
function(f, g, c, ggen, n = 1000)
{
   # Generate from the density g.
  y = ggen(n)

   # Now, for each sampled y value,
   # sample from a U(0, c*g(y)
  potential = sapply(y, function(x) runif(1, max = c*g(x)))

  acc = sapply(1:n, function(i) potential[i] < f(y[i]))

  x = list(accepted = y[acc], rejected = y[!acc], rate = sum(acc)/n, X = y, f = f, g = g, c = c, potential = potential, acc = acc)

  class(x) <- "ars.sample"
  x
}


# acc = ars.eg(function(x) dbeta(x, 4,3), function(x) ptr(x, 0, 1, .8), 1.6, function(n) tr.inv(runif(n), 0, 1, .8), 10000)

#  acc.unif = ars.eg(function(x) dbeta(x, 4, 3), g = dunif, c = 2.11, ggen = runif, 10000)

plot.ars.sample =
function(x, ...)
{
   #  x$c * x$g(x$X)
  r = range(x$X)

     # Draw the accepted points
  plot(x$accepted, x$potential[x$acc], pch = ".", col="grey",
        xlab = "X", ylab="Density",
        xlim = r, ylim=range(c(0, x$c*x$g(x$X))), ...)
     # draw the rejected points
  points(x$rejected, x$potential[!x$acc], pch = ".", col="salmon")  

     # Draw the target density, f(x), i.e. the one we want samples
     # from.
  f = function(z) x$f(z)
  curve(f, r[1], r[2], add = TRUE, col = "brown", lwd = 3)

     # Draw the scaled sampling density, i.e. g(x)
  f = function(z) {x$c * x$g(z)}
  curve(f, min(x$X), max(x$X), add = TRUE, col="blue", lwd = 3)

     # Superimpose a histogram of the actual accepted values.
  hist(x$accepted, add = TRUE, prob = TRUE, lwd = 2)
  
  invisible(x)
}  


