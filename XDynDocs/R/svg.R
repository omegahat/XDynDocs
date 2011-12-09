postProcessSVG =
  #
  # Read the specified document and process each of the 
  # iframe nodes which have an .svg file and set the width
  # and height to be taken from the width and height of the
  # <svg> node in that file.
  #
  # This is also done in html.xsl now and so this is not
  # currently used. Not certain which is faster.
  # Doing this after the entire document is produced also
  # helps because it allows us do some post-processing on the
  # SVG. Still possible after the html.xsl has already adjusted
  # the iframe, but redundant.
  #
function(file, doc = xmlParse(file), out = docName(doc))
{
   toFile = !missing(file)
   iframes = getNodeSet(doc, "//iframe")
   sapply(iframes, setIFrameDim)
   if(toFile && length(out) > 0)
      saveXML(doc, out)
   else
      invisible(doc)
}

setIFrameDim =
function(node)
{
  doc = xmlParse(xmlGetAttr(node, "src"))
  attrs = xmlAttrs(xmlRoot(doc))
  dim = as.integer(gsub("pt$", "", attrs[c("width", "height")]))
  dim = 96/72*dim  # 96 dpi typically (?) on a screen, 72 pts per inch
  
  addAttributes(node, .attrs = structure(dim, names = c("width", "height")))
}
