file.copy("Empty.docx", "A.docx", overwrite = TRUE)
ar = wordDoc("A.docx")

doc = newXMLDoc()
tt = newXMLNode("w:document", namespaceDefinitions = WordXMLNamespaces)
addChildren(doc, tt)

p = newXMLNode("w:p", parent = tt)
r = newXMLNode("w:r", newXMLNode("w:rPr", newXMLNode("w:noProof", namespaceDefinitions = WordXMLNamespaces),
                                 namespaceDefinitions = WordXMLNamespaces), parent = p)
invisible(addImage(ar, "ross.jpeg", r))



