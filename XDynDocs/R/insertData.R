# Put the data in their own archive node at the end of the document (so don't interfere
#  with editing and reading the soure,
#  or better in a separate file that we XInclude 

dputObject =
function(value, id, parent = NULL)
{
  con = textConnection("foo", "w", local = TRUE)
  on.exit(close(con))
  dput(value, con)
  txt = textConnectionValue(con)

  newXMLNode("r:data", paste(txt, collapse = "\n"),
              attrs = c("r:id" = id, "r:type" = "dput"),
               parent = parent)
}

insertData =

  #
  # x = 1:10
  # update = insertData("/tmp/foo.Rdb", x = x, y = mtcars)
  #
  # update = insertData("/tmp/foo.Rdb", x = x, y = mtcars, xinclude = "/tmp/myData.xml")
  # saveXML(update, "/tmp/bar.Rdb")
  # doc = xmlParse("/tmp/bar.Rdb")
  #
  
  
function(doc, ..., objects = list(...), op = dputObject,
          ar = newXMLNode("r:dataArchive",
                           parent = if(is.na(xinclude))
                                      xmlRoot(doc) else NULL,
                           namespaceDefinitions = XDynDocs:::NamespaceDefinitions["r"]),
          multi = FALSE, # do each variable separately. TRUE means use save()
          xinclude = NA  # the name of a file to create with the data and also include in this doc.
         ) 
                         
{
   if(is.character(doc)) 
       doc = xmlParse(doc)

   if(multi) {
      # con = rawConnection(raw(0), "w") ;save(..., file = con) ; library(RCurl); 
      # newXMLNode("r:dataArchive", base64(rawConnectionValue()), CDATA = TRUE)
   } else
     mapply(dputObject, objects, names(objects), MoreArgs = list(parent = ar))

   if(!is.na(xinclude)) {
     saveXML(ar, xinclude)
     newXMLNode("xi:include", attrs = c(href = xinclude), parent = xmlRoot(doc),
                 namespaceDefinitions = XDynDocs:::NamespaceDefinitions["xi"]) 
   }

   invisible(doc)
}
