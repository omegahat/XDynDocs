readHosts =
function() {  

   rows <- list()
  td = function(x)
         xmlValue(x)
  tr = function(x) {
   if(!is.null(xmlGetAttr(x, "align")))
     return(NULL)

   if(xmlSize(x))
     rows[[length(rows) + 1]] <<- xmlChildren(x)

    NULL
  }

   # http://www.ll.mit.edu/IST/ideval/docs/1998/hosts.html
  htmlTreeParse("hosts.html",
                  handlers = list(tr = tr, td = td, rows = function() rows))
}

reduce =
  #
  #
  #
function(v = readHosts()$rows())
{
  groups = list(Inside=23:length(v), Outside = 4:16, "Router/hub" = 18:21)

  a = unlist(groups)

  ans = matrix(unlist(v[unlist(groups)]),  , 4, byrow=TRUE)

  ids = unlist(sapply(names(groups), function(x) rep(x, length = length(groups[[x]]))))
  
  ans = cbind(ans, ids)

#  ans[ans == a[4,4]] = ""
  ans[ans == " "]  = ""

  colnames(ans) <- c("IP Address", "Hostname", "Operating System", "Notes", "Type")

  ans
}

#
# write.table(reduce(), file="host.data", sep="\t", row.names= FALSE, col.names = FALSE)
