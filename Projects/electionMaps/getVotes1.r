library(RCurl)
library(XML)
usaToday = "http://www.usatoday.com/news/politicselections/vote2004/PresidentialByCounty.aspx"
abbr = read.table("CountyVotes04/StateAbbr.txt",header=TRUE)
abbr = as.character(abbr[[1]])
statevotes = list() 

for (i in abbr) {
  html = getForm(usaToday, oi = "P", rti = "G", tf = "l", sp = i)
  USAThtml = paste("CountyVotes04/RawCountUSAToday/", i, ".html", sep = "")
  write(html, file = USAThtml)
  tree = htmlTreeParse(USAThtml, asTree = TRUE)
  tree = tree[["children"]][["html"]][["body"]]
  tree = tree[[1]][[4]][[3]][[3]][[7]][[1]][[6]][[3]][[3]][[1]][[1]]
  n = length(tree)
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
