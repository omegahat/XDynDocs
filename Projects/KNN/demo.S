
#
# Generate X1 and X2 from a MVN(0, Sigma(i))
#  and a

genData = 
function(n = c(50, 50), sigma = matrix(c(1, .1, .1 , 1), 2, 2), factor = 2)
{

  type = factor(rep(LETTERS[1:length(n)], n))

  A = matrix(rnorm(2*n[1]), , 2)%*% chol(sigma)
  B = matrix(rnorm(2*n[2]), , 2)%*% chol(sigma * factor)

  data = as.data.frame(rbind(A, B))
  names(data) = c("X1", "X2")
  data$Type = type

  data 
}


showData =
function(d, ...)
{
 plot(d[,1], d[,2], xlab = names(d)[1], ylab = names(d)[2], 
       pch = as.character(d$Type), col = c("red", "green")[d$Type], ...)
}

demo =
function(d, D = as.matrix(dist(d[, 1:2], method)), method = "euclidean")
{

 demoPoint = 
   function(n = locator(n = 1), k = 5, show = TRUE, ..., lwd = 2, lty = 1) {

       # Find the closest point if we are given (x, y) coordinates.
     if(length(n) > 1) {
       tt = as.matrix(dist(rbind(c(n$x, n$y), d[,1:2])))
       n = which(tt[1,-1] == min(tt[1,-1]))
     }

     p = d[n,1:2]

      # Find the points nearest to p
     neighbors = order(D[n,])[2:(k+1)]

     if(show)
      showData(d, ...)

     for(i in neighbors) {
        lines(rbind(p, d[i,1:2]), col = c("red", "green")[d$Type[i]], lwd = lwd, lty = lty)
     }

     list(n, table(d$Type[neighbors]))
   }

}

