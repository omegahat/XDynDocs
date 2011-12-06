\name{computeMessageProbability}
\alias{computeMessageProbability}
\title{Compute the probability components in the Naieve Bayes classifier
  for a new message.}
\description{
  This computes one of the two terms in the probability used
  to classify a message in the Naieve Bayes classifier.
  This is designed to be used in cross validation
  for "predicting" a new observation, i.e. a message
  in the test data set.
  This takes the vector of unique words in the message
  to be classified and the table of
  log-odds ratios for all the words in the training set
  and returns the log of the product of the odds-ratio 
  of observing this message content for SPAM and HAM.
  This number should be added to the log of the
  P(SPAM)/P(HAM) for the training data in the cross
  validation to ensure comparison across the K-fold
  test sets.
  This log(P(SPAM)/P(HAM)) varies across the training sets
  since there are different numbers of SPAM messages in each.

  This function does not classify the message. It simply returns
  a probablity term that can be subsequently used to classify the
  message
  by a) adding log(P(SPAM)/P(HAM)) for the relevant training data set,
  b) thresholding the log-odds ratio for the message being SPAM or HAM.
  Cross validation is used to determine a suitable value of the
  threshold.
  So this function is i) a computational instrument in finding the
  threshold via cross validation and ii) an element for classifying
  new messages as we see them.
}
\usage{
computeMessageProbability(words, freqTable)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{words}{a character vector giving the unique words in the mail
    message to be classified.}
  \item{freqTable}{the matrix returned from
  \code{\link{computeFrequencies}}}
}
\details{
  This drops words in the new message that have not been
  observed in the training set. This is suitable since
  they give us no information about whether the message is
  HAM or SPAM, i.e. the log odds-ratio is 0 for that word.
  We then compute the log odds of observing the words
  in the message given SPAM and HAM, and add this to the
  log odds of  not observing the words that are not present in the
  message, i.e. all of the other words in the training set.
}
\value{
  A number giving the log of the probability ratio
  of the different words in the training set occurring
  or not occurring in the message being  SPAM
  and HAM under the assumption of independence of words.
}
\references{
 \url{http://winnie.ucdavis.edu/stat141/Winter04/Homeworks/naieveBayes.pdf}
}
\author{Duncan Temple Lang (duncan@wald.ucdavis.edu)}
\note{REMEMBER to add the log(P(SPAM)/P(HAM)) for the training set in
      the cross validation.}

\seealso{
 \code{\link{computeFrequencies}}
}
\examples{

}
\keyword{distribution}


