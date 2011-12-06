\name{dtriang}
\alias{dtriang}
\alias{ctriang}
\alias{inv.triang}
\title{Triangular distribution functions}
\description{
  These provide the density, cumulative distribution (CDF)
  and inverse CDF functions for the generic
  triangular distribution.
  The distribution is parameterized by its
  interval [a, b] and the point in this interval, c,
  at which the mode (or peak) occurs.
}
\usage{
dtriang(x, a = 0, b = 2, c = 1)
ctriang(x, a = 0, b = 2, c = 1)
inv.triang(x, a = 0, b = 2, c = 1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{the values at which to evaluate the particular function.
   For \code{triang.inv}, these values are between 0 and 1.}
  \item{a}{the minimum value the random variable can attain, i.e.
      the start of its support.}
  \item{b}{the maximum value the random variable can attain, i.e.
      the end of its support. }
    \item{c}{the point in the support at which the
      triangular density has its mode or peak.}
}
\value{
  A numeric value giving the values of the
  density, CDF or inverse CDF evaluated at the inputs
  \code{x}.
}
\references{\url{http://winnie.ucdavis.edu/stat141/Winter04/Notes/RNG.pdf}.}
\author{Duncan Temple Lang}

\seealso{
  \code{\link[base]{runif}}
  \code{\link[base]{set.seed}}
  \code{\link[base]{RNGkind}}
}
\examples{
 u = runif(100)
  # sample from a Tr(0, 2, 1)
 x = inv.triang(u, 0, 2, 1)
}
\keyword{distribution}

