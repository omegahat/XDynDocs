# turn the x y coordinates into a list of matrices
# where the NAs dentoe the breakpoints
polys = function(x,y) {
  n = length(x)
  breaks = (1:n)[is.na(x)]
  starts = c(1, breaks+1)
  ends = c(breaks -1, n)
  p = length(starts)
  result = list()
  for (i in 1:p) {
     result[[i]] = 
        matrix(c(x[starts[i]:ends[i]],y[starts[i]:ends[i]]),ncol=2, byrow=FALSE)
  }
  result
}

