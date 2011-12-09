library(XDynDocs)
library(XML)
uris = c("http://docbook.sourceforge.net/release/xsl/current/html",
         "http://www.omegahat.org/XSL/",
         "http://www.omegahat.org/XML/Literate/")
ans = sapply(uris, catalogResolve)

# May match other things with a local catalog.
# e.g. on my machine!
length(grep("XDynDocs", ans)) == 3



