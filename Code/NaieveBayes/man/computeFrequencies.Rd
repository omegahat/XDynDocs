\name{computeFrequencies}
\alias{computeFrequencies}
\title{Compute word probabilities for SPAM and HAM messages}
\description{
  This function returns the probability table for the large
  collection  of words found in a collection of messages.
  These probabilities can be used for new messages to compute the
  probability of the message being SPAM given its words,
  and similarly for HAM.
}
\usage{
computeFrequencies(messagesWords, spam, bow = unique(unlist(messagesWords)))
}
\arguments{
  \item{messagesWords}{a list with an entry for each message in the
    collection. Each entry is expected to be a character vector
    of unique words in that message.
   }
   \item{spam}{a logical vector corresponding to the messageWords
     list indicating whether the message is SPAM (\code{TRUE}) or
    HAM (\code{FALSE}).}
  \item{bow}{the collection of words for which we want the
    probabilities. By default, and almost always, this will be the
    set of all words in all of the given messages in
    \code{messageWords}.
   }
}
\details{
  This starts by iterating over the messages and increments the counts
  for each of the words in a given message. This yields the counts
  for the number of messages that contain the particular word.
  This is done separately for the HAM and SPAM messages.
  Then we post-process these counts to compute probabilities
  and log-odds ratios.
}
\value{
  This returns a matrix with 4 rows and
  as many columns as there are words in
  \code{bow}.
  The rows are named:  spam, not spam, present-log-odds
  and abset-log-odds.
  The column names are the words in \code{bow}.
  The "spam" row gives the
  probability of the specific word being in a message given that the
  message is SPAM, i.e.
  P(word occurs| message is SPAM).
  The "not spam" row gives the
  probability of the specific word being in a message given that the
  message is HAM, i.e.
  P(word occurs| message is HAM).
  (Note that this is not 1 - row[1,]!)
  Since we use the log odds for the words that are present
  and the words that are absent in a message, we compute these
  just once when constructing this table.
  The "present-log-odds" row gives the log of the odds-ratio
  for the word being in a message for SPAM and HAM,
  i.e
  log(P(word occurring | message is SPAM)/P(word occurring | message is
  HAM))
  Similarly,
  the "absent-log-odds" row gives the log of the odds-ratio
  for the word not being in a message for SPAM and HAM,
  i.e
   log(P(word NOT occurring | message is SPAM)/P(word NOT occurring | message is HAM)).
   The probability of a word not occurring given that it is SPAM is
   1 - probability of it occurring, given that it is SPAM.
   Similarly, the probability for HAM is the complement of the
   probability of the word occurring.  This row returns
   the log of the odds ratio for these two events.
}
\references{
  \url{http://winnie.ucdavis.edu/stat141/Winter04/Homeworks/naieveBayes.pdf}
}
\author{Duncan Temple Lang (duncan@wald.ucdavis.edu)}


\seealso{
 \code{\link{computeMessageProbability}}
}
\examples{

}
\keyword{distribution}
