\name{formatCode}
\alias{formatCode}
\title{Format R code for displaying in a document}
\description{
  This function is used to take code as text and format it
  for display in with the appropriate width - number of characters  -
  etc.
  It is exported  so that it can be called from XSL code that performs
  the formatting.
}
\usage{
formatCode(node, defaultWidth = options()$width, ...)
}
\arguments{
  \item{node}{the XML node that contains the R code to be parsed and
    formatted.
    The node can have attributes that control the formatting, e.g.
     \code{width} which is passed to \code{\link[base]{deparse}.}}

  \item{defaultWidth}{the width to use in the call to \code{deparse} if the node does not have an explicit
    r:width attribute.}
  \item{\dots}{additional parameters that are currently
    ignored. Intended for methods.}
}
\value{
  A character string.
}
\author{
Duncan Temple Lang
}
\note{
  We may enhance this to format the results in HTML or FO or LaTeX.
  In fact there is a collection of methods in highlight.R that are
  overridden but are much more general.
}

\seealso{
\code{\link{dynDoc}}
}
\examples{

}
\keyword{programming}
\keyword{output}

