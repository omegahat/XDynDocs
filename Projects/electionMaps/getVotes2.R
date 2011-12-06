library(RCurl)
library(XML)
usaToday = "http://www.usatoday.com/news/politicselections/vote2004/PresidentialByCounty.aspx"
abbr = read.table("CountyVotes04/StateAbbr.txt",header=TRUE)
abbr = as.character(abbr[[1]])
statevotes = list() 

tableHandlers =
function()
{
  countyTable = character(0)
  tableHandler = function(x){
     if (!is.null(xmlValue(x[[1]]))) {
      if (xmlValue(x[[1]]) == "Presidential Results - By County")
             countyTable <<- x
     }
  }

  list(table = tableHandler, .value = function() countyTable)
}


for (i in abbr) {
  html = getForm(usaToday, oi = "P", rti = "G", tf = "l", sp = i)
  tree = htmlTreeParse(html, asTree = FALSE, asText = TRUE, 
               handlers = tableHandlers())$.value()
  n = xmlSize(tree)
  statevotes[[i]] = matrix(nrow = (n-3), ncol = 5)
  countynames = NULL
  for (j in 3:(n-1)) {
      countynames = c(countynames, xmlValue(tree[[j]][[1]]) )
      for (k in 1:5) {
        statevotes[[i]][(j-2), k] = xmlValue(tree[[j]][[k+1]])
      }
   }
   rownames(statevotes[[i]]) = countynames
}
