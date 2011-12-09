#
# Want the HTML, FO, Docbook, Latex etc. to be a 
# fixed field of the dynamic doc context, but
# we also want to dispatch on it. We can make it 
# a field in the representation of the context.
#
# If we have the specific context extend DynamicDocContext
# then any extensions to DynamicDocContext will not be
# inherited. So need to keep these separate.

setClass("DynamicTarget",
          representation(name = "character",
                         outputDirectory = "character"
                        ))

setClass("UnknownTarget", contains = "DynamicTarget",
                          prototype = list(name = "Unknown"))         
setClass("HTMLTarget", contains = "DynamicTarget",
                       prototype = list(name = "HTML"))

setClass("InteractiveHTMLTarget", contains = "HTMLTarget",
                                  prototype = list(name = "InteractiveHTML"))

setClass("FOTarget", contains = "DynamicTarget",
                     prototype = list(name = "FO"))
setClass("DocbookTarget", contains = "DynamicTarget",
                          prototype = list(name = "Docbook"))         
setClass("LaTeXTarget", contains = "DynamicTarget",
                        prototype = list(name = "LaTeX"))

setOldClass(c("XDynDocsEvalEnv", "environment"))

setClass("DynamicDocContext",
         representation(digits = "integer",
                        round = "integer",
                        margins = "numeric",
                        width = "integer",  # of the "screen"/console, not graphics
                        bg = "character",
                        fg = "character",
                        directory = "VirtualDirectory", # where to run the code.
                        plotDirectory = "character", # where to create the plots
                        fontSize = "integer",
                        fontFamily = "character",
                        device = "list",
                        deviceDims = "numeric",  # width and height for graphics device. May want a matrix with a row for different device types.
                        targetFormat = "DynamicTarget",  # the specification of the target.
                        env = "environment",
                        other = "list",
                        name = "character",
                        stopOnError = "logical"
                       ),
         prototype = list(digits = 7L, bg = "white", fg = "black",
                          width = options()$width,
                          deviceDims = c(width = 7, height = 7), #c(width = 400, height = 400),
                          device = list(svg = svg), # list("jpg" = jpeg)
                          stopOnError = FALSE,
                          plotDirectory = "."
                         ))





simpleWarning =
function(message, call = NULL, class = character(), ..., .raise = FALSE)
{
  e = base::simpleWarning(message, call)
  e = append(e, ...)
  class(e) = class(class, class(e))

  if(.raise)
    warning(e)
  e
}


 
setOldClass("XMLInternalNode")
setClass("TargetFormatXMLNode", contains = "XMLInternalNode")

setClass("HTML", contains = "TargetFormatXMLNode")
setClass("FO", contains = "TargetFormatXMLNode")
setClass("Docbook",  contains = "TargetFormatXMLNode")


NamespaceDefinitions =
c( xsl = "http://www.w3.org/1999/XSL/Transform", 
   r = "http://www.r-project.org",
   s = "http://cm.bell-labs.com/stat/S4",
   omg = "http://www.omegahat.org",
   rwx = "http://www.omegahat.org/RwxWidgets",
   make = "http://www.make.org",
   sh = "http://www.shell.org",
   fo = "http://www.w3.org/1999/XSL/Format",
   xi="http://www.w3.org/2003/XInclude"  )



getExtension =
  #
  # target is FO, HTML, html
  #
function(target)
{
   i = match(tolower(target), names(extensions))
   if(is.na(i))
         target
   else
      extensions[i]
}

removeExtension =
function(name)
{
  ext = getExtension(name)
}
#  


# Was xhtml extension, but not for the moment.
# Map fo to pdf extension so that makeTargetFileNames() will return both fo and pdf.
extensions = c("html" = "html", "latex" = "tex", fo = "pdf", db = "xml", docbook = "xml", pdf = "pdf")





######################

.eval = 
function(x, format = "HTML", verbose = TRUE, dir = character(), env = globalenv())
{
     if(missing(env) && exists(".environment", inherits = TRUE)) 
       env = get(".environment")

     node = x
     
     if(inherits(x, "XPathNodeSet") && length(x) == 1)
         x = node = x[[1]]

     if(inherits(x, "XMLInternalNode")) {
       oldOpts = processOptions(x)
       if(length(oldOpts))
         on.exit(options(oldOpts))
     }

     if(inherits(x, "XMLInternalNode"))
        x = xmlValue(x)
     
     expr <- parse(text = x)
     x <- xwithVisible(expr, env) # eval(expr, env)
     viz = x$visible
     if(!viz)
       return(NULL)
     x = x[[1]]

     if(is(node, "XMLInternalNode") && !is.na( digits <- xmlGetAttr(node, "digits", NA, as.integer))) {
        x =  sprintf(sprintf("%%.%df", digits), as.numeric(x))  # round(x, digits)
     }

        # if the value is a scalar that will be returned as a regular value
        # in the XSL nodeset that can be digested by XSL, then leave it as is.
        # otherwise, if it is an atomic vector, return a string with the elements separated by commas
        # Otherwise,  we print the object and return the string representing that. 
        #  We can quite happily convert it to HTML or FO or LaTeX, i.e. the target format. And we could
        #  add an extra argument to that conversion function (convert) to do it inline
        # or separate, i.e. a separate paragraph or as part of a sentence.
     if(is.atomic(x) && !(is(x, "matrix") || is(x, "array"))) {
       if(length(x) == 1) {
         x
       } else
         paste(x, collapse = ", ")
         
     } else {
        con = textConnection("foo", "w", local = TRUE)
        sink(con)
        on.exit({sink(); close(con)})
        print(x)
        sink()
        on.exit(close(con))
        paste(textConnectionValue(con), collapse = "\n")
    }
}

getXSLVerbose =
function(context)
{
  if(is.null(context))
    return(FALSE)
  
  val = getXSLVariables(context, "r:verbose", nsDefs = c(r = "http://www.r-project.org"))[[1]]
  as.integer(val)  # or logical, but here we have levels of verbosity.
}

.evalNode =
  #
  # This is made available to XSL to be called with a nodeset, node or string.
  # Currently, a string is not handled but that is easy to add.
  #
  # This function is typically used by taking a copy of it and setting its
  # environment to an instance-specific
  #
  # When used in closureGenerator, the extra arguments are not really relevant
  #  as the information is in getDynOptions().
  #
  # We need the context so that we can pass this to other functions that might create an XML node
  # and need to be able to access the output XML document.
  #
function(context, x, format = "HTML",
         verbose = XDynDocs:::getXSLVerbose(context),  # need the XDynDocs::: here as we change the environment of this function!
         dir = character(), env = globalenv())
{
        # Avoid nested  r:code references such as in where we include a chunk from
        # somewhere else in the document via <r:code ref=".."/>
     if(length(x) == 0 || xmlName(xmlParent(x[[1]]), TRUE)  %in% c("r:code", "r:plot"))
       return(NULL)

         # determine whether we are showing the output for this node.
         #XXX We should check the URIs, not rely on r:....
     showOutput = xmlGetAttr(x[[1]], "r:output", TRUE, as.logical)

     opts = getDynOptions()

         # Get the environment in which to evaluate the code.
     env = getEvalEnvironment(opts, missing(env), env)
    
     if(inherits(x, "XPathNodeSet") && length(x) == 1)
       x = x[[1]]


     if(length(dir) == 0) {
       if(length(opts@directory)) 
         if(!file.exists(opts@directory))
            warning("directory '", dir, "' does not exist")
         else {
            dir = opts@directory
            if(verbose > 1)
              cat("Setting directory to '", dir, "'\n", sep = "") #, xmlName(x), "\n")
         }
     }

     if(missing(format) && exists("targetFormat", inherits = TRUE)) 
        format = get("targetFormat")

     ############## Deal with the options.

       # original options that we reset.
     oopts = options()
     on.exit({ if(verbose > 1) cat("resetting original options\n"); options(oopts)})

     if(xmlName(x, TRUE) %in% c("r:dynOptions", "options")) {
       processOptions(x)
       on.exit()  # don't reset the options. They persist across nodes.
     }          

     if(xmlName(x, TRUE) %in% c("r:code", "r:plot", "r:function", "r:expr")) 
       processOptions(x)

     addTime = xmlGetAttr(x, "r:time", FALSE, as.logical) # , c(r = "http://www.r-project.org"))

     #*************************************
         # if it is invisible, then just evaluate the code and get out.
     if(xmlName(x) %in% c("r:invisible", "invisible")) {
       #####setOptions(opts)
           # handle CDATA
       #??? What about r:value
       tmp = x[names(x) %in% c("r:code", "r:plot", "r:function", "r:expr")]
       sapply(tmp, evalNode, format = format, verbose = verbose, dir = dir, env = env)
       return(TRUE)
     }

     #***************************
     isPlot = (xmlName(x, full = TRUE) == "r:plot")
if(verbose)  {
  cat(xmlValue(x), "\n")
  cat("isPlot", isPlot, "\n")
}
     closeDevice = TRUE
     if(isPlot) {
         # ??? get format from node.
         # 
       addToCurrent = xmlGetAttr(x, "add", FALSE, as.logical)
if(verbose)       
  cat("addToCurrent =",  addToCurrent, "\n")
 
         # If addToCurrent, then we don't start a new device, but just plot on to any existing device.
       if(!addToCurrent) {
          fmt = xmlGetAttr(x, "r:format", NA)
          if(!is.na(fmt)) {
             if(tolower(fmt) == "svg") {
                if(capabilities()["cairo"])
                   opts@device = list(SVG = svg)
                else {
                   if(!require("RSvgDevice", character.only = TRUE, quietly = TRUE)) 
                       stop("Can't load the RSvgDevice package")

                  opts@device = list(SVG = devSVG)
               }
             } else
                opts@device = structure(list(get(fmt, mode = "function")), names = fmt)
          }

               # Open a new graphics device of the right type in the right directory.
          filename = createGraphicsDevice(x, opts@device, opts@plotDirectory, verbose = verbose, dynOpts = opts)


          if(!xmlGetAttr(x, "append", FALSE, as.logical)) {
            if(verbose)
                cat("Arranging to close device ", dev.cur(), xmlGetAttr(x, "append"), "\n")
            on.exit({if(verbose > 1) cat("closing device", names(filename), "\n") ;  dev.off(filename) }, add = TRUE)
          } else {
cat("Leaving grdevice open", dev.cur(), "\n")
              closeDevice = FALSE
              .openDevices <<- c(.openDevices, dev.cur())
          }
       } else
          filename = structure("", names = "")
     }

     time = NULL

       # get rid of any extraneous nodes such as <r:output>..
       # XXX need to tighten this up as we might want the CDATA nodes, etc.
       #  and also want to handle nested <r:plot> nodes.
     if(TRUE) {
        ans = NULL

            # Have to use a side effect here at present as when we see an r:plot
            # within the r:code node
        txt = character()        
        getCode =
          function(i) {

            if(inherits(i, c("XMLInternalTextNode", "XMLInternalCDataNode")))
               txt <<- c(txt, xmlValue(i))
            else if(xmlName(i, TRUE) == "r:plot") {
              if(length(txt)) {
                 if(verbose)
                   cat("<evalNode>", paste(txt, collapse = "\n"))

                  # Evaluate the current contents an then start over.
                  # XXX what about the print attribute here.

                 expr = parse ( text = paste(txt, collapse = "\n"))
                 ans = try({xwithVisible(expr, env)})  # eval(expr, envir = env)}) ## withVisible(eval(expr, globalenv()))
                 if(inherits(ans, "try-error")) {
                    if(opts@stopOnError)
                           xslError(ans, context = context) # xslStop(context, ans)
                    return(XDynDocs:::RErrorNode(ans, expr, format))
                 }
                   
                 txt <<- character()
                 ans = evalNode(i, format, verbose, dir, env)
             }
           } else if(xmlName(i, TRUE) %in% c("r:code", "r:frag")) {
                ref <-xmlGetAttr(i, "ref", NA)
                if(!is.na(ref)) {
                  doc = xsltGetInputDocument(context)
                  xpath = paste(paste("//r:code[@id='", ref, "']", sep = ""),
                                paste("//r:frag[@id='", ref, "']", sep = ""), sep = "|")

                  nodes = getNodeSet(doc, xpath, c(r = "http://www.r-project.org"))
                  sapply(nodes, function(x)  xmlApply(x, getCode))
                }
           }
          }
        unlist(xmlApply(x, getCode))

        if(length(txt)) {
            otime = proc.time()
            if(verbose) 
               cat("<evalNode> evaluating '", paste(txt, collapse = "\n"), "'\n")

            ex = parse ( text = paste(txt, collapse = "\n"))

               # loop over the expressions and evaluate them separately
               # this way we can get the visibility of the last expression.
            for(i in ex) {
              expr = try(xwithVisible(i, env))  # globalenv())))
              if(inherits(expr, "try-error")) {
                 if(opts@stopOnError)
                      xslError(ans, context = context) # xslStop(context, ans)                
                 return(XDynDocs:::RErrorNode(ans, expr, format))
              }
            }

            if(!isPlot && ! expr$visible )
              return(NULL)
            if(expr$visible)
              expr = expr$value
            else
              expr = NULL # a now show.
            # expr = expr[[ length(expr) ]] # get the value  ? or  the first one ?

#???? why evaluate these again? These are not the expressions anymore but the result!

            if(xmlGetAttr(x, "r:capture.output", FALSE, as.logical)) {
               output = textConnection(NULL, "w", local = TRUE)
               sink(output)
               on.exit(sink(), add = TRUE) #XXXX
#XXXXXXX  ????????           
               eval(expr, envir = env)
               ans = textConnectionValue(output)
            } else {

               ans = try(xwithVisible(expr, env)) # eval(expr, envir = env)
               if(inherits(ans, "try-error")) {
                 if(opts@stopOnError)
                    xslError(ans, context = context) #xslStop(context, ans)                 
                 return(XDynDocs:::RErrorNode(ans, expr, format))
               }
               
               if(!ans$visible)
                 return(NULL)
               else
                 ans = ans[[1]]
            }
            time = structure(proc.time() - otime, class = "proc_time")
         } else {
             xslWarning("No code in node\n", saveXML(x), "\n")
         }
     }

     
       # return either the answer or the filename identifying the graphics device.

     
     if(isPlot) {
       if(inherits(ans, "trellis")) {
           # force the plot to be displayed.
           # Want to check if the plot is already printed.
         print(ans)
       }

       if(FALSE && tolower(names(opts@device)) == "svg") {
            # experiment.
         xsltInsert(context, newXMLNode("iframe", attrs = c(src = names(filename), width = 400, height = 400)))
         NULL
       } else {
             # allow for inlining the SVG directly.
         if(xmlGetAttr(x, "r:inline", FALSE, as.logical)) {
            #XXX what about leaving the device open for subsequent r:plot nodes!
           if(closeDevice) {
               if(verbose > 1) cat("closing device", names(filename), "\n") 
               dev.off(filename); on.exit()
           }
           xmlRoot(xmlInternalTreeParse(names(filename)))
         } else
               # just return the name of the file.
           if(closeDevice) {
              dev.off(filename); on.exit()
            }

              # If the filename has a name that has a name, then that is the
              # name we return as it is the external reference to the file
              # that we want in the document. Otherwise, just return the name of the
              # local file that was created.
    
         if(length(names(names(filename))))
            names(names(filename))
         else if(length(names(filename)))
            names(filename)
         else
            filename
       }
     } else {
       if(format == "" || !xmlGetAttr(x, "showResult", TRUE, as.logical) || !xmlGetAttr(x, "output", TRUE, as.logical)) 
         return(NULL)


         # should this be "InternalFO" rather than just "FO"
         # target format could be created in the closure generator before xsltApplyStyleSheet is invoked.
       opts = getDynOptions()
       if(class(opts@targetFormat) == "DynamicTarget")
          opts@targetFormat = new( paste(format, "Target", sep = "") )

       numLines = xmlGetAttr(x, "numLines", NA, as.integer)
       if(!is.na(numLines)) {
           ans = head(ans, numLines)
       }

       ans = convert(ans, opts, opts@targetFormat, context = context)

       if(!showOutput)
         return(NULL)
         
         # XXX Make the Sxslt code use IS() rather than inherits()
         # Fixed
#       if(is(ans, "XMLInternalNode"))
#         class(ans) = "XMLInternalNode"
       
       if(inherits(ans, "XMLText") )  # tolower(xmlGetAttr(x, "ishtml", NA)) %in% c("true", "yes")) {
          ans = xmlRoot(htmlTreeParse(ans, asText = TRUE, useInternal = TRUE))

       if(addTime && !is.null(time))  {
         XPathNodeSet(ans, convert(time, opts, opts@targetFormat, context = context))
       } else
         ans
       
     }
}  

setGeneric("RErrorNode",
              function(msg, e, target, ...)
                 standardGeneric("RErrorNode"))

setMethod("RErrorNode", c(target = "ANY"),
              function(msg, e, target, ...) {         
                  return(paste("Error in R computation", paste(c(deparse(e), ": ", msg), collapse = "\n")))
               })
        

setGeneric("newVerbatimNode", 
              function(target, ..., inline = FALSE, parent = NULL, doc = NULL, cdata = FALSE) 
                 standardGeneric("newVerbatimNode"))

setMethod("newVerbatimNode", "HTMLTarget",
            function(target, ..., inline = FALSE, parent = NULL, doc = NULL, cdata = FALSE) {
               n = newXMLNode(if(inline) "CODE" else "PRE", parent = parent, doc = doc)
               addChildren(n, ..., cdata = cdata)
               n 
            })
          
setMethod("newVerbatimNode", "FOTarget",
            function(target, ..., inline = FALSE, parent = NULL, doc = NULL, cdata = FALSE) {
              attrs = c(hyphenate="false", 'font-family'="monospace", 'text-align'="start",
                        'wrap-option' = "no-wrap", 'white-space-treatment'="preserve",
                        'white-space-collapse' = "false")
               n = newXMLNode(if(inline) "fo:inline" else "fo:block", 
                              attrs = attrs, parent = parent, doc = doc, 
                              namespaceDefinitions = c(fo="http://www.w3.org/1999/XSL/Format"))
              addChildren(n, ..., cdata = cdata)
              n
            })

evalExpressions =
function(ctxt, node, format)
{

   format = new(paste(toupper(format), "Target", sep = ""))

if(FALSE) {
#<TESTING>
   pre = xsltGetInsertNode(ctxt) #   pre = newVerbatimNode(format)
print(xmlAttrs(pre))
print(xmlAttrs(node[[1]]))
   newXMLNode("i", parent = pre) #XXX this causes the crash.
return(pre)
#</TESTING>
}

   env = .environment
     #XXX Need to discard any r:output or comments nodes.
   exprs =  parse(text = xmlValue(node[[1]]), srcfile = NULL)

   prompt = paste(xmlGetAttr(node[[1]], "r:prompt", 
                                getXSLVariables(ctxt, "r:prompt", nsDefs = c(r = 'http://www.r-project.org'))),
                   " ", sep = "")

   visible = xmlGetAttr(node[[1]], "r:visible", FALSE, as.logical)
      
   pre = xsltGetInsertNode(ctxt) #   pre = newVerbatimNode(format)


   lapply(exprs, function(e) {
                    lang = convert(e, target = format)
                    #  display the prompt
                    n = newVerbatimNode(format, prompt, inline = TRUE, parent = pre, cdata = TRUE) 
                    if(is(format, "HTMLTarget"))
                      xmlAttrs(n)["class"] = "r-prompt"

                    addChildren(pre, kids = xmlChildren(lang)) 
                       # Add something re visibility, e.g. use .Internal(eval.with.vis(expr, env, env))
                    if(!visible) {
                       ans = eval(e, envir = env)
                    } else {
                        ans = .Internal(eval.with.vis(e, env, env))  # use xwithVisible()?
                        if(!ans$visible) {
                          newXMLTextNode("\n", parent = pre)
                          return(NULL)
                        }
                        ans = ans$value
                    }
                    tmp = convert(ans, target = format)
                    if(is.character(tmp))
                      tmp = newXMLTextNode(paste("\n", tmp, "\n", sep = ""), cdata = TRUE)

                    addChildren(pre, tmp)
                 })
#   pre  - the returned node.
  TRUE
}  


setGeneric("dumpRObject",
            function(from, format = "html", ...)
                  standardGeneric("dumpRObject"))

setMethod("dumpRObject", "function",
function(from, format = "html", ...)          
{
  dumpRObject(I(deparse(from)), format, ...)
})

setMethod("dumpRObject", "AsIs",
function(from, format = "html", ...)
{
  ans = paste(from, collapse = "\n")
  class(ans) <- c("HTML", "XML")
  ans
})

setMethod("dumpRObject", "ANY",
function(from, format = "html", ...)          
{
  con = textConnection(NULL, "w", local = TRUE)
  sink(con)
  on.exit({sink(); close(con)})
  print(from, type = tolower(format), ...)
  dumpRObject(I(textConnectionValue(con)))
})


generateFileName =
function(node, dir = character(), ext = character())
{
  ans =
   if(require(digest))
       digest(xmlValue(node))
    else
       tempfile()

   ans = paste(ans, ext, sep = ".")

   
   extName = if(length(names(dir)))
                  sprintf("%s/%s", names(dir), ans)
             else
                NULL

# Fix up if dir = character() 
   structure(paste(dir, basename(ans), sep = .Platform$file.sep),
              names = extName)
}


createGraphicsDevice =
  #
  # Create a graphics device for a pending plot
  # and return index of the current device with the name of the file.
  #
  # node: an XMLInternalNode or XMLNode object giving all the details about
  #   the specification of the device, e.g. the width and height, background, etc.
  #
  # dev: a list with a name giving the extension and a function
  #   used to create the graphics device. It will be called with the
  #   filename, width and height and a background specification.
  #
  # dir: the name of the directory in which the images will be written.
function(node, dev = c(jpg = jpeg), dir = character(), verbose = FALSE, dynOpts)
{

         # generate the name of the file to hold the graphic.
         # Use a user-specified one in the node if it is there.
         # Otherwise, make up a name.
      filename = xmlGetAttr(node, "file",
                                    generateFileName(node, dir, names(dev)))

         # deal with the extension if there was a file.
      ext = gsub("^.*\\.(.{,3})$", "\\1", filename)
      if(ext == filename) {
        ext = names(dev)[1]
        filename = structure(paste(filename, ext, sep = "."), names = names(filename))
      }

         # put the dir name on the file name if necessary.
      if(FALSE && length(dir) && length(grep("^/", filename)) == 0)
        filename = paste(dir, filename, sep = .Platform$file.sep)

      gdims = dynOpts@deviceDims

      if(is.matrix(gdims)) {
         gdims = gdims[ext, ]
      }
      
      w = xmlGetAttr(node, "r:width", gdims[1], as.integer)
      h = xmlGetAttr(node, "r:height", gdims[2], as.integer)
      bg = xmlGetAttr(node, "r:background", "white")

      if(verbose)
        cat("Creating", filename, ", width =", w, ", height =", h, "\n")
      dev[[1]](filename, w, h, bg = bg) 


#      names(filename) = names(dir)
      
      structure(dev.cur(), names = filename)
}


graphicsEval =
  #
  # Tidy up and then just use evalNode directly.
  #
  #  Should use targetFormat from the dynamic options.
  #
function(context, node, dir = character(), targetFormat = "HTML", env = globalenv())
{
     # get the output directory from the options.
  if(missing(env) && exists(".environment", inherits = TRUE)) 
       env = get(".environment")

  evalNode(context, node, targetFormat, dir = dir, env = env)
}  
graphicsEval = xsltContextFunction(graphicsEval)




setGeneric("setDynDocValues",
           function(node, target, type, ...) {
             standardGeneric("setDynDocValues")
           })

tmp =
function(node, target, type, ...) {
  ats = xmlAttrs(node)
  slots = getSlots(class(target))
  for(i in names(ats)) {
    if(i %in% names(slots))
      slot(target, i) <- as(ats[i], slots[i])
  }
  target
}  

#XXX setMethod("setDynDocValues", c("XMLNodeRef", "DynamicDocContext", "ANY"), tmp)
setMethod("setDynDocValues", c("XMLInternalElementNode", "DynamicDocContext", "ANY"), tmp)

             
####################

 # map of the names of the relevant stylesheet files indexed by the target type.
DynamicStyleSheets =
  c(fo = "dynRFO.xsl",
    html = "html.xsl",
    latex = "db2latex.xsl",
    tex = "db2latex.xsl",    
    db = "dynDocbook.xsl",
    docbook = "dynDocbook.xsl"
    )

XSLStyleSheetParams =
  list(fo = list(title.margin.left = "'0pt'", body.start.indent = "'0pt'", start.indent = "'0pt'", body.font.master = 11),
          # Can't use catalogResolve here as this would be resolved at installation time, not run time.
       html = list(html.stylesheet = "http://www.omegahat.org/XDynDocs/XSL/../CSS/DynDocs.css",
                   yahoo.tab.utils.js = "http://www.omegahat.org/XDynDocs/XSL/../JavaScript/yahooTabUtils.js",
                   toggle.hidden.js = "http://www.omegahat.org/XDynDocs/XSL/../JavaScript/toggleHidden.js")
       )

getStyleSheet =
function(target)
{

  i = pmatch(tolower(target) , names(DynamicStyleSheets))
  if(is.na(i)) {
    stop("can't resolve")
  }

#  paste(system.file("XSL", package = "XDynDocs"), DynamicStyleSheets[i], sep = .Platform$file.sep)
   paste("http://www.omegahat.org/XDynDocs/XSL", DynamicStyleSheets[i],  sep = .Platform$file.sep)
}

getStyleSheetParams =
function(target, ...)
{
  i = pmatch(tolower(target) , names(XSLStyleSheetParams))
  if(is.na(i)) 
    return(character())

  ans = XSLStyleSheetParams[[i]]

  els = unlist(list(...))
  if(length(els)) 
     ans[names(els)] = els

  i = match(c("html.stylesheet", "yahoo.tab.utils.js", "toggle.hidden.js"), names(ans))
  if(any(!is.na(i)))
    ans[i[!is.na(i)]] = sapply(ans[i[!is.na(i)]], function(x) dQuote(catalogResolve(x, asIs = TRUE)))
  
  ans
}



dynDoc =
  #
  # Specifying the device.
  # testFO(doc = "~/Projects/org/omegahat/R/RTiming/tests/buffer.xml", createDoc = TRUE, device = list(png = png))
  #
  #  SVG device works in inches, we work in pixels (at present)
  #   so 
  # testFO(doc = "~/Projects/org/omegahat/R/RTiming/tests/buffer.xml", createDoc = TRUE,
  #             device = list(svg = function(file, w, h, ...) devSVG(file, w/96, h/96, ...)))  
  #
  
function(doc,
         target = "FO",
         xsl = getStyleSheet(target),
         out = paste(directory, gsub("(xml|Rdb)$", getExtension(tolower(target)), basename(doc)), sep = .Platform$file.sep),
         preXSL = "http://www.omegahat.org/XSL/docbook/expandDB.xsl",
         postXSL = character(),
         fop = FopExec, # where is the fop executable
         xslParams = getStyleSheetParams(target), 
         fopArgs = character(),
         env = dynDocsEnv(),  # use globalenv as parent, not one from XDynDocs.
         directory = if(missing(out) || all(is.na(out)))
                        dirname(if(is.character(doc)) doc else docName(doc)) # "."
                     else
                        dirname(out[1]),
         imageDirectory = if(!is.na(workDir)) "." else directory,
         graphicsDevice =  list(svg = svg), # list("jpg" = jpeg), 
         dynOpts = DynamicOptions(target,
                                  width = if(target == "HTML") options()$width else 72,
                                  directory = if(!is.na(workDir)) "." else directory,
                                  device = graphicsDevice,
                                  stopOnError = stopOnError,
                                  env = env), # ?? ... was here, now in xslParams
         ..., force = FALSE,
         invocation = paste(deparse(sys.call(), if(target == "HTML") 90 else 50), collapse = "\n"),
         .errorFun = XML:::xmlErrorCumulator(), verbose = TRUE,
         stopOnError = FALSE, workDir = getDir(doc))
{
  createDoc = if(is.na(out)) TRUE else NA

  missingOut = missing(out)
  
  if(missing(env) && !missing(dynOpts))
    env = dynOpts@env

 if(verbose)
    cat("Out ->", out, "\n")
  
    # if given a directory for out, create the name of the file within that directory from the name of the input
    # by changing the extension.
  if(!is.na(out) && file.exists(out) && file.info(out)[1, "isdir"]) {
    out = sprintf("%s%s%s.%s",
                    out,
                    .Platform$file.sep,
                    #removeExtension(basename(if(is.character(doc)) doc else docName(doc))),
                    gsub("\\.[^.]+", "", basename(if(is.character(doc)) doc else docName(doc))),
                    getExtension(tolower(target)))
  }

  if(!is.na(out))
     out = makeTargetFileNames(path.expand(out), target)

  if(!is.na(out) && is.character(doc) && any(doc == out)) {
    stop("input file name and output are the same")
  }
  
     # Get the function call used to produce this document and then add it to the XSL parameters
     # so it can be added to the end of the document as the definition of document.
  kall = paste(paste(invocation, collapse = "\n"), if(missing(invocation)) date(), sep = "\n")
  kall = gsub("'", "\\'", kall)
  kall = paste("'", gsub('"', '\\"', kall), "'", sep = "")

  
    # See if we need to process the document again by comparing the modification times
    # of doc and out, if the latter exists.
  if(!force && is.na(createDoc)) {
         # may be given an xml tree and not a character for doc, so check this too.
     if(is.character(doc) && file.exists(doc) && file.exists(out[1])) {
        times = file.info(c(doc, out[1]))[,"mtime"]
        createDoc = times[1] >= times[2]
     }
   }

   xslParams["graphicsFormat"] = dQuote(toupper(names(dynOpts@device)))

   if(!exists("xmlName", env))
     library(XML)

     # If we do have to create the document content, then apply the stylesheet
  if(force || is.na(createDoc) || createDoc )  {
    if(length(preXSL)) {
      for(tt in preXSL)  # could be unique(catalogResolve(preXSL))
         doc = xsltApplyStyleSheet(doc, tt)$doc
    }

    sz = xslDynamicDoc(doc, xsl, imageDir = dQuote(normalizePath(imageDirectory)), ..., invocation = kall,
                       .xslParams = xslParams, dynOpts = dynOpts, env = env, .errorFun = .errorFun, verbose = verbose,
                       workDir = workDir)


    if(length(postXSL)) { 
      for(tt in preXSL)
        sz = xsltApplyStyleSheet(sz$doc, tt)
    }
    
       # if out is NA, then just return the newly created tree.
       # otherwise write to the specified file
    if(all(is.na(out)))
      return(sz)

    saveXML(sz, out[1])    
    if(length(out) == 1 ||
          tolower(target) %in% c("html", "db", "docbook")) # second test probably unnecessary.
      return(out)


      # This is done above now!
     # now if we are going to post-process the generated document to create, e.g. PDF,
     # we have to check how the caller gave us the name of the output file.
     # For instance, if they  gave us the ultimate file name (e.g. .pdf), then we have
     # convert out to the intermediate file name.
  }

  
       # if fop is not NA and is executable, then run fop on out.
  if(target == "FO") {
    if(fop(out, fop, fopArgs))
       out
    else
       out[1]
  } else if(tolower(target) == "text") {
     #runTeX(out)
    out
  } else
     out  #??? is this right?
}



dynLatex =
function(doc,
         out = paste("/tmp", gsub("xml$", tolower("TeX"), basename(doc)), sep = .Platform$file.sep),
         createDoc = NA,
         directory = dirname(out),
         dynOpts = DynamicOptions("LaTeX", directory = directory, ...), # Target needs to be Docbook/LaTeX
         db2latexParams = c(latex.documentclass.article ="english,11pt,fancyvrb", latex.babel.language = "none" , latex.pagestyle = "plain",
                            latex.document.font ="times", ulink.show = "1"),
         ...,
         xsl = "~/db2latex-xsl-0.8pre1/xsl/docbook.xsl")
{
   doc = dynDoc(doc, target = "LaTeX", out = NA, createDoc = createDoc, directory = directory, dynOpts = dynOpts)
   if(is.na(xsl))
     return(doc)

   #temporary
   saveXML(doc$doc, "/tmp/buffer.db2")
   
   latex = xsltApplyStyleSheet(doc$doc, xsl, .params = db2latexParams)
   
   if(!is.na(out))
      saveXML(latex, file = out)
   else
      latex
}

##########################################

# Should the addXSLTFunctions be done within dynPDF.
# Or should we make it a function that can be called by XSL code
#  Then we would know the target type.
# Now done.
##if(FALSE && require(Sxslt))
## addXSLTFunctions(closureGenerator(
##                             evalNode = .evalNode,
##                             processOptions = processOptions,
##                             graphicsEval = graphicsEval,
##                             voidEval = function(node, ...) { evalNode(node, "", ...); TRUE },
##                             setOptions = setDynDocOptions,
##                             .vars = list(convertStack = list(), # could populate with a default object, giving
##                                                                 # values and also the target type.
##                                          getDynOptions = .getDynOption)))


# We want an environment in which the computations will be done
# The parent of this environment should give the functions used by the
# dynamic  processing, e.g. getDynOptions, formatCode, etc.
# 

dynDocsEnv =
function()
{
  structure(new.env(parent = new.env(parent = getNamespace("XDynDocs"))), class = "XDynDocsEvalEnv")
}

defaultXSLFunctions =
  #
  # Note that we populate the convertStack with the dynOpts. So there will be one.
  #
function(format, env = parent.env(dynDocsEnv()), dynOpts = DynamicOptions(format, ...), ...)
{
    # we should have a parent environment of env for our own
    # functions such as load here.

    # We are providing our own version of load() so that the data are loaded
    # into our working environment, not globalenv() or parent.frame()
  ll = function(file) {
    cat("loading ", file, "\n")
         base::load(file, env)
       }

  env$load = ll
  funs = closureGenerator(
                           evalNode = xsltContextFunction(.evalNode),
                           envEval = .eval,
                           evalExpressions = xsltContextFunction(evalExpressions),
                           processOptions = processOptions,
                           dynamicData = xsltContextFunction(dynamicData),
                           graphicsEval = xsltContextFunction(graphicsEval),
                           voidEval = xsltContextFunction(function(ctxt, node, ...) { evalNode(ctxt, node, "", ...); TRUE }),
                           setOptions = setDynDocOptions,
                           popOptions = popDynDocOptions,    
	                   removeVariables = removeVariables,
                           parseEval = function(str){ convert(eval(parse(text = str), env = .environment), target = getDynOptions()@targetFormat)},
                           closeDevices = function() {
                                              sapply(rev(.openDevices), dev.off)
                                          },
                           formatCode = function(node)
                                          XDynDocs:::formatCode(node, getDynOptions()@width),
                           .vars = list(convertStack = list(dynOpts), # could populate with a default object, giving
                                                                      # values and also the target type.
                                        getDynOptions = .getDynOption,
                                        targetFormat = format,
                                        .environment = env,
                                        .openDevices = integer()
                                       ), .env = env)
  funs
}


setGeneric('getDir', function(x, ...)
                      standardGeneric('getDir'))

setMethod('getDir', 'character',
            function(x, ...) {
               uri = parseURI(x)
               if(uri$scheme %in% c("", "file"))
                  dirname(uri$path)
               else
                  NA
            })

setMethod('getDir', 'AsIs',
            function(x, ...)
              NA)

setMethod('getDir', 'XMLInternalDocument',
            function(x, ...)
              getDir(docName(x)))




xslDynamicDoc =
  #
  #
  #
  #
function(doc, xsl, ..., .xslParams = list(...), format = "FO",
         env = dynDocsEnv(), 
         dynOpts = DynamicOptions(format, ...),
         .errorFun = XML:::xmlErrorCumulator(), verbose = TRUE,
         xslFuns = defaultXSLFunctions(format, env, dynOpts),
         workDir = getDir(doc))
{
  if(is.character(doc)) {
     uri = parseURI(doc)
     if(uri$scheme %in% c("", "file") && !file.exists(uri$path))
        stop("file ", uri$path, "does not exist")
   }

  
  if(FALSE && is.character(workDir) && !is.na(workDir)) {
     orig.dir = getwd()
     on.exit(setwd(orig.dir))
     setwd(workDir)
     if(is.character(doc))
        doc = basename(uri$path)
  }
  
  if(FALSE &&  !missing(.xslParams) && length(list(...))) 
    .xslParams = c(.xslParams, unlist(list(...), recursive = FALSE))

  expr = as(selectMethod("XSLParseEval", "XMLInternalNode"), "function")
  formals(expr)[["env"]] = env

    # restore original functions before we added ours.
    # Alternatively, we could just discard the one we add
    # which would preseve any that were registered during the evaluation
    # of this XSL apply. Probably want clean restore of originals.
  origXSLFuncs = getXSLTFunctions()
  on.exit(setXSLTFunctions(origXSLFuncs), add = TRUE)
          

  tmp = addXSLTFunctions(dynDoc = xslFuns)

    # get the current list of open devices so we can close any new ones we leave open.
  alreadyOpen = dev.list()

  if(inherits(.xslParams, "AsIs"))
     .xslParams[["r:verbose"]] = as.integer(verbose)
  
  ans = xsltApplyStyleSheet(doc, xsl, ..., .params = .xslParams, .errorFun = .errorFun)
      # Close any devices we opened during the processing.
  nowOpen = dev.list()
  sapply(nowOpen[!(nowOpen %in% alreadyOpen)], dev.off)


  if(!is.na(ans$status) && ans$status  > 0)
    stop("problem in applying the XSL style sheet to ", if(is.character(doc)) doc else docName(doc))
    # Post process the SVG if that is the format.
  if(format == "HTML")
     ans$doc = postProcessSVG(, ans$doc, character())
  
  ans
}  
         

dynamicData =
  #
  # We want the ctxt so that we can get at the XSL parameters in effect for this run.
  #
  # node is the r:value/r:object/r:data node

  # env comes from the environment for the collection of functions in xslDynamicDoc().
function(ctxt, node, format = "", env = globalenv())
{
   if(missing(env) && exists(".environment", inherits = TRUE)) 
       env = .environment

   if(is(node, "XMLInternalDocument"))
     return(dynamicData(ctxt, getNodeSet(node, "//r:data", NamespaceDefinitions["r"]), format, env))

   if(is(node, "XMLNodeList") || is(node, "XPathNodeSet"))
     return(sapply(node, function(x) dynamicData(ctxt, x, format, env)))

   if(xmlName(node) == "dataArchive")
     return(xmlSApply(node, function(x) dynamicData(ctxt, x, format, env)))   
   
   if(!is(node, "XMLInternalNode"))
     node = node[[1]]

     
   varName = xmlGetAttr(node, "r:id", xmlGetAttr(node, "id", NA))
   type = xmlGetAttr(node, "r:type", "dput")

   if(XDynDocs:::getXSLVerbose(ctxt))
     cat("restoring data" , varName, "\n")

   code = xmlValue(node)
   if(type == "dput"  || type == "dump")
      value = eval(parse( text = code ), env)
   else {
     
   }

   if(!is.na(varName))
      assign(varName, value, env)
   

   if(!missing(format) && format != '') {
      opts = getDynOptions()
      ans = convert(value, opts, target = opts@targetFormat, context = ctxt)
#      if(FALSE && is(ans, "XMLInternalNode"))
#         class(ans) = "XMLInternalNode"

      ans
   } else
      TRUE
}

dynamicData = xsltContextFunction(dynamicData) # put the class on it so that it will be invoked from XSL with the XSLContext object as the first argument.


getTargetFormat =
function(format)
{
  targetClasses = c("fo" = "FOTarget", "html" = "HTMLTarget", db = "DocbookTarget", docbook = "DocbookTarget",
                    latex = "LaTeXTarget", tex = "LaTeXTarget")
  idx = match(tolower(format), names(targetClasses))

  if(is.na(idx))
    stop("Can't match target")

  new(targetClasses[idx])
}  



removeVariables = 
function(node) # , envir = globalenv())
{
  envir = .environment
  kids = xmlChildren(node[[1]])
  vars = if(length(kids) == 1 && is(kids[[1]], "XMLInternalTextNode"))
            strsplit(xmlValue(kids[[1]]), ",")[[1]]
         else
            sapply(kids, xmlValue)

  rm( list = XML:::trim(vars), envir = envir)
  TRUE   # perhaps return whether all were removed, i.e. if they all existed before.
}


evalShell = 
#
#  for evaluating sh:code
#  This allows us to truncate the number of lines of output according to 
#  the attribute @numLines
function(node)
{
  if(!is(node, "XMLInternalNode")) # i.e. a NodeSet
    node = node[[1]]
    
  kids = xmlChildren(node)[ sapply(xmlChildren(node), xmlName) != "output" ]
  cmd = paste(sapply(kids, xmlValue), collapse = "\n")


  ans = system(XML:::trim(cmd), intern = TRUE)
  numLines = xmlGetAttr(node, "numLines", NA, as.integer)
  if(!is.na(numLines) && numLines > 0)
     ans = ans[seq( length = min(length(ans), numLines)) ]

  paste(ans, collapse = "\n")
}
 

xwithVisible =
function(expr, env)
  .Internal(eval.with.vis(expr, env, env))  


  
