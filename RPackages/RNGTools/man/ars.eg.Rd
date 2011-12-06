\name{ars.eg}
\alias{ars.eg}
\title{Basic Acceptance/Rejection sampling}
\description{
  This function performs acceptance/rejection
  sampling using the given
  random number generation mechanism
  for the "majorizing" density and its scale factor.
}
\usage{
ars.eg(f, g, c, ggen, n = 1000)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{f}{the density from which we would like to sample but cannot do
    so directly}
  \item{g}{the density from which we can sample and which majorizes
    f.}
  \item{c}{the scale factor so that c g(x) > f(x) for all x.}
  \item{ggen}{the random number generator for the density g.
    We sample from this to get a proposal or tentative
    X value - y. Then we accept or reject it based on sampling
    a uniform random variable from the interval [0, c g(x)]}
  \item{n}{the number of samples to attempt.}
}
\details{
  The acceptance/rejection sampling technique is
  described in the document
  \url{http://winnie.ucdavis.edu/stat141/Winter04/Notes/RNG.pdf}.
  The basics are as follows.
  We want to sample from a density f(x), but we don't have
  a scheme to do this directly.
  So instead, we find another density g(x) from which we can
  sample values and also for which there exists a value
  c such that c g(x) >= f(x) for all x. 
  Then, we sample a value y from g() and a second value, u, 
  conditional on this  from a Uniform(0, c g(y)).
  If u <= f(y), we accept the value y as a sample from
  f(); if not, we reject it and go back to sampling y.
}
\value{
  A list with many components.
  These are 
  \item{accepted}{the accepted values in our sampling procedure.}
  \item{rejected}{the rejected values in our sampling procedure.}
  \item{rate}{the proportion of accepted values in our procedure,
    i.e. the number of accepted values out of the total number tried.}
  \item{X}{all the sampled values}
  \item{f}{the target density}
  \item{g}{the majorizing density.}
  \item{c}{the scaling factor such that c g(x) >= f(x) for all x.}
  \item{potential}{the sampled uniform values for each proposed value,
    i.e. X.}
  \item{acc}{the indices of the accepted samples, relative to X.}
  We keep all these elements so that we can create a plot
  us a method for the class of the return value - "ars.sample".
}
\references{\url{http://winnie.ucdavis.edu/stat141/Winter04/Notes/RNG.pdf}.}
\author{Duncan Temple Lang}


\seealso{
 \code{\link{mcmc}}
}
\examples{
acc = ars.eg(function(x) dbeta(x, 4,3), function(x) dtriang(x, 0, 1, .8), 1.6, function(n) inv.triang(runif(n), 0, 1, .8), 10000)
plot(acc)

acc.unif = ars.eg(function(x) dbeta(x, 4, 3), g = dunif, c = 2.11, ggen = runif, 10000)
plot(acc.unif)

acc$rate
acc.unif$rate
}
\keyword{distribution}


