\name{DynamicTarget-class}
\docType{class}
\alias{DynamicTarget-class}
\alias{DocbookTarget-class}
\alias{FOTarget-class}
\alias{LaTeXTarget-class}
\alias{HTMLTarget-class}
\alias{InteractiveHTMLTarget-class}
\alias{UnknownTarget-class}

\title{Class "DynamicTarget" and other output format classes }
\description{
 When processing a dynamic document into a target format
such as HTML, FO/PDF, LaTeX, or even Docbook itself,
we use an instance of one of the derived/sub DynamicTarget classes.
We create an instance  of the appropriate class and use
this as an argument to the \code{\link{convert}}
function in order to facilitate the dispatch to S4 methods
based on the type of the R object being converted and
the target format.  So this is used primarily as a means
of method dispatch. However, target objects can also 
provide information about the target  document being
created such as its identity/filename and so on.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("DynamicTarget", ...)}.
The instances are typically created internally in the package
in the function \code{\link{DynamicOptions}} as part of 
\code{\link{xslDynamicDoc}}.
}
\section{Slots}{
	 \describe{
    \item{\code{name}:}{the name of the target}
    \item{\code{outputDirectory}:}{the name of the directory in which
      auxiliary files should be placed}
  }
}
\section{Methods}{
No methods defined with class "DynamicTarget" in the signature.
}
\author{Duncan Temple Lang}

\seealso{
 \code{\link{convert}}
}
\examples{
showClass("DynamicTarget")
}
\keyword{classes}
