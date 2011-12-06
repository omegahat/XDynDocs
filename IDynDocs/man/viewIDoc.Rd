\name{viewIDoc}
\alias{viewIDoc}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
viewIDoc(doc = system.file("examples", "isim.xml", package = "IDynDocs"), xsl = system.file("XSL", "ihtml.xsl", package = "IDynDocs"), title = NA, env = new.env(), parserHandlers = createIDocHandlers(..., .env = env, .basicHandlers = .DefaultIHandlers[if (.useXML) -(1) else integer()]), .useXML = TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{doc}{ ~~Describe \code{doc} here~~ }
  \item{xsl}{ ~~Describe \code{xsl} here~~ }
  \item{title}{ ~~Describe \code{title} here~~ }
  \item{env}{ ~~Describe \code{env} here~~ }
  \item{parserHandlers}{ ~~Describe \code{parserHandlers} here~~ }
  \item{.useXML}{ ~~Describe \code{.useXML} here~~ }
  \item{\dots}{ ~~Describe \code{\dots} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
 viewIDoc("inst/examples/isim.xml")
 if(is.loaded("gdk_flush"))
    .C("gdk_flush")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
