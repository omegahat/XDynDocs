\name{docbookVersion}
\alias{docbookVersion}
\title{Query the version of the Docbook XSL distribution being used}
\description{
 This function determines the version number of the 
 Docbook XSL distribution which is used to process 
 Docbook documents. This uses the catalogs to resolve the
 general docbook URL and examines the VERSION file within that
 distribution. 
}
\usage{
docbookVersion(file = catalogResolve("http://docbook.sourceforge.net/release/xsl/current/VERSION"))
}
\arguments{
  \item{file}{the full location of the VERSION file within the Docbook XSL distribution.
    This can be a local file or a remote URL.}
}
\value{
  A string of the form "major.minor.patch".
}
\references{Docbook XSL distribution}
\author{Duncan Temple Lang}
\seealso{\code{\link{dynDoc}}}
\examples{

}
\keyword{documentation}


