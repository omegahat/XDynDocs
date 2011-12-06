\name{getHTMLText}
\alias{getHTMLText}
\title{Extract text components from HTML content}
\description{
  This function discards all the HTML markup from
  HTML content, leaving just a vector of the text
  elements in the document.
  It does this by actually parsing the HTML
  document (rather than via regular expressions)
  and uses the \code{XML} package.
}
\usage{
getHTMLText(msg)
}
\arguments{
  \item{msg}{the HTML content typically extracted from a mail message.
    This can be the name of an HTML file, but this is not likely to be
    used in this context, i.e. the mail message classification.
   }
}
\details{
 This uses the XML package to parse the HTML content.
}
\value{
  A character vector containing the different
  text elements found in the document.
}

\references{
  \url{http://winnie.ucdavis.edu/stat141/Winter04/Homeworks/naieveBayes.pdf}
  \url{http://www.omegahat.org/RSXML}
}
\author{Duncan Temple Lang (duncan@wald.ucdavis.edu)}

\examples{
txt = 'The <i>XML</i> package is available from <a href="http://www.omegahat.org/RSXML">Omegahat</a> '
getHTMLText(txt)
}
\keyword{IO}


