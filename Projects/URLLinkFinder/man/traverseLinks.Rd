\name{traverseLinks}
\alias{traverseLinks}
\title{Collect hyperlinks in HTML pages}
\description{
  This function is used to collect a catlog of
  links within HTML pages and to recursively process these
  links to find their links and so on.
}
\usage{
traverseLinks(urls, max = -1, filter = dropLink()$dropLink, processURL = processURLLinks)
}
\arguments{
  \item{urls}{a list or character vector giving the URIs from which to
    start the traversal.}
  \item{max}{the total number of URIs to process.
             This is used to limit the number of URIs processed when
	     debugging or handling very large sites.}
  \item{filter}{a functiont that can be used to process the
    URI names that are returned from processURL.
    This can be used, for example, to discard
    links not within a particular domain or
    within a particular sub-directory not of interest.
  }
  \item{processURL}{a function that is called to parse the specified
    URI. This allows us to easily change how we process a document,
    e.g. following images, sound files, etc.
  }
}
\details{
  This is a dynamically iterative method that maintains a queue
  of pages that need to be processed. As we encounter
  links, we resolve their names and store these for processing
  later.
}
\value{
  A list with two elements: links and errors.

  \item{links}{  
  The names of the elements of the list are the fully-qualified
  URIs that were traversed.
  Each element is a character vector corresponding to a URI
  and the vector contains the
  forward links forthat URI. In other words, it is
  a character vector containing the 
  fully-qualified names of the URIs
  found in the \code{<a href=...>} elements in the
  HTML.

  Currently, we don't include images, sound, etc.
  that are "included" in the original URI, but limit
  ourselves to the link structure.
  Also, we don't handle JavaScript.
 }
 \item{errors}{
   a character vector giving the names of the URIs which were
   not parsed because of errors.
 }

}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
  \code{\link{processURLLinks}}
  \code{\link[XML]{htmlTreeParse}}
  \code{\link{dropLink}}

  \code{\link{URI}}
  \code{\link{mergeURI}}
}
\examples{
 traverseLinks("http://www.stat.berkeley.edu/users/nolan/test0.html")
 traverseLinks("http://www.geocities.com/vi0linbear")


\dontrun{
 d = dropLink()
 gg = traverseLinks("http://www.ggobi.org/index.html", filter = d$dropLink, max = 50)

 numLinks = sapply(gg, function(x) length(unique(x)))
 hist(numLinks)
 summary(numLinks)
 }


\dontrun{
# Fail
 traverseLinks("http://www.omegahat.org", max = 10)
 traverseLinks("http://www.omegahat.org/index.html", max = 10)
}
}
\keyword{IO}

