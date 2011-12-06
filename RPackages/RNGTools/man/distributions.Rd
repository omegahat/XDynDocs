\name{exponential.cdf}
\alias{exponential.cdf}
\alias{extreme.cdf}
\alias{geometric.cdf}
\alias{logistic.cdf}
\alias{pareto.cdf}
\alias{weibull.cdf}
\alias{exponential.inv}
\alias{extreme.inv}
\alias{geometric.inv}
\alias{logistic.inv}
\alias{pareto.inv}
\alias{weibull.inv}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{CDFs and Inverse CDF functions for some random variables}
\description{
  These are some CDF and inverse CDFs
  in R for different random variables.
}
\usage{
exponential.cdf(x, a)
extreme.cdf(x, a, b)
geometric.cdf(x, p)
logistic.cdf(x, mu, b)
pareto.cdf(x, a)
weibull.cdf(x, a, b)
exponential.inv(x, a)
extreme.inv(x, a, b)
geometric.inv(x, p)
logistic.inv(x, mu, b)
pareto.inv(x, a)
weibull.inv(x, a, b)
}
\arguments{
  \item{x}{the values of the random variable at which to evaluate the
    CDF or values between 0 and 1 for the inverse CDF evaluation.
   }
   \item{a}{parameter of the distribution}
   \item{b}{parameter of the distribution}
   \item{mu}{parameter of the distribution}
   \item{p}{parameter of the distribution}
}
\value{
  Numeric vector with as many values as there are
  in \code{x}.
}
\seealso{
 \code{\link{ctriang}, \code{\link{inv.triang}}}
}
\examples{
}
\keyword{distribution}

