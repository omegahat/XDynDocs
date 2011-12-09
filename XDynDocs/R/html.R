toHTML =
function(obj, node)
{
  UseMethod("toHTML")
}

toHTML.default =
function(obj, node)
{
  lapply(obj, toHTML, node)
}  


toHTML.function =
function(obj, node, name = NA)
{
 tt = xmlTree("PRE")

 n = environment(tt$add)$currentNodes[[1]] 
 addChildren(n, "function(")

 indent = "          "
 params = formals(obj)
 for(i in seq(along = params)) {
   v = newXMLNode("a", attrs = c(href = names(params)[i]))
   if(i > 1)
     addChildren(n, indent)
   
   addChildren(v, names(params)[i])
   addChildren(n, v)
   if(length(params[[i]]) > 0 && !(is.name(params[[i]]) && params[[i]] == ""))
      addChildren(n, " = ", toHTML(params[[i]]))

   if(i < length(params))
      addChildren(n, ", ")
 }

 addChildren(n, ")")

if(FALSE) {
 if(length(body(obj)) > 1)
   addChildren(n, "{")

 addChildren(n, "\n") 

 for(i in body(obj))
   addChildren(n, i)

 if(length(body(obj)) > 1)
   addChildren(n, "\n}")
} 

 addChildren(n, toHTML(body(obj)))

 
 tt
}


"toHTML.{" =
function(obj, node)
{
 c("{\n",
     lapply(obj[-1], toHTML),
      "\n}")
}


"toHTML.=" =
function(obj, node)
{
  list(toHTML(obj[[2]]), " = ", toHTML(obj[[3 ]]))
}


toHTML.pairlist =
function(obj, node)
{
 lapply(names(obj),
         function(id) {
#           if(length(obj[[id]] && !(is.name(obj[[id]]))))
#             id
         })
}  

toHTML.xfunction =
  #XXX named to temporarily avoid replacing earlier one.
function(obj, node)
{
  c("function(",
     lapply(obj[-c(1, length(obj) - c(1,2))], toHTML),
     toHTML(obj[[ length(obj) - 1]]),
    ")")
}

toHTML.call =
function(obj, node)
{

  if(FALSE && obj[[1]] == "function")
    return(toHTML.function(obj, node))
  
  n = newXMLNode("a", attrs = c(href = obj[[1]]), as.character(obj[[1]]))
  ans = list(n, "(")
 
  
  argNames = names(obj)
  for(i in seq(2, length = length(obj)-1)) {
    if(length(argNames) && argNames[i] != "")
       ans = c(ans, newXMLNode("a", attrs = c(href = paste(obj[[1]], "#", argNames[i], sep = "")), argNames[i], " = "))
    ans = c(ans,toHTML(obj[[i]]))
    

     if(i < length(obj))
       ans = c(ans, ", ")
  }
  ans = c(ans, ")")

  ans
}



toHTML.if =
function(obj, node)
{
  ans = list("if(", toHTML(obj[[2]]), ")", "\n", toHTML(obj[[3]]))
  if(length(obj) > 3) {
    ans = c(ans, "\n", "else", toHTML(obj[[4]]))
  }

  return(ans)
}

"toHTML.(" =
function(obj, node)
{
  toHTML(obj[[2]])
}




toHTML.logical =
function(obj, node)
{
  as.character(obj)
}

toHTML.numeric =
function(obj, node)
{
  as.character(obj)
}


toHTML.character =
function(obj, node)
{
  dQuote(obj)
}

toHTML.name =
function(obj, node)
{
  as.character(obj)
}
