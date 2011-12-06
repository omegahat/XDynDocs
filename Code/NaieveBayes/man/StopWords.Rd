\name{StopWords}
\docType{data}
\alias{StopWords}
\title{Stop words for Mail Messages}
\description{
  This is a collection of words that can and should be omitted
  from mail messages when preparing them for input into the
  naieve Bayes classifier.
}
\usage{data(StopWords)}
\source{
 Lingspam  corpus and Web sites on conjunctions, etc.
}
\examples{
data(StopWords)
\dontrun{
match(message, StopWords)
}
}
\keyword{datasets}
