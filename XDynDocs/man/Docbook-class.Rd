\name{Docbook-class}
\Rdversion{1.1}
\docType{class}
\alias{Docbook-class}
\alias{FO-class}
\alias{HTML-class}
\alias{TargetFormatXMLNode-class}


\title{Classes for identifying XML content as being for a target format}
\description{
  These classes allows us to label an XML node with a class in order
  to indicate and identify it as being for a particular XML dialect
  such as HTML, Formatting Objects (FO) or Docbook.
  This avoids having to examine the content to determine the intended
  format.

  These classes extend a common, virtual class
  \code{TargetFormatXMLNode} which in turn extends
  the fundamental \code{XMLInternalNode} class for representing
  XML content with C-level data structures.
  
}
\section{Objects from the Class}{

}
\section{Slots}{
	 \describe{
    \item{\code{.S3Class}:}{Object of class \code{"character"} ~~ }
  }
}
\section{Extends}{
Class \code{"\linkS4class{TargetFormatXMLNode}"}, directly.
Class \code{XMLInternalNode}, by class "TargetFormatXMLNode", distance 2.
Class \code{XMLAbstractNode}, by class "TargetFormatXMLNode", distance 3.
Class \code{"\linkS4class{oldClass}"}, by class "TargetFormatXMLNode", distance 4.
}
\section{Methods}{
  \describe{

	 }
}

\author{Duncan Temple Lang}

\seealso{

}
\examples{
showClass("Docbook")
library(XML)
new("HTML", newXMLNode("a", attrs = c(href = "http://www.omegahat.org/XDynDocs")))
}
\keyword{classes}
