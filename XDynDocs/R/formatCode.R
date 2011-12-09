formatCode = formatRCode =
function(node, defaultWidth = options()$width, ...)
{
  orig = node
  node = node[[1]]
  wd = xmlGetAttr(node, "r:width", defaultWidth)
  
    # ignore r:output, etc. nodes. Just get the code.
  txt = paste(
          sapply(xmlChildren(node)[xmlSApply(node,
                                              function(x)
                                                any(inherits(x, c("XMLInternalCDataNode", "XMLInternalTextNode"))))],
                                             xmlValue),
          collapse = "\n")

  code = parse(text = txt)
  attr(code, "source") = NULL
  paste(sapply(code, deparse, wd), collapse = "\n")
}
