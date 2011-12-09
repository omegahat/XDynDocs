library(XML)
library(XDocTools)

filename = commandArgs(TRUE)
doc = xmlParse(filename[1])
asIs = xmlGetAttr(xmlRoot(doc), "addPrompt", NA)
if(!is.na(asIs))
  asIs = asIs %in% c("I", "AsIs")

invisible(addCodePrompt(doc, c("R> ", "+"), width.cutoff = 50L, asIs = asIs))
saveXML(doc, filename[2])
