reorderTodo = 
function(fileName) {
   doc = xmlInternalTreeParse(fileName)
   items = getNodeSet(doc, "//topics/topic/items")   
   done = getNodeSet(doc, "//topics/topic/items/item[@topic and @status='done']")
   done = getNodeSet(doc, "//topics/topic/items/item[not(@topic) and @status='done']")   

   addChildren(items[[1]], kids = done)
   doc
}


todoSummary =
function(doc)
{
  if(is.character(doc))
    doc = xmlInternalTreeParse(doc)
  else
    doc =  as(doc, "XMLInternalDocument")
  
  byTopic = table(xpathSApply(doc, "//item", xmlGetAttr, "topic", ""))
    # This is for the ones without a topic
  byStatus = lapply(names(byTopic),
                    function(topic) {
                       xpath = if(topic == "")
                                  "//item[not(@topic)]"
                               else
                                  paste("//item[@topic='", topic, "']", sep = "")
                       table(xpathSApply(doc, xpath, xmlGetAttr, "status", ""))
                    })
  names(byStatus) = names(byTopic)

  list(byTopic = byTopic, byStatus = byStatus)
}
