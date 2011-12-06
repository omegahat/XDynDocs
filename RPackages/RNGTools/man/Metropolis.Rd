\name{metropolis}
\alias{metropolis}
\alias{hastings}
\title{MCMC proposal probability calculation.}
\description{
  These two functions provide implementations of the simple
  Metropolis and Metropolis-Hastings probabilities
  for accepting a proposal value in an Markov Chain Monte Carlo
  simulation.
}
\usage{
metropolis(x, y, stationary, proposal)
hastings(x, y, stationary, proposal)
}
\arguments{
  \item{x}{the current value of the Markov chain, X(t)}
  \item{y}{the proposed value for the next step of the chain
    and the one for which we want to accept with a probability
    given by the result of one of these functions.}
  \item{stationary}{the target distribution from which we are attempting
    to sample in the MCMC.}
  \item{proposal}{the proposal density from which we sample our proposal
  distributions. This is a density, not a random number generation mechanism.}
}

\value{
  A real number that gives the probability for accepting the proposed
  value 'y'.
}
\references{\url{http://winnie.ucdavis.edu/stat141/Winter04/Notes/RNG.pdf}.}
\author{Duncan Temple Lang}

\seealso{mcmc}
\examples{

}
\keyword{distribution}

