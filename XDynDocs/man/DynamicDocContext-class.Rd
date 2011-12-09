\name{DynamicDocContext-class}
\Rdversion{1.1}
\docType{class}
\alias{DynamicDocContext-class}
\alias{coerce,character,Directory-method}

\title{Settings/Options controlling the R evaluation of code in a dynamic document}
\description{
  This class is used to store the options that control the evaluation of R
  code when processing a dynamic document.
  These are separate and different from the parameters controlling the
  XSL transformation. These options control matters such as
  how output from commands is formatted, how graphics devices
  are created, where intermediate files are placed.
}
\section{Objects from the Class}{
\code{\link{DynamicOptions}} is the primary function used to create
instances of this class.
}
\section{Slots}{
	 \describe{
    \item{\code{digits}:}{Object of class \code{"integer"}, a value
      controlling the number of digits in the display of numbers in the
      textual output. This corresponds to the the \code{digits} option
      in R's \code{\link[base]{options}}. }
    \item{\code{round}:}{Object of class \code{"integer"}
      a value controlling how numbers are rounded.
    }
    \item{\code{width}:}{Object of class \code{"integer"}  controls the maximum number of columns on a line used in
          printing vectors, matrices and arrays, and when filling by
          'cat'. This corresponds to the \code{width} option in R's \code{\link[base]{options}}.}
    \item{\code{bg}:}{Object of class \code{"character"} color for the
      background of new graphics devices }
    \item{\code{fg}:}{Object of class \code{"character"} color for the
      foreground of new graphices devices }
    \item{\code{directory}:}{Object of class \code{"Directory"} the
      directory  in which intermediate files such as plots are stored.
      This can be an "anonymous" temporary directory, or can be
      specified   by the user so that she can access these files
      for subsequent use, i.e. not just for creating the PDF document.
    }
    \item{\code{plotDirectory}:}{Object of class \code{"Directory"} the
      name of the directory in which the generated plots are created.
      If this has a name, the name is used as a prefix to identify the file in the
      document.  The file is created in the specified directory, but the
      name of the file used in the document is given by this prefix and
      the file name. So this allows us to use a different directory name
      or URL that is used when the document is published. This is
      of use for HTML documents in which the images, etc. are
      external files.
     }
    \item{\code{fontSize}:}{Object of class \code{"integer"} the size of
    the default font to use in a new graphics device}
    \item{\code{fontFamily}:}{Object of class \code{"character"}
      the name of the default font family to use in a new graphics device.}
    \item{\code{device}:}{Object of class \code{"list"}
      a named list giving the function use to create a
      graphics device. Typically this will have just one element,
      e.g. \code{list(svg = svg)} but one can specify several elements.
      Different plots within the dynamic document can specify a desired
      format and the corresponding element will be used.
      In other words, if we had a plot node such as
      \code{<r:plot format="svg">plot(density(x))</r:plot>}
      and another
      \code{<r:plot format="png">plot(x, y)</r:plot>}
      we would use the svg element and the png element, if they were present.
      }
    \item{\code{deviceDims}:}{Object of class \code{"numeric"}
         dimensions (horizontal and vertical) used when creating a
	 graphics device when the dimensions are not specified on the
	 XML node within the dynamic document.}
    \item{\code{targetFormat}:}{Object of class \code{"DynamicTarget"}
        an object representing the target format for the resulting
	document. We use this object to dispatch methods such as
	\code{\link{convert}} to transform R objects to the desired format.
        }
    \item{\code{env}:}{Object of class \code{"environment"} the
      top-level environment in which to evaluate the code within the
      dynamic document. }

    \item{\code{margins}:}{Object of class \code{"numeric"}  currently
      not used.  Intended to represent the margins of the target
      document being generated. This is more an XSL parameter however.}
   \item{\code{name}}{}
   \item{\code{stopOnError}}{a logical value indicating whether an error should terminate the processing of the entire document.}
   \item{\code{other}}{}
  }
}
\section{Methods}{
  This is used in \code{\link{dynDoc}} to represent the controls
  for the evaluation. 
}

\author{Duncan Temple Lang}


\seealso{
  \code{\link{dynDoc}}
  \code{\link{DynamicOptions}} is the primary constructor function for this class.
}
\examples{
showClass("DynamicDocContext")


}
\keyword{classes}
