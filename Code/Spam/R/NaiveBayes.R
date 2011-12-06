
NaiveBayes =
function(ff = list.files(system.file("messages", package = "NaieveBayes"),  full.names =TRUE),
         messageWords = lapply(ff, getMessageWords),
         K = 10)
{
   # If we specify messageWords and now ff, then
   # we compute ff using the names given to each
   # message which is the file name.
  if(missing(ff) && !missing(messageWords))
    ff = names(messageWords)

   # Compute which are spam and which aren't
   # by looking at the names of the files.
  isSpam = logical(length(ff))
  isSpam[grep("/spmsg[a-c][0-9]+\.txt", ff)] = TRUE

  cat("% spam =", sum(isSpam)/length(ff), "\n")


  # Do the cross-validation to determine the threshold.
  # We do K-fold cross validation and we ignore any recycling
  # of data.
  samples = simpleCrossValidationSample(length(isSpam), K = K)


  # Do the cross validation by applying to each of the k training/test samples
  # The result is a list with a vector of probabilities for each of the
  # test messages for the CV group.
  probs = lapply(1:K, function(i, samples, messageWords, isSpam) {
                        cat("Test set", i, "\n")
                        doCVSet(messageWords, samples[, i], isSpam)
                      },
                      samples, messageWords, isSpam)


  # Turn this vector into a simple vector of probabilities.
  probs = unlist(probs)
  # reorder the spam so that it corresponds to the probabilities
  # in probs.
  isSpam = isSpam[as.vector(samples)]

  o = order(probs)
  invisible(list(logOdds = probs[o],  isSpam = isSpam[o], testSets = samples))
}

typeIErrorRates =
  #
  # We are interested in computing the type I
  # and II error rates for different values of
  # tau, the threshold at which we classify a message.
  # as spam.
  # vals is the vector of log-odds
function(vals, isSpam) {

  o = order(vals)
  vals =  vals[o]
  isSpam = isSpam[o]
  
  
  idx = which(!isSpam)
  N = length(idx)
  list(error = (N:1)/N, values = vals[idx])
}

typeIIErrorRates =
  #
  # proportion of spam messages we classify
  # as HAM.
function(vals, isSpam) {

  o = order(vals)
  vals =  vals[o]
  isSpam = isSpam[o]
  
  
  idx = which(isSpam)
  N = length(idx)
  list(error = (1:(N))/N, values = vals[idx])
}  


typeIErrorRate =
  #
  # For a given threshold value, tau, 
  # classify all the messages with a value
  # for logOdds > tau as SPAM.
  # Then count up all the HAM messages that
  # we incorrectly classified as SPAM
  # using this classification rule.
  # We count the number of HAM messages that
  # are classified as SPAM which is 
  # !spam
  #
function(tau, logOdds, spam)
{
  classify = logOdds > tau
  sum(classify & !spam)/sum(!spam)
}

typeIIErrorRate =
function(tau, logOdds, spam)
{
  idx = which(spam)
  sum(logOdds[idx] < tau)/length(idx)
}

if(FALSE) {
typeIErrorRate =
  #
  # For a given threshold value, tau, 
  # classify all the messages with a value
  # for logOdds > tau as SPAM.
  # Then count up all the HAM messages that
  # we incorrectly classified as SPAM
  # using this classification rule.
  # This is the explicit way of doing it:
  #  find out which messages are HAM - which(!spam)
  # Then count the number of these log odds are greater
  # than tau.
function(tau, logOdds, spam)
{
  idx = which(!spam)
  sum(logOdds[idx] > tau)/length(idx)
}
}

findTau =
  #
  # Excepts the typeI errors returned from
  # plotErrors or computed directly using
  # typeIErrorRates()
  # 
function(errors, alpha = 0.01)
{
  errors$values[order(abs(errors$error - alpha))[1]]
}  
