\name{createGraphicsDevice}
\Rdversion{1.1}
\alias{createGraphicsDevice}
\title{Open a new graphics device for creating a plot within the dynamic
  document}
\description{
  This function is responsible for creating a new R graphics device
  for a plot that is created via the evaluation of code
  within an R-Docbook dynamic document.
  This is not usually called directly, but implicitly
  by the functions evaluating code in a dynamic document.
}
\usage{
createGraphicsDevice(node, dev = c(jpg = jpeg), dir = character(), verbose = FALSE, dynOpts)
}
\arguments{
  \item{node}{the XML node describing the plot and providing information
  about the format, size, etc. of the desired device}
  \item{dev}{a named list giving the graphics device function and the
    name giving the format of the device.  This is over-ridden by a
    file attribute on the \code{node}.
    }
  \item{dir}{the directory in which the plot is created, by default}
  \item{verbose}{ a logical value indicating whether to emit
    information on the console about the activities of the function.}
  \item{dynOpts}{the \code{DynamicDocContext} object providing the
    options for the evaluation of the }
}
\value{
  This is called for the side effect of
  creating an R graphics device in which subsequent
  graphics commands are displayed.
}
\author{
Duncan Temple Lang
}
\seealso{
  \code{\link{dynDoc}}
}
\examples{
  # This is not usually called directly, but implicitly
  # by the functions evaluating code in a dynamic document.
}
\keyword{programming}
\keyword{documentation}

