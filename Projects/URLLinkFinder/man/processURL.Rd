\name{processURLLinks}
\alias{processURLLinks}
\title{Parse a URI, collecting links}
\description{
  This parses the HTML document given by the URI
  and collects all the links referenced within
  the document.
}
\usage{
processURLLinks(u)
}
\arguments{
  \item{u}{the URI to parse and in which to fiund the <a href=..> hyper-references.}
}

\value{
  A character vector giving the names of the URIs
  that were found as links in the specified URI being parsed.
}
\references{ }
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{\code{\link{traverseLinks}}}
\examples{

}
\keyword{IO}
