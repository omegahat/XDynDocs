
\name{dynDoc}
\alias{dynDoc}
\alias{xslDynamicDoc}

\title{Process a dynamic document }

\description{
    
    This uses XSL and R to process an XML dynamic document 
    into a rendered document by evaluating the R code 
    within the document and inserting the results within the 
    newly generated document.
    This is the top-level function which handles details
    of finding the correct style sheet, checking whether the
    processing needs to be done, etc.
    The function 
     \code{xslDynamicDoc}
    does the
    actual processing via XSLT.
    
    
    The action of the function is a combination of XSL and R processing, with 
    Docbook XSL style sheets and our extensions processing
   the input XML and applying template rules to render those.
    Some of the templates make calls to R functions via 
    the Sxslt infrastructure and similarly,
     the R functions can access the XSL engine and its templats and "functions".
    
    
     There are many different options that can be passed to the
      XSL processor and to the R functions that perform the evaluation.
     Documentation for the XSL parameters is \url{}
    
    
     Since the evaluation of the code can, in general, take some timek
     the function checks whether the output file already exists and 
     if it is more recent than the source XML document. If it is,
     it will return immediately and avoid re-processing the document.
     The argument force can be used to avoid this.
    
    
    This function is similar to weaving in Sweave to generate
     the document for the end reader.
    
  }

\usage{
dynDoc(doc, target = "FO", xsl = getStyleSheet(target), 
        out = paste(directory, gsub("(xml|Rdb)$", getExtension(tolower(target)), basename(doc)),
                    sep = .Platform$file.sep), 
       fop = FopExec, xslParams = getStyleSheetParams(target),
       fopArgs = character(), 
       env = dynDocsEnv(), 
       directory = if (missing(out) || all(is.na(out)))
                      dirname(if (is.character(doc)) doc 
                   else 
                      docName(doc)) else dirname(out[1]),
       imageDirectory = if(!is.na(workDir)) "." else directory, 
       graphicsDevice = list(svg = svg), 
       dynOpts = DynamicOptions(target,
                                  width = if(target == "HTML") options()$width else 72,
                                  directory = if(!is.na(workDir)) "." else directory,
                                  device = graphicsDevice,
                                  stopOnError = stopOnError,
                                  env = env), 
       ..., force = FALSE, 
        invocation = paste(deparse(sys.call(), if (target == "HTML") 90 else 50), collapse = "\n"), 
       .errorFun = XML:::xmlErrorCumulator(), verbose = TRUE,
        stopOnError = FALSE, workDir = getDir(doc))

xslDynamicDoc(doc, xsl, ..., .xslParams = list(...), format = "FO", env = dynDocsEnv(), 
              dynOpts = DynamicOptions(format, ...), 
              .errorFun = XML:::xmlErrorCumulator(), verbose = TRUE,
              xslFuns = defaultXSLFunctions(format, env, dynOpts),
              workDir = getDir(doc))

}

\arguments{
 \item{doc}{the name of the file containing the document or alternatively a previously parsed or generated 
   XMLInternalDocument object.
   }
 \item{target}{a string identifying the desired target format.
This can be one of "HTML", "FO", "LaTeX", "iHTML".
This is used to find the relevant style file, etc.
}
\item{xsl}{
either the file name of the XSL style sheet to use (given as a local
file or as a URL which is passed through the catalog resolution
mechanism to attempt to find a local file) or a previously parsed
(or created) XSL style sheet, e.g. 
}
\item{out}{the name of the file to which the resulting
document should be written.
This can be  or character(0)
to indicate that the internal XML document should be returned
directly. This allows the 
}
\item{fop}{ a string
that specifies the executable for running
the FO processing step. We have used
FOP, the \url{http://www.apache.org/fop}
FO processor written in Java.
This string tells R where fop was installed. This
should be detected/specified at configuration time,
but we allow the caller to specify it here so
that he/she can experiment with new versions.
}
\item{xslParams}{ a name-value character vector (i.e. named
strings) providing XSL parameter values that are passed to

     \code{xslDynamicDoc}
    and onto 
\code{\link[Sxslt]{xsltApplyStyleSheet}}
.
These include parameters such as 
use.existing.data, r:verbose,  showCode
which are used within the XSL style sheets.
}\item{fopArgs}{
a character vector providing command line
arguments that are used in a call to the FO processing
application, if that is performed.
This is irrlevant for conversion to HTML and formats other than
PDF via FO.
}\item{env}{
the R environment in which the R code within the document nodes
will be evaluated.
This can be \code{\link{globalenv}} if any function
definitions and assignments in general
are to be preserved after the processing of the XML document,
or alternatively a separate environment.
The default is to create a new environment which will serve 
for this instance of processing this document.
One can supply an environment which is already populated with
values, however this does not necessarily make sense given that
the XML document is supposed to contain all the code it needs.
However, that would allow us to process a sub-part of
the document and not starting at the beginning.
}\item{directory}{ the name of a directory/folder in which
temporary files (if they are needed) such as images will be
stored. For example, in an HTML or FO/PDF file that includes images,
we can either use SVG an inline the images within the output document,
or we have to store them and refer to them in the second rendering
process (i.e. in the HTML browser or the processing of the FO or
 document).  }\item{dynOpts}{
}\item{\dots}{
a character vector (or named list) giving
name-value pairs which are, by default, used 
as elements of the XSL parameters.
This occurs when no value is given for 
xslParams.


}
\item{force}{ if the target/ouptut file
already exists and is more recent than the input XML file(s), the
function will not bother running the XSL transformation, assuming that
the the request is unnecessary (much like dependencies in the make
utility).  This parameter allows the caller to force the processing
to occur even if the output is more recent than the input.
This is useful when we want to by-pass the computations
to find the dependencies or when we want to perform the
processing with different command-line parameters
on the same file.
}
 \item{invocation}{a string or R expression 
  that gives the command that was used to process and generate the 
  new document. This is typically added to the bottom of the newly generated document
  for readers to consult to determine the origin of the new document.
  }
 \item{.xslParams}{a list of named parameters that are used 
  as XSL variables within the XSL transformation. See the parameter \code{xsltApplyStyleSheet}.
  }
 \item{format}{the desired format of the output document, typically one of
   "HTML", "FO", "PDF", "LaTeX". }
 \item{imageDirectory}{the directory in which the images written to a file should be
  located}
 \item{graphicsDevice}{a list of named elements giving the
   association between the file extensions and a function that creates the corresponding
   graphics device.  The first element is treated as the default graphics device
   for r:plot and similar nodes that do not have an explicit format attribute.
 }
 \item{.errorFun}{the error function to use in the call to
   \code{\link[Sxslt]{xsltApplyStyleSheet}}
}
 \item{verbose}{a logical or integer value
   that controls whether information about the individual steps is written on the console
   as they occur. \code{FALSE} means no information, \code{TRUE} means information about the
   evaluation of the individual code nodes, and a number > 1 gives more
   information.}

    \item{xslFuns}{a collection of R functions that are to be registered as
     XSL functions that can be used within XSL templates.
     These are registered with \code{addXSLTFunctions} in the Sxslt package.}

  \item{stopOnError}{a logical value indicating whether to stop processing the document when an error occurs in any 
   of the code chunks, or to keep going in spite of the error and continue to process subsequent code chunks.}
  \item{workDir}{the name of a directory which is used as the current working directory
   for the duration of this function. This allows us to change the working directory
   relative to which calls to \code{source} and \code{load}  in the dynamic document
   is 
   If this is \code{NA}, we do not changed the working directory.}
 }

\references{
    
    We use \url{http://docbook.sourceforge.net}
    as the basis for the markup vocabulary for the dynamic documents.
    We have extended it to support additional XML  nodes such as r:code, r:plot, r:expr, 
    r:value, r:func, r:arg, etc. for including R code and concepts within the document.
   
  }

\examples{
  
    
         # Process a basic XML file
     # 
     #           This uses a very simple example dynamic document within the 
     #           package.  The code illustrates some of the XSL parameters we can 
     #           specify. We pass XSL parameters via xslParams
     # 	
dynDoc(system.file("examples", "simple.xml", package = "XDynDocs"), "HTML",
        xslParams = c('r:verbose' = 1, showCode = 1, use.existing.data = 1),
         force = TRUE)
	
         # Generating PDF
     # 
     #        Here we  generate FO output and process it into PDF by invoking
     #        Apache's  FOP tool whose location we specify directly via fop.
     #       
dynDoc(system.file("examples", "simple.xml", package = "XDynDocs"), "FO")

      
         # 
if(require(RSvgDevice)) {
            f = system.file("examples", "svg.xml", package = "XDynDocs")
   	    dynDoc(f, "HTML", force = TRUE, graphicsDev = list(svg = devSVG), 'r:verbose' = FALSE)

    	    SVG = devSVG
    	    dynDoc(f, "HTML", force = TRUE, graphicsDev = "SVG", 'r:verbose' = FALSE)
 }


  # Return the document
 dynDoc(system.file("examples", "expandEg.xml", package = "XDynDocs"), "HTML", out = NA)
  
}

\keyword{IO}
