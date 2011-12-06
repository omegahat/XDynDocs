z = readLines("offline")
z = z[ - grep("^#", z) ]

els = strsplit(z, "[;=,]")

fixedNameIndices = c(1, 3, 5, 9)

signals =
  sapply(els, function(x) {
         if(length(x) < 11)
           return(numeric())
         i = seq(11, length(x) - 3,  by = 4)
         structure(as.numeric(x[ i + 1 ]), names = x[i])
       })
