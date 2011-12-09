ar = wordDoc("mine.docx")


doc = newXMLDoc()
tt = newXMLNode("w:document", namespaceDefinitions = WordXMLNamespaces)
addChildren(doc, tt)

body = newXMLNode("w:body", parent = tt)
n = toWordprocessingML(mtcars)
invisible(addChildren(body, n))

ar[["word/document.xml"]] = doc



#r = newXMLNode("w:r", newXMLNode("w:rPr", newXMLNode("w:noProof", namespaceDefinitions = WordXMLNamespaces),
#                                 namespaceDefinitions = WordXMLNamespaces), parent = p)
#invisible(addImage(ar, "ross.jpeg", r))
