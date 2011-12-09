\name{getStyleSheetParams}
\Rdversion{1.1}
\alias{getStyleSheetParams}
\title{Get the XSL parameters for the target XSL stylesheet}
\description{
 This function fetches the default set of parameters that are passed to
 XSL for the given target format, i.e. HTML, FO, LaTeX.
 This is called by \code{dynDoc} and similar functions to
 retrieve the default parameters in an easy fashion.
 Eventually, these will mirror those parameters in the make files.
}
\usage{
getStyleSheetParams(target, ...)
}

\arguments{
  \item{target}{a character string specifying the target format,
  e.g. "fo", "html", "latex", ... }
  \item{\dots}{additional parameters that are to be merged with, or override, the defaults}
}
\value{
  A named list which can be passed to \code{xslApplyStyleSheet}.
}

\author{
Duncan Temple Lang
}
\note{
  We should make this a generic function and pass it an
  object of the format target, e.g. HTMLTarget, FOTarget.
  Then we could override this function by defining methods for these
  target types.
  }

\seealso{
  \code{\link{dynDoc}}
  \code{\link{xml2HTML}}
  \code{\link{xml2PDF}}  
}
\examples{
getStyleSheetParams("fo")
getStyleSheetParams("HTML")
getStyleSheetParams("latex")

getStyleSheetParams("HTML", html.stylesheet = "foo.css")
getStyleSheetParams("fo", start.indent = "'10'")
}
\keyword{documentation}
