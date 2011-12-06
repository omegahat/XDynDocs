knnExpt <-
function(binDist, conDist, actualClass, w = 1, v = 10, perm = sample(1:nrow(binDist)), kmin = 1, kmax = 100)
{
  groups = cvSet(v = v, perm = perm) 
  predErrs = list()

  # lapply
  for (i in 1:length(w)) 
  {
     Dist = (w[i] * binDist) + conDist
     predErrs[[i]] = knnCV(Dist, actualClass, groups, kmin, kmax)
     remove(Dist)
  }
  predErrs
}

knnCV <-
function(Dist, actualClass, groups, kmin = 1, kmax = 100)
{
 # Determine which k's will be used 
  kmin = min(kmin, kmax)
  kmax = max(kmin, kmax)
  kmax = min(kmax, nrow(groups))  
  knnCorrect = matrix(0, nrow = 0, ncol = (kmax - kmin + 1))

 # Loop over the v training sets to make predictions for the
 # corresponding v test sets.

  for (i in 1:ncol(groups)) {
    knnPreds = knnPredict( Dist[groups[,i] , - groups[,i]], 
                           actualClass[ - groups[, i]], kmin, kmax)
    knnCorrect = rbind(knnCorrect, 
                       knnCheck( knnPreds, actualClass[groups[, i]]))
  }

  ans = predError(knnCorrect, actualClass[groups])
  ans
}

cvSet <-
function(n = 100, v = 10, perm = sample(1:n) )
{
 # Index for the permutation to give the current test set.
 # To avoid recycling, we use 0 to pad the last row with 0's.

  nrD =  length(perm)
  nr =  ceiling(nrD/v)
  length(perm) = v * nr
  perm[is.na(perm)] = 0
  groups = matrix(perm, ncol = v, byrow = TRUE)
  
  groups
}


knnPredict <-
function(distM, trainClass, kmin, kmax, tieRandom = FALSE, tieNearest = FALSE)
{
# Dist is an m by n matrix where we have m test and n training observations
# trainClass is a vector of n logicals

# Returns an m by kmax-kmin+1  matrix of logicals (predictions)

  votes <-
      apply(distM, 1, function(nn) {
               tmp = trainClass[order(nn)[1:kmax]]
               percents = cumsum(tmp)/(1:kmax)
               predict = (percents[kmin:kmax] >= .5)
               if (tieRandom) {
                 predict[percents == .5] = rbinom(n=1,size=1, prob=0.5)
               } else {
                 if  (tieNearest) {
                   predict[percents == .5] = (percents[1] > 0.5)
                 } else {
                   predict[percents == .5] =  predict[(which(percents == .5) - 1)]
                 }
               } 
               predict  
               })
  t(votes)
}


knnCheck <-
function(knnPreds, trueClass)
{
# knnPreds is an m by k matrix of logicals where we for each test observation
# we have k predictions (one for each size neighborhood)
# trueClass is a vector of m logicals indicating the true classification
# of the test observation.

# Returns an m by k matrix of logicals indicating whether the 
# prediction was correct or not.

  correctPreds = sapply(1:length(trueClass), function(i) {
                    knnPreds[i, ] == trueClass[i]
 		})

  t(correctPreds)
}

predError <- 
function(correctPreds, trueClass)
{
# correctPreds is an n by k matrix of logicals where we for each test 
# observation we have k indicators as to whether the prediction is correct
# (one for each size neighborhood)
# trueClass is a vector of n logicals indicating the true classification
# of the test observation.

# Returns an 2 by k matrix, for error rates for each type of classification,
# i.e. proportion incorrect for those with trueClass TRUE, and proportion
# incorrect for those with trueClass FALSE.

  correctTrues = colSums(correctPreds[trueClass, ], na.rm = TRUE)/
                           sum(trueClass)
  correctFalses = colSums(correctPreds[!trueClass, ], na.rm = TRUE)/
                           sum(!trueClass)

  matrix(c(correctTrues, correctFalses), nrow = 2, byrow = TRUE)
}
