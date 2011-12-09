# Convert from R to the specified target format, e.g. Dobook, HTML, FO, LaTeX.


  # use toHTML(), toFO(obj, context)
  #  the context provides the instruction as to whether this is an internal or
  # or an R-level

setGeneric("convert", function(from, opts = NULL, target, context = NULL) {
                         standardGeneric("convert")
#      .Call("R_clearNodeMemoryManagement", PACKAGE = "XML")
#                          ans

           })
           
#setAs("ANY", "FO", )
setMethod("convert",
          c("ANY", target = "FOTarget"),
         function(from, opts = NULL, target, context = NULL) {

             doc = NULL
             if(!is.null(context)) {
#                doc = as(context, "XMLInternalDocument")
#                doc = xsltGetOutputDocument(context)
             }
           
             ans = newXMLNode("block", newXMLCDataNode(dumpRObject(from)),
                              namespace = "fo",
                              namespaceDefinitions = NamespaceDefinitions["fo"],
                              doc = doc,
                              attrs = c(hyphenate="false",
                                        'font-family' = "monospace",
                                        'text-align' = "start", 
                                        'wrap-option' = "no-wrap",
                                        'linefeed-treatment' = "preserve",
                                        'white-space-treatment' ="preserve", 
                                       'white-space-collapse' = "false"),
                              manageMemory = FALSE)
             #class(ans) = c("FO", class(ans))
             #ans
             new("FO", ans)
           })

setMethod("convert",
          c("ANY", target = "HTMLTarget"),
#setAs("ANY", "HTML",
      function(from, opts = NULL, target, context = NULL) {
#        ans = newXMLNode("PRE", newXMLCDataNode(dumpRObject(from, "html")), attrs = c("class" = "routput"), manageMemory = FALSE)
        ans = newXMLNode("PRE", dumpRObject(from, "html"), attrs = c("class" = "routput"), manageMemory = FALSE)              
        #class(ans) = c("HTML", class(ans))
        new("HTML", ans)
      })


setMethod("convert",
          c("ANY", target = "LaTeXTarget"),
      function(from, opts = NULL, target, context = NULL) {
       con = textConnection(NULL, 'w', local = TRUE)
       sink(con)
       on.exit(sink())
       print(from)

       if(FALSE) {
        .dynOutput = dumpRObject(from, "html")
        ans = newXMLNode("programlisting", newXMLCDataNode(.dynOutput), attrs = c("class" = "routput"))       
        #class(ans) = c("Docbook", class(ans))
        ans = new("Docbook", ans)
        ans
      }
       paste(textConnectionValue(con), collapse = "\n")
      })


latex.table =
function(from, opts = NULL, target, context = NULL) {
  library(xtable)
  paste(capture.output(print(xtable(from), floating = FALSE)),  collapse = "\n")
}

setMethod("convert", c("lm", target = "LaTeXTarget"),  latex.table)
setMethod("convert", c("anova", target = "LaTeXTarget"),  latex.table)


setOldClass(c("xtable", "data.frame"))

# do we go straight to internal nodes or to HTML text and then parse it.

setMethod("convert",
            c("xtable", target = "HTMLTarget"),
          function(from, opts = NULL, target, context = NULL) {
            digits = if(!is.null(opts)) opts@digits else options()$digits
            attr(from, "digits") = digits
            ans = dumpRObject(from, "html", digits = digits)
            top = xmlRoot(htmlTreeParse(ans, asText = TRUE, useInternal = TRUE))
            while(!inherits(top, "XMLInternalElementNode")) {
              top = XML:::getNextSibling(top)
            }
            top
          })


setAs("xtable", "HTML",
      function(from) {
        convert(from, target = new("HTMLTarget"))
      })

setAs("xtable", "FO",
      function(from) {
        convert(from, target = new("FOTarget"))
      })

setMethod("convert", c("xtable", target = "FOTarget"),
      function(from, opts = NULL, target, context = NULL) {
        digits = if(is.null(opts)) options()$digits else opts@digits
        
        tb = newXMLNode("table", namespace = "fo")
        addChildren(tb,
                    newXMLNode("table-header", namespace = "fo",
                               .children = lapply(attr(from, "row.names"),
                                                  function(h)
                                                    newXMLNode("fo:table-cell",
                                                                newXMLNode("fo:block", formatC(h, digits)),
                                                                attrs = c('text-align' = if(is(h,"numeric")) "right" else "center")))))
        body = newXMLNode("table-body",  namespace = "fo")
        lapply(names(from),
               function(r) {
                  n = newXMLNode("table-row",  namespace = "fo",
                                 .children = sapply(seq(along = from[[r]]),
                                                    function(i) {
                                                       newXMLNode("fo:table-cell",
                                                                  newXMLNode("fo:block",
                                                                             formatC(from[[r]][i], digits),
                                                                             attrs = c('text-align' = if(is(from[[r]][i],"numeric")) "right" else "left")))
                                                   }))
                  addChildren(body, n)
               })
        addChildren(tb, body)

        class(tb) = "FO"
        tb
      })



setAs("xtable", "Docbook",
      function(from) {
        convert(from, target = new("DocbookTarget"))
      })

setMethod("convert", c("xtable", target = "DocbookTarget"),
          function(from, opts = NULL, target, context = NULL) {
            digits = if(is.null(opts)) options()$digits else opts@digits            
            tb = newXMLNode("table")
            addChildren(tb,
                    newXMLNode("thead",
                               newXMLNode("row",
                                          .children = lapply(attr(from, "row.names"),
                                                             function(h)
                                                               newXMLNode("entry", h,
                                                                          attrs = c('align' = if(is(h,"numeric")) "right" else "center"))))))
        body = newXMLNode("tbody")
        lapply(names(from),
               function(r) {
                  n = newXMLNode("row",
                                 .children = sapply(seq(along = from[[r]]),
                                                    function(i) {
                                                       newXMLNode("entry", formatC(from[[r]][i], digits),
                                                                   attrs = c('align' = if(is(from[[r]][i],"numeric")) "right" else "left"))
                                                   }))
                  addChildren(body, n)
               })
        addChildren(tb, body)

        class(tb) = "Docbook"
        tb
      })

