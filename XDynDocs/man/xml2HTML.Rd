\name{xml2HTML}
\Rdversion{1.1}
\alias{xml2HTML}
\alias{rdb2HTML}
\alias{xml2PDF}
\alias{rdb2PDF}

\title{Process XML/R-Docbook document to HTML or PDF statically}

\description{
 These functions provide R-level facilities for processing an
 XML/R-docbook document to HTML or PDF but without running
 the code in the document, but merely displaying it as-is in the
 document.  (For dynamically running the code and inserting the results, use
 \code{\link{dynDoc}}.)
 
 The \code{xml2PDF} function attempts to use FOP to create the PDF from
 the Formatting Object (FO) document.
 
 The functions xml2HTML and rdh2HTML are identical, just with different
 names to indicate that they can be used for R-Docbook (rdb) files.
 The same applies to the PDF functions.
 
 These are just convenience functions to do things from within R.
 They currently do not specify all the useful XSL parameters to
 control the creation of the document. A better way is to use
 the make file that comes with this \code{XDynDocs} package.
 \code{make -f <directory of installed XDynDocs package>/Make/Makefile myDoc.html}
 
}
\usage{
xml2HTML(file,
         style = "http://www.omegahat.org/XDynDocs/XSL/OmegahatXSL/html/Rhtml.xsl",
         ..., out = gsub("\\\\.(Rdb|xml)$", "\\\\.html", file),
         .params = XSL_DB_Opts)
}
\arguments{
  \item{file}{the source document, either a file or a parsed XML document}
  \item{style}{the XSL stylesheet}
  \item{\dots}{additional parameters passed on to \code{xsltApplyStyleSheet}}
  \item{out}{the name of the output file or \code{NULL}}
  \item{.params}{an alternative way to specify XSL parameter name-value pairs as a list or character vector.}
}
\value{

}
\references{

}
\author{
Duncan Temple Lang
}


\seealso{
  \code{\link{dynDoc}}
  \code{xsltApplyStyleSheet} in the XSL package.
}
\examples{
  doc = system.file("docs", "Rdocbook.xml", package = "XDynDocs")
  xml2HTML(doc, out = "foo.html")
  xml2PDF(doc, out = "foo.pdf")
}
\keyword{documentation}

