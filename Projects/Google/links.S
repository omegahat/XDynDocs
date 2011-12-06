findGoogleSearchLinks = 
#
# called as 
# findGoogleSearchLinks(htmlTreeParse(google("query string")))
#
function(x)
{
  els = doc$children[[1]][["body"]][-(1:7)]
  lapply(els, findXMLNodeLinks)
}


findXMLNodeLinks = 
# Works recursively by descending the
# children. 
function(node) 
{
  if(xmlName(node) == "a")
    return(xmlGetAttr(node, "href"))

   xmlApply(node, findLinks)
}




findLinks = 
#
# Use as 
#   h = findLinks()
#   invisible(htmlTreeParse("url", handlers = h)))
#   h$links()
#
function() 
{
 links = character()
 
 processLink = function(node) {
     links <<- c(links, xmlGetAttr(node, "href"))

     node
 }

 list(links = function() links,
      a = processLink)
}





getDirectLinks =
#
# Different approach to exclude some links.
#
function()
{
 links = character()

 a = function(x) {
   val = xmlValue(x)
   if(!is.null(val) && !(val %in% c("Cached", "Similar pages")))
     links <<- c(links, xmlGetAttr(x, "href"))
 }


 list(links = function() links,
      a = a)
}

