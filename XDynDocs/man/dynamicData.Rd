\name{dynamicData}
\Rdversion{1.1}
\alias{dynamicData}
\title{Restore data from within the document}
\description{
  This function reads and restores data that is contained
  within the R-Docbook  document.
  It processes nodes such as
  \code{<r:value>}, \code{<r:object>} and \code{<r:data>}.
  It reads the content of such nodes and
  uses the \code{type} attribute to determine how to interpret
  this. It then restores the contents to an R object.
  It uses the \code{id} attribute to assign the resulting object
  to a variable. This mechanism allows us to
  serialize objects within the R-Docbook document.

  This is exported primarily so it is visible and callable by XSL
  code. This could be achieved by explicitly registering at as an
  XSL function.
}
\usage{
dynamicData(ctxt, node, format = "", env = globalenv())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ctxt}{the context of the XSL processing which allows us to
    access different aspects of the XSL engine currently in effect.
    This allows the function to access, for example, the XSL parameters.}
  \item{node}{the XML node containing the data}
  \item{format}{the format of the data within the node.
   This can be specified by the caller but is typically extracted from
   the attributes of the node directly.}
  \item{env}{the R environment in which the newly restored object is assigned.}
}
\value{
  This function is used for its side effect of assigning
  the object to the R variable.
}
\references{

}
\author{
Duncan Temple Lang
}

\seealso{
 \code{\link{dynDoc}}
}
\examples{

  library(XML)
  node = newXMLNode("r:data",
                     "c(0.982123259853467, 0.868113244918645, -0.371478605407784, -0.218572609383354, 
0.152739884559977, -0.406609615475891, 1.12276207375342, -1.32103542882306, 
1.62231853216012, -1.17204274196827)",
                     attrs = c(id = "xxx"),
                      namespaceDefinitions = c("r" = "http://www.r-project.org"))

  dynamicData(NULL, node)
}
\keyword{programming}
\keyword{documentation}

