# Not necessarily relevant here.

setOldClass("XMLNode")

setClass("Demo")

setClass("XMLDemo", representation("Demo", els="list"))

setGeneric("demo", function(topic, package = NULL, lib.loc = NULL, character.only = FALSE, verbose = getOption("verbose"))  standardGeneric("demo"))

setMethod("demo", "XMLNode",
          function(topic, package = NULL, lib.loc = NULL, character.only = FALSE, verbose = getOption("verbose")) {
             d <- new("XMLDemo")
             d@els <- xmlChildren(topic)
             d
          })


setClass("DemoNode", representation(text="character", show = "logical"))
setClass("DemoText", representation("DemoNode"))

xmlDemoText <-
function(x, show = TRUE)
{
  new("DemoText", text = x, show = show)
}

setClass("DemoGraphics", representation("DemoNode"))

xmlDemoGraphics <-
function(x, show = TRUE)
{
  new("DemoGraphics", text = x, show = show)
}

setClass("Pause", representation(interval = "numeric"), prototype = list(interval = Inf))
setClass("Page", representation("Pause"), prototype = list(interval = Inf))


setGeneric("run", function(obj, ...) standardGeneric("run"))

setMethod("run", "Pause", function(obj, ...)
                             if(obj@interval == Inf) {
                                 cat("Hit [Enter] to continue\n")
                                 invisible(readLines(n = 1))
                             } else {
                                 Sys.sleep(obj@interval)
                             })

setMethod("run", "DemoText",
           function(obj) {
               cat(obj@text)
               eval(parse(text = obj@text))
           })






# A directory that doesn't necessarily exist.
setClass("VirtualDirectory", contains = "character")
setClass("Directory", contains = "VirtualDirectory")

setAs("character", "Directory",
       function(from) {
          from = path.expand(from)
          new(if(file.exists(from)) "Directory" else "VirtualDirectory", from)
       })
