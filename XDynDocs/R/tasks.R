setGeneric("taskNames",
            function(x, ...) {
                standardGeneric("taskNames")
            })

setMethod("taskNames", "character",
           function(x, ...)
                taskNames(xmlParse(x), ...))


if(is.null(getClassDef("AsIs")))
  setOldClass("AsIs")

setMethod("taskNames", "AsIs",
           function(x, ...)
                taskNames(xmlParse(x, asText = TRUE), ...))

setMethod("taskNames", "XMLInternalDocument",
           function(x, ...) {
               xpathSApply(x, "//task", xmlGetAttr, "id")
           })





setGeneric("threadNames",
            function(x, ...) {
                standardGeneric("threadNames")
            })

setMethod("threadNames", "character",
           function(x, ...)
                threadNames(xmlParse(x), ...))


if(is.null(getClassDef("AsIs")))
  setOldClass("AsIs")

setMethod("threadNames", "AsIs",
           function(x, ...)
                threadNames(xmlParse(x, asText = TRUE), ...))

setMethod("threadNames", "XMLInternalDocument",
           function(x, ...) {
               unique(unlist(xpathApply(x, "//altApproach", xmlGetAttr, "thread")))
           })



