parseFiles =
function(doc, other, cur)
{
  list(other = xmlParse(paste(other, doc, sep = "/")),
       local = xmlParse(paste(cur, doc, sep = "/")))
}
contentTypes =
function(other = "../Image", cur = ".")
{
  docs = parseFiles("[Content_Types].xml", other, cur)

  f = function(o) {
    defaults = xpathSApply(o, "//x:Default", function(x) structure(xmlGetAttr(x, "ContentType"), names = xmlGetAttr(x, "ContentType")),
                            namespaces = "x")

    overrides = xpathSApply(o, "//x:Override", function(x)structure(xmlGetAttr(x, "ContentType"), names = xmlGetAttr(x, "PartName")),
                             namespaces = "x")
    list(defaults = defaults, overrides = overrides)
  }


  structure(  lapply(docs, f), class = "ContentTypes")
}
compare =
function(els)
   UseMethod("compare")

compare.ContentTypes =
function(els)
{
 compare(list(els[[1]][[1]], els[[2]][[1]]))
 compare(list(els[[1]][[2]], els[[2]][[2]]))
}

compare.list =
function(els)
  
{
  i = intersect( names(els[[1]]), names(els[[2]]))
  if(length(i) != length(els[[1]]))
     print(setdiff(names(els[[1]]), els[[2]]))
  e = els[[1]][ names(els[[2]]) ] == els[[2]]
  if(any(!e))
     print(els[[2]][!e])
}

app =
function(other = "../Image", cur = ".", doc = "docProps/app.xml")
{
  docs = parseFiles(doc, other, cur)
  lapply(docs, function(node) { x = xmlToList(node); unlist(x)})
  #structure(unlist(x), names = names(x))})
}

core =
function(other = "../Image", cur = ".")
{
   app(other, cur, "docProps/core.xml")
}
