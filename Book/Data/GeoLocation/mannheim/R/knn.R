
#
# Starting with the 1328 * 9 observations
# which are the unique (x, y, orientation) triples
# and the 6 base stations, cross validate to determine
# k.
#

knn =
  #
  # A matrix with x - xhat, y - yhat, k
  #
function(data, D, v = 5, verbose = TRUE)
{
    # Break the observations into v groups
    # XXX want to pad out with 0's for the extra groups
  bags = matrix(sample(1:nrow(data)), , v)
  D = as.matrix(D)

    # Loop over each group and predict the values from the observations
    # in the other bags.
  do.call("rbind", 
     lapply(seq(length = v),
          function(i) {
              if(verbose)
                 cat(i, "\n")

                # get the indices of observations we want to predict.
              w = bags[,i]

                # Get the rows for these observations, and throw out the distances to
                # these same observations so we don't predict observations based on themselves
                # or their friends in the same bag.
              subD = D[w, -w]

                # The actual location of the observations we are predicting.
              actual = data[w, c("x", "y")]

                # Process each row and find the k nearest neighbors.
                # Do all k in one go since we have to order/sort them anyway.
              do.call("rbind",
                       lapply(1:nrow(subD),
                              function(i) {
                                r = subD[i, ]        
                                o = order(r)

                                n = length(o)
                                    # compute the average for each k.
                                xhat = cumsum(data$x[-w][o])/(1:n)
                                yhat = cumsum(data$x[-w][o])/(1:n)
                                
                                data.frame(dx = actual$x[i] - xhat, dy = actual$y[i] - yhat, k = 1:n)
                              }))
          }))
}


if(FALSE) {
  D = dist(OfflineBaseStationSignals[,4:9])
  o = knn(OfflineBaseStationSignals, D)
  err = by(o[,1:2], o$k, function(x) sum(x$dx^2 + x$dy^2))
}
