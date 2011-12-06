library(codetools)
expr = expression({
    source("getMetaClasses.R")
    meta = getMetaClasses(, k)
    z = generateMetaObjectAccessCode(meta)
    writeCode(z$c.code, "native", "../../src/classMeta.cc", includes = c("<QtCore/QtCore>", 
        "<QtGui/QtGui>", "\"RQt.h\""))
    writeCode(z$r.code, "r", "../../R/classMeta.R")
})


h = function(v, w){  cat(class(v), class(w), "\n")}
call = function(e, w){  cat(class(e), class(w), "\n")}
leaf = function(e, w) { cat(class(e), class(w), "\n")}

walker = makeCodeWalker(handler = h) # , call = call, leaf = leaf)
walkCode(expr[[1]], walker)
