\name{xmlSourceVariable}
\alias{xmlSourceVariable}
\title{Process the code elements involved in defining particular variables within a dynamic document.}
\description{
 This function is used to identify the code elements within a dynamic document
 that are necessary to define one or more variables specified by the user.
 This analyzes the code elements for dependencies to identify
 those of relevance. It omits code elements that are not needed
 to explicitly define the variable, so code elements with potential side-effects
 that would affect the state of the R session may be omitted.

 The code elements can be returned for processing by the caller
 or are evaluated in order to define the relevant variable.
 The evaluation can be controlled by specifying a suitable 
 environment
}
\usage{
xmlSourceVariable(vars, doc, eval = TRUE, env = globalenv())
}
\arguments{
  \item{vars}{}
  \item{doc}{}
  \item{eval}{}
  \item{env}{}
}

\value{
 A list
}
\references{}
\author{Duncan Temple Lang}

\seealso{
 \code{\link[XML]{xmlParse}}
}
\examples{

}
\keyword{documentation}
\keyword{programming}

