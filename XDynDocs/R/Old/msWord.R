# Need to update the RSID entries in word/settings.xml when we update
# the archive.

  # Create an object representing the Word document.
setGeneric("processWordDoc",
function(doc, ...)
  standardGeneric("processWordDoc"))

setMethod("processWordDoc", "character",
function(doc, ...)  
{
  if(file.exists(doc)) 
     processWordDoc(wordDoc(doc), ...)
  else 
     processWordDoc(xmlParse(doc), ...)
})

if(!is.null(getClass("WordArchive", TRUE)))
setMethod("processWordDoc", "WordArchive",
function(doc, ...)
{
  processWordDoc(doc[["word/document.xml"]], ...)
})

setMethod("processWordDoc", "XMLInternalDocument",
function(doc, ..., styleNames = list( pPr = c("Rplot", "Rcode", "Rfunction", "Rfunctiondefinition"), rPr = "Rexpr" ))
{
    # We probably want to be smarter about line breaks, e.g. if there is a  w:proofErr, etc.
  codeNodes = getCodeNodes(doc, styleNames)
})

######################################################################

getCodeNodes =
  #
  # Read the document.xml file in the archive and extract the nodes with the 
  # relevant styles
  #
function(doc, styleNames = list( pPr = c("Rplot", "Rcode", "Rfunction", "Rfunctiondefinition"), rPr = "Rexpr" ),
          parse = TRUE, asNodes = FALSE)
{
  givenParsedXML = inherits(doc, "XMLInternalDocument")
  
  if(!inherits(doc, "XMLInternalDocument"))
     doc = as(doc, "WordArchive")

   if(inherits(doc, "WordArchive"))
         # If we are parsing the XML document and returning the nodes, better
         # make certain that we don't allow the document to be garbage collected.
       doc = xmlParse(doc[[getDocument(doc), asXML = FALSE]], addFinalizer = !asNodes)
  
    # Find all the w:pPr nodes that have a style of Rplot or Rcode and then
    # get their parent which is a w:p.
  styleContainer = c(pPr = "pStyle", rPr = "rStyle")
  xpath = sapply(names(styleNames),
                  function(id) {
                   path = paste("./w:", styleContainer[id], "/@w:val", " = ", sQuote(styleNames[[id]]),
                                   collapse = " or ", sep = "")

# " and not(./parent::pPr)"
                   
                   paste("//w:", id, "[", path, "]", if(id == "rPr") "/ancestor::w:r" else "/parent::*", sep = "")
                 })
  xpath = paste(xpath, collapse = "|")

    # For Rexpr nodes, we may have content  spread across multiple nodes because of proofErr w:type='gramStart' nodes.

  codeNodes = getNodeSet(doc, xpath, WordXMLNamespaces)

  codeNodes = codeNodes[ ! sapply(codeNodes, isRexprInRcode, styleNames) ]

      # Find the inline nodes that are not separate paragraphs.
  i = which(sapply(codeNodes, xmlName) == "r")
  if(length(i)) {  
       # Does this deal with the expressions that span multiple elements.?
     w = sapply(i, function(id) (id > 1 && xmlName(codeNodes[[id-1]]) != "r") || !isRexprNode(getSibling(codeNodes[[id]], FALSE), FALSE))
     if(!all(w))
        codeNodes = codeNodes [ - i [ !w ] ]
   }

  if(asNodes)
    return(codeNodes)

  getCode(codeNodes, parse)
}

isRexprInRcode =
  # See if the node is an Rexpr within an Rcode paragraph or a derivative
  # of such a style
function(node, styleNames)  
{
  if(xmlName(node) != "r")
    return(FALSE)

  sib = getSibling(node, FALSE)
  xmlName(sib) == "pPr" && xmlSize(sib) == 2 &&
     all(names(sib) == c("pStyle", "rPr")) &&
          xmlGetAttr(sib[[1]], "val") %in% styleNames$pPr &&
          xmlGetAttr(sib[[2]][[1]], "val") %in% styleNames$rPr
}

getCodeText =
  #
  # Perhaps remove any trailing periods in R expressions that are there by accident.
  #
function(x) {
  if(xmlName(x) == "r")
    return( collapseRexpr(x))
  else if(xmlName(x) == "p") {
    vals =  xpathSApply(x, ".//w:t|.//w:br", function(x) if(xmlName(x) == "br") "\n" else xmlValue(x),
                          namespaces = WordXMLNamespaces)
    paste(c(vals, ""), collapse = "")
  } else {
    vals = xmlSApply(x, xmlValue)
    paste(c(vals, ""), collapse = "\n")
  }
}

getCode =
function(codeNodes, parse = TRUE)
{
  code = sapply(codeNodes, getCodeText)

    # This should x[["pPr"]] [[1]] or x[["rPr"]]
  names(code) = sapply(codeNodes, function(x) xmlGetAttr(x[[1]][[1]], "val"))           
  
  if(!parse)
    return(code)
  
  sapply(code, function(x) parse(text = x))
}



collapseRcode =
function(node)
{
  x = xpathSApply(node, ".//w:t|.//w:br",
                    function(node)
                     if(xmlName(node) == "br")
                       "\n"
                     else
                        xmlValue(node),
                    namespaces = WordXMLNamespaces)
  paste(x, collapse = "")
}

collapseRexpr =
function(node, checkPrevious = FALSE)
{
  if(checkPrevious && isRexprNode(getSibling(node, FALSE)))
    return(character())

  ans = xmlValue(node)
  no = getSibling(node)

  while(!is.null(no) && isRexprNode(no, FALSE)) {
    ans = c(ans, xmlValue(no))
    no = getSibling(no)
  }
  paste(ans[ ans != ""], collapse = "")
}

isRexprNode =
function(node, strict = TRUE)
{
  (!strict && xmlName(node) == "proofErr") ||
   length(getNodeSet(node, "./w:rPr/w:rStyle[@w:val = 'Rexpr']", WordXMLNamespaces)) > 0
}

getPackageRefs =
  #
  # Get the references to all the R/Omegahat packages within this document.
  #
function(doc, ...)
{
  doc = as(doc, "XMLInternalDocument")
  UseMethod("getPackageRefs")
}  

getPackageRefs.XMLInternalDocument =
function(doc, ...)
{
  nodes = getNodeSet(doc, "//w:r[./w:rPr/w:rStyle/@w:val='Rpackage' or ./w:rPr/w:rStyle/@w:val='OmegahatPackage']/parent::*")

  sapply(nodes, xmlValue)
}


getFunctionRefs =
function(doc, ...)
{
  doc = as(doc, "XMLInternalDocument")
  UseMethod("getFunctionRefs")
}  

getFunctionRefs.XMLInternalDocument =
function(doc, ...)
{
  nodes = getNodeSet(doc, "//w:r[./w:rPr/w:rStyle/@w:val='Rfunc']")
  sapply(nodes, xmlValue)
}



if(FALSE) {
  # Start of the building the picture content ourselves.
  n = newXMLNode("w:drawing", namespaceDefinitions = WordXMLNamespaces[c('w', 'wp', 'a', 'pic')])
  g = newXMLNode("a:graphic",  parent = n)
  gd = newXMLNode("a:graphicData",  parent = g, attrs = c(uri = filename))
  newXMLNode("pic:pic")
}




#addChildren(getNodeSet(tbl, ".//w:tr", namespace = WordXMLNamespaces)[[1]][[3]][[2]], createPhrase("some text in a cell")

################################################################################



wordDynDoc =
function(doc, out = paste(dir, "foo.docx", sep = .Platform$file.sep),
          dir = ".", env = new.env(), verbose = TRUE, removeCode = FALSE,
          nodeOp = processWordNode)
{
    # Copy the original document to the target given by out
  file.copy(doc, out, overwrite = TRUE)
  out = as(out, "WordArchive")

   # Note the we grab the XML document here just to make certain
   # that getCodeNodes() doesn't return the nodes and then free
   # the document
  xdoc = out[[ getDocument(out) ]]
  
  nodes = getCodeNodes(xdoc, asNodes = TRUE)
  expr = getCode(nodes)

     # Figure out which styles are descendants of Routput and Routputtable.
     # e.g. Routputnoborder, Rplotoutput.
  out.ids = getRoutputDescendantStyles(out, target = c("Routput", "Routputtable"))

    # Process all of the code nodes.
  mapply(nodeOp, nodes, expr, seq(along = expr),
          MoreArgs = list(env = env, outputStyles = out.ids, dir = tempdir(),
                           verbose = verbose, target = out))

  if(removeCode) {
       #??? parent nodes or the nodes themselves?
    removeNodes(nodes)
  }
  
  invisible(updateArchiveFiles(out, xdoc))  # as(nodes[[1]], "XMLInternalDocument")))
}

if(FALSE) 
processWordNodeWithCache =
function(node, ...)
  {
    if(cacheExists(node)) {
      load(getCacheFile(node), env)
    } else {
      ans = processWordNode(node, ...)
      saveToCacheFile(objs,  node)
      
    }
  }

processWordNode =
function(node, expr, i, targetDoc, outputStyles, dir = dirname(targetDoc), env = new.env(), verbose = TRUE)
{
   isPlot = isPlotNode(node)

     # Determine if the next node is an output node into which
     # we are to put the result.
   haveOutputNode = isNextSiblingRoutput(node, outputStyles)

   if(haveOutputNode)
      nextNode = getSibling(node)
   
   if(isPlot) {

     if(haveOutputNode) {
         # use information from what is there now
       info = getFigureInfo(nextNode, targetDoc)
         # jpeg, pdf, png, ...
       deviceName = strsplit(info$appType, "/")[[1]][2]
       imageFile = paste(dir, basename(info$filename), sep = .Platform$file.sep)
       pdf(imageFile, width = info$dims["width"],  height = info$dims["height"])
     } else {
       imageFile = paste(dir, paste("plot", i, ".pdf", sep = ""), sep = .Platform$file.sep)
       pdf(imageFile)
     }
     if(verbose)
        cat("created PDF file", imageFile, "\n")
     on.exit(dev.off())
   }


   if(verbose)
     print(expr)
   
     # Evaluate the code.
   ans = eval(expr, env)

      # If the user has indicated that they want the output suppressed,
      # by having the next paragraph be of style Remptyoutput, so be it.
      #??? Perhaps use inheritance of styles rather than a single name.
   if(haveOutputNode && getStyleId(nextNode) == "Remptyoutput")
     return(ans)
   
   if(isPlot) {
     dev.off()
     on.exit()
     # cat(imageFile, "\n")
     if(!haveOutputNode)
        addImage(targetDoc, imageFile, sibling = node)
     else
       insertInPicture(imageFile, nextNode, targetDoc, paste("word", info$filename, sep = .Platform$file.sep))
   } else {
       if(!haveOutputNode) {                   
           n = toWordprocessingML(ans)
           addSibling(node, n)
       } else
           insertInTable(ans, nextNode)
   }
   ans
}

insertInPicture =
  #
  # add the new picture to the archive
  #
  #
function(filename, picNode, ar, targetFileName = names(filename))
{
    updateArchiveFiles(ar, .files = structure(list(filename), names = targetFileName))
}

isPlotNode =
  #
  # Determines whether the given code node is for an R plot or a regular code block.
  #
function(node)
{
    length(getNodeSet(node, ".//w:pPr/w:pStyle[@w:val = 'Rplot']", WordXMLNamespaces)) > 0
}



##################################

insertInTable =
#
# If we have a table, can we fill it in with an R object.
#
function(obj, tbl)
{
  r = nrow(obj)

  rowNodes = getNodeSet(tbl, "./w:tr", "w")
  num.format = paste("%.", getOption("digits"), "f", sep = "")
  for(i in seq(length = r)) {
    row = rowNodes[[i]]
    tc = xmlChildren(row)[names(row) == "tc"]
    sapply(seq(along = obj[i,]),
           function(j) {
               # Not just the first w:t, but need to try to shape the
               # R value to this
              text = getNodeSet(tc[[j]], ".//w:t", "w")[[1]]
              val = obj[i,j]
              if(is.numeric(val))
                val = sprintf(num.format, val)
              xmlValue(text) = val
           })

  }
  tbl
}



#####################

#
# The idea is to look at the next after the code node and see if it 
# is a paragraph with a style that "is based on" the Routput style
# either directly on indirectly.
#

isNextSiblingRoutput =
  #
  #
  #
function(node, outputStyleIds)
{
  nextNode = getSibling(node)

  id = getStyleId(nextNode)
  if(length(id) == 0)
    return(FALSE)

  id %in% outputStyleIds
}


getRoutputDescendantStyles =
  #
  # Finds the ids of the styles which are "based on"  Routput
  # We would compute this when we read the document - just once -
  # and then use this to find if the next sibling node after a 
  # code node is an R output node.
  #
function(doc, styles = getStyles(doc, TRUE), target = "Routput")
{
  ss = styles
  ans = target
  while(length(target) > 0 && length(ss)) {
     bon = sapply(ss, function(x) if("basedOn" %in% names(x)) as.character(x$basedOn) else "")
     i = bon %in% target
     w = unique( names(ss)[ i ])
     ans = c(ans, w)
     target = w
  }
  ans
}



setMethod("source", "WordArchive",
  function (file, local = FALSE, echo = verbose, print.eval = echo, 
             verbose = getOption("verbose"), prompt.echo = getOption("prompt"), 
             max.deparse.length = 150, chdir = FALSE, encoding = getOption("encoding"), 
             continue.echo = getOption("continue"), skip.echo = 0, keep.source = getOption("keep.source"))
{
   styles = getRoutputDescendantStyles(file) 
   xdoc = file[[ getDocument(file) ]]
   nodes = getCodeNodes(xdoc, asNodes = TRUE)
   expr = getCode(nodes)

   env = if(is.logical(local))
           if(local) sys.call(sys.nframe()) else globalenv()
         else
           local
   
   invisible(lapply(expr, evalNode, verbose = verbose, env = env))
})

evalNode =
function(expr, env, verbose = FALSE)
{
  if(length(expr) == 0)
    return(NULL)
  
  if(verbose) {
     cat("***** evaluating\n")
     print(expr)
     cat("\n*****\n")     
  }
  eval(expr, env)
}


