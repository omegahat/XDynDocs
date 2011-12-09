library(XML)
doc = xmlParse("inst/nxml-mode/schemas.xml")
nodes = getNodeSet(doc, "//@*[contains(., 'home/duncan')]")
