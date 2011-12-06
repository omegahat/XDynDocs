services =
function() {
ll = readLines("/etc/services")
ll = ll[- grep("^#", ll)]
ll = ll[ll != ""]

ll = gsub("([a-zA-Z0-9]+)\t{1,2}([0-9]+)/(tcp|udp)\t+([a-zA-Z0-9 ]*)\t+# ([a-zA-Z0-9]*)", "\\1,\\2,\\3,\\4,\\5", ll)

els = unlist(strsplit(ll, ","))

matrix(els, length(els), 5, byrow=T, dimnames = list(NULL, c("service", "port", "type", "alias", "description")))
}


services =
function() {
ll = readLines("/etc/services")
ll = ll[- grep("^#", ll)]
ll = ll[ll != ""]

els = strsplit(ll, "\t+")

els = sapply(els, function(x) {
              x = x[1:2]
              x[2] = gsub("([0-9]+)/(tcp|udp)", "\\1", x[2])
              x
            })

matrix(unlist(els), ,2, byrow=TRUE)

els
}


ss =
function()
  {

    ll = readLines("/etc/services")
    ll = ll[- grep("^#", ll)]
    ll = ll[ll != ""]

#    ans = matrix("", length(ll), 4)

    ll = gsub("(tcp|udp|ddp)[ \t].*#", "\\1", ll)
    
    els = lapply(strsplit(ll, "[ \t]+"), function(x) {
                                        x = x[x != ""]

                                        if(length(x) == 4 || (length(x) > 2 && length(grep("^#", x[3])) == 0))
                                          x = x[-3]

                                        x[2] = gsub("([0-9]+)/(tcp|udp|ddp)", "\\1", x[2])

                                        if(length(x) < 3) {
                                          x = c(x, "")
                                        } else
                                          x[3] = substring(x[3], 3)

                                        x
                                     })

   tmp = unlist(els)
   browser()
   a = matrix(tmp, , 3, byrow=TRUE)

   which = match(unique(a[,1]), a[,1])
   a[which,]
  }


servTable =
function(fileName = "port-table") {
    # Read the lines and discard the comments
  ll = readLines(fileName)
  ll = ll[-grep("^#", ll)]
  ll = ll[ll != ""]

   # Process each line breaking it into 4 elements being
   #  service name, port number, protocol type, remainder which is a comment.
   # Some lines will not match this and we will end up happily discarding those.
  tmp = sapply(ll, function(x) {
                   # we ignore lines that have a range in the ports.
                   # e.g.  flex-lm         27000-27009 FLEX LM (1-10)
                gsub("^([-a-zA-Z]*)[ \t]+([0-9]+)(/(tcp|udp|ddp|sctp|tdp))?(.*)$", "\\1,,\\2,,\\4,,\\5", x)
             })


    # Now split each of these into its 4 components. Those that
    # didn't work will split differently.
  e = strsplit(tmp, ",,")

    # Remove the lines that didn't work.
  drop = which(sapply(e, function(x) length(x) != 4))
  e = e[-unique(drop)]


  ans = matrix(unlist(e), , 4, dimnames = list(NULL, c("name", "port", "type", "description")), byrow=TRUE)

  ans[,4] = gsub("^[ \t]+", "", ans[,4], perl = TRUE) 
  ans[ans == ""] <- NA
  
  ans
}


if(FALSE) {
 x = servTable()
 write.table(x, "port.data", sep="\t", na = "\\N", row.names = FALSE, col.names = FALSE)
}
