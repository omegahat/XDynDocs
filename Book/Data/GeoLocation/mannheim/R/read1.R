# 
# Here we'll read the offline (or online) data and only 
#  pick out the 6 access points.
#
#
simple =
function(f = "offline", txt = readLines(f, n = n)[-(1:3)], n = -1)
{

  txt = txt[ - grep("^#", txt) ]
  txt = txt[ txt != ""]

  els = strsplit(txt, ";")

    # Better to do the gsub on all the strings in one go rather than per line.
    # 28.3 seconds versus 37.4 seconds.
  uniqueMacs = unique(gsub("(.*)=.*", "\\1", unlist(lapply(els, function(x)  x[-(1:4)]))))

  sapply(els, function(x) {
                  tmp = x[-(1:4)]
                  macs = gsub("(.*)=.*", "\\1", tmp)
                  strsplit(gsub(".*=(.*)", "\\1", tmp), 
                  strsplit()
                 })
}  
