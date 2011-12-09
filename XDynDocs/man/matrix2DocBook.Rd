\name{matrix2DocBook}
\alias{matrix2DocBook}
\alias{matrix2FO}
\alias{matrix2HTML}
%\alias{matrix2LaTeX}
\title{Create an XML representation of an R matrix for specific target format}
\description{
 These functions convert an R matrix into an XML representation which can
be inserted into an XML document and rendered as part of a readable document
for a human.  These take care of rendering the R object as a table
or as verbatim content.

These are typically invoked as part of the dynamic processing of a document
when returning an R matrix object as the value of some XSL computation.
However, they are also available for creating content directly within R.
}
\usage{
matrix2DocBook(obj, digits = 3, border = FALSE, frame = FALSE, ..., doc = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{the R matrix object }
  \item{digits}{integer, the number of digits to display of each individual value}
  \item{border}{logical, whether to include a border around the "table"}
  \item{frame}{logical whether to display a frame around the "table"}
  \item{\dots}{ additional parameters for the individual methods }
  \item{doc}{the document in which the XML content will be inserted.
    This can be a node or a top-level document. This can be useful when creating the
    nodes, e.g. to provide XML namespace definitions, etc.}
}
\value{
An XML node.
}
\author{Duncan Temple Lang}
\seealso{}
\examples{
}
\keyword{documentation}

