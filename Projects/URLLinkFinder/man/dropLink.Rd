\name{dropLink}
\alias{dropLink}
\title{Basic URI filter}
\description{
  This is a function that provides a basic link filter
  that discards URIs that have an extension that we don't
  want to process such as images, archives (zip and tar files),
  Word and PDF files, etc.
}
\usage{
dropLink(dropped = character(),
         extensions =  c("zip", "exe", "avi", "mpg", "mpeg", "jpeg", "jpg",
                         "gif", "png", "sh", "csh", "pl", "py", "gz", "tar",
                          "ps", "pdf", "doc"))
}
\arguments{
  \item{dropped}{a character vector giving regular expressions
     to use to match.
   }
   \item{extensions}{a character vector giving extensions of files that
     we don't want to process. These are things such as PDF, Postscript,
     image files.}
}
\value{
  This returns a list of two functions:
  \item{dropLink}{this is used to filter URIs.
    This cumulates the discarded URIs in a vector which is accessible
    after the processing via the second function \code{dropped}.}
  \item{dropped}{this provides access to the collection of discarded URI
  names.}
}
\references{}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu> }

\seealso{
\code{\link{traverseLinks}}
}
\examples{

}
\keyword{IO}

