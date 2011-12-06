createHeader =
function(lines)
{
        # do continuations

   continuations = grep("^[ \t]", lines, extended = TRUE)
   for(i in rev(continuations)) {
     lines[i-1] = paste(lines[i-1], lines[i], sep="\n")
   }

  
h = h[(1:length(lines))[-1*grep("^[ \t]", lines)]]

l = strsplit(h, ":")
header = sapply(l, function(x) paste(x[-1], collapse=":"))
names(header) = sapply(l, function(x) x[1])

return(header)
}
