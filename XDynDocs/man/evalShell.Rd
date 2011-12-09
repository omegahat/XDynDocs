\name{evalShell}
\Rdversion{1.1}
\alias{evalShell}
\title{Evaluat UNIX shell commands}
\description{
  This function is used to evaluate shell commands,
  passed to \code{\link[base]{system}}.
  It is passed an XML node which contains the code
  and also has attributes that govern how it is evaluated
  and how the results are presented/displayed.
  
  This function is exported so it is available to XSL code.
}
\usage{
evalShell(node)
}

\arguments{
  \item{node}{the XML node containing the shell commands and attributes
    that control how it is evaluated and how the results are returned.
  }
}
\value{
 A string (i.e. character vector of length 1).
}
\author{
Duncan Temple Lang
}


\seealso{
  \code{\link{dynDoc}}
  \code{\link[base]{system}}
}
\examples{
  library(XML)
  node = newXMLNode("sh:code", "ls",
                     attrs = c(numLines = "10"),
                      namespaceDefinitions = c("sh" = "http://www.shell.org"))

  evalShell(node)
}
\keyword{programming}
