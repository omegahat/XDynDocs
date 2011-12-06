\name{rng}
\alias{rng}
\title{Multiplicative Congruential Generator}
\description{
  A simple function to create a multiplicative
  congruential generator with
  particular values of a and m in
  \code{x(t+1) = a * x(t) mod m}
}
\usage{
rng(a = 17, m = 2^13 - 1, seed = m/2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{a}{the multiplicative term by which we multiply
    the current value.}
  \item{m}{the modulus in the congruential generator}
  \item{seed}{a seed from which to start the congruential generator.}
}

\value{
  A function from which we can generate random numbers.
}
\references{
  Gentle's book on Random Number Generator, Springer.
}
\author{Duncan Temple Lang}

\examples{
 # From Gentle's book
 f.17 = rng(17, 2^13-1)
 x = f.17(500)

 cor(x[-500], x[-1])
 # Look at the lines!
 plot(x[-500], x[-1])

 f.85 = rng(85, seed = 1233)
 x = f.85(500)
 cor(x[1:498], x[-c(1,2)])

}
\keyword{distribution}

