file.copy("Empty.docx", "A.docx", overwrite = TRUE)
#file.copy("Empty1.docx", "A.docx", overwrite = TRUE)
ar = wordDoc("A.docx")

doc = newXMLDoc()
tt = newXMLNode("w:document", namespaceDefinitions = WordXMLNamespaces)
addChildren(doc, tt)
p = newXMLNode("w:p", parent = tt)
r = newXMLNode("w:r", parent = p)
addChildren(r, newXMLNode("w:t",  "Hello world. How are you doing?"))

p = newXMLNode("w:p", parent = tt)
r = newXMLNode("w:r", parent = p)
tbl = asWordTable(table(mtcars[, c("gear", "cyl")]))
addChildren(r, tbl)


p = newXMLNode("w:p", parent = tt)
r = newXMLNode("w:r", newXMLNode("w:rPr", newXMLNode("w:noProof", namespaceDefinitions = WordXMLNamespaces), namespaceDefinitions = WordXMLNamespaces), parent = p)
addImage(ar, "/tmp/foo.pdf", r)
# img = createImageNode("rId20")
# addChildren(r, img)


#updateArchiveFiles(ar, doc)
updateArchiveFiles(ar, doc,  "word/media/foo.pdf" = "/tmp/foo.pdf")

