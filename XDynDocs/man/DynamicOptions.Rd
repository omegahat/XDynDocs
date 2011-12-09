\name{DynamicOptions}
\Rdversion{1.1}
\alias{DynamicOptions}
\title{Compute the options for the target format}
\description{
  This function computues the collection of options that govern
  the evaluation of the code in the dynamic document for the given
  target output format. This includes aspects such as the
  format of graphical output (e.g. PDF, SVG, JPEG or PNG),
  directory in which to place intermediate files (e.g. graphics output),
  number of characters for printing R output, number of digits to
  display, 
  display for the prompt,
  background and foreground colors for graphics devices, font size and
  family, environment for evaluation, ...
  These are options controlling the R evaluator rather than the XSL
  parameters controlling the XSL engine.
  They provide the context for the evaluation of the code in the
  document.
}
\usage{
DynamicOptions(target, ..., obj = new(.class), .class = "DynamicDocContext")
}

\arguments{
  \item{target}{the name of the target, e.g. "html", "fo", "latex"}
  \item{\dots}{user-specified options as name = value pairs that
    override the default options.}
  \item{obj}{the instance to populate and return}
  \item{.class}{the name of the class of which we return an instance.}
}
\value{
  An object of class \code{DynamicDocContext}.
}
\author{
Duncan Temple Lang
}
\note{
  This approach and function is quite extensible in that if
  you specify the name of a sub-class via the \code{.class} function
  the function returns an instance of that class.
  It also processesthe \code{...} arguments relative to the slots of
  that new class and matches those rather than the "fixed"
  \code{DynamicDocContext} class.
}

\seealso{
 \code{\link{dynDoc}}  
}
\examples{
 DynamicOptions("HTML")
 DynamicOptions("HTML", deviceDims = c(10, 10))

 DynamicOptions("FO")
 DynamicOptions("FO", digits = 3, width = 72)


   # To illustrate extensibility using sub-classes
 setClass("MyDynamicDocContext", contains = "DynamicDocContext",
           representation(graphicsHook = "function"))
 x = DynamicOptions("HTML", graphicsHook = function(file) {
                               # annotate the SVG file to make it interactive
                              }, .class = "MyDynamicDocContext")

 x@graphicsHook
 x@width
}
\keyword{documentation}

