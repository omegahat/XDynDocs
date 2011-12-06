\name{mcmc}
\alias{mcmc}
\title{Simple MCMC function}
\description{
  This implements a simple, parameterizable
  Markov Chain Monte Carlo (MCMC)
  simulation for sampling from a density.
  This is intended for univariate sampling.
}
\usage{
mcmc(x.0 = 0, r, q, stationary, n = 1000, algorithm = metropolis)
}
\arguments{
  \item{x.0}{the starting point for the chain}
  \item{r}{a function to generate random values from
    the proposal distribution. This is called with the
    current value of the chain, X(t).}
  \item{q}{the proposal density, called with two values:
     X and Y.}
  \item{stationary}{the target stationary distribution of the Markov
    Chain from which we want to sample.
   }
  \item{n}{the number of steps in the Markov Chain.}
  \item{algorithm}{the algorithm for determining the probability
    of accepting the proposal at step t.
    This should be \code{\link{metropolis}} or \code{\link{hastings}}
    or something with the same set of arguments.}
}

\value{
  An object of class "mcmc".
  This can be used to create a plot that describes
  the chain and the sample relative to the target
  distribution.
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{\url{http://winnie.ucdavis.edu/stat141/Winter04/Notes/RNG.pdf}.}
\author{Duncan Temple Lang}

\examples{
xt = mcmc(-10, r = function(x) rnorm(1, x),
           q = function(x, y) dnorm(y, x, 1),
           sta = function(x) dt(x, 10),
           alg = metropolis)

plot(xt)
}
\keyword{distribution}

