\name{convert}
\alias{convert}
\alias{convert,ANY,ANY,FOTarget-method}
\alias{convert,ANY,ANY,HTMLTarget-method}
\alias{convert,ANY,ANY,LaTeXTarget-method}
\alias{convert,anova,ANY,LaTeXTarget-method}
\alias{convert,array,ANY,HTMLTarget-method}
\alias{convert,data.frame,ANY,FOTarget-method}
\alias{convert,data.frame,ANY,HTMLTarget-method}
\alias{convert,lm,ANY,LaTeXTarget-method}
\alias{convert,matrix,ANY,HTMLTarget-method}
\alias{convert,table,ANY,HTMLTarget-method}
\alias{convert,xtable,ANY,DocbookTarget-method}
\alias{convert,xtable,ANY,FOTarget-method}
\alias{convert,xtable,ANY,HTMLTarget-method}

\alias{coerce,xtable,Docbook-method}
\alias{coerce,xtable,FO-method}
\alias{coerce,xtable,HTML-method}

\alias{convert,ANY,ANY,DocbookTarget-method}
\alias{convert,data.frame,ANY,DocbookTarget-method}
\alias{convert,matrix,ANY,DocbookTarget-method}
\alias{convert,table,ANY,DocbookTarget-method}

\alias{newVerbatimNode}
\alias{newVerbatimNode,FOTarget-method}
\alias{newVerbatimNode,HTMLTarget-method}


\title{Convert an R object to a format depending on the target format}
\description{
  This generic function and its methods provide a flexible, extensible
  mechanism for converting an R object into a representation
  that can be inserted into the output of a dynamic 
  document.  
}
\usage{
convert(from, opts = NULL, target, context = NULL)
}
\arguments{
  \item{from}{the R object to be converted to a suitable representation.}
  \item{opts}{a list of options or a \code{DynamicOptions} object
    providing "global" information controlling the processing of the
    dynamic documents.}
  \item{target}{an instance of one of the sub-classes of \code{\link{DynamicTarget-class}}
       that is used to determine the target format of the resulting document and so the 
       format expected of serializing \code{from}.}
  \item{context}{an object providing the context in which the conversion
  is being performed. In an dynamic document, this is the XSL context
  and provides access to the style sheet, the input document, the
  current node being generated, XSL parameters, and so on.  This can
  then be queried to provide "global" information.}
}
\details{

}
\value{
}
\author{Duncan Temple Lang}
\seealso{
 \code{\link{dynDoc}}
}
\examples{
}
\keyword{IO}
\keyword{programming}

