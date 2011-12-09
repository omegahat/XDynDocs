matrix2DocBook =
   #  Convert a 2 D object (matrix, data frame, table?)

   # We need to get the layout right ourselves as DocBook to FO doesn't do a very good job.
   # FO/FOP doesn't try very hard.  Need to allow people to specify the width.
function(obj, digits = 3, border = FALSE, frame = FALSE, ..., doc = NULL)
{
  tbl = newXMLNode("table", attrs = c('bgcolor' = 'gray'), doc = doc)

  # <?dbfo keep-together="auto" ?>
  newXMLPINode("dbfo", 'keep-together="auto"', parent = tbl)
  
  rnames = rownames(obj)

  tgroup = newXMLNode("tgroup", attrs = c(cols = ncol(obj) + as.integer(length(rnames) > 0)), parent = tbl)
  
  make.row = function(row, rowName = "", parent = body, align = NA) {
               tr = newXMLNode("row", parent = parent)
               if(length(rnames))
                  newXMLNode("entry", rowName, attrs = c(align = "right"), parent = tr)
                 
               sapply(row, function(x) newXMLNode("entry", format(x, digits = digits), attrs = c(align = if(is.na(align)) ifelse(is(x, "numeric"), "right", "left") else align), parent = tr))
             }
  
  if(length(colnames(obj))) {
    make.row(colnames(obj), parent = newXMLNode("thead", parent = tgroup), align = "center")
 #   tr = newXMLNode("table-row", newXMLNode("table-cell", newXMLNode("hr"), attrs = c("colspan" = ncol(obj) + as.integer(length(rnames) > 0))), parent = tbl)
  }

  body = newXMLNode("tbody", parent = tgroup)  
  sapply(seq(length = nrow(obj)),
          function(i) {
             make.row(obj[i,], rnames[i], body)
           })

  tbl
}  



setMethod("convert", c("matrix", target = "DocbookTarget"),
           function(from, opts = NULL, target, context = NULL)
             matrix2DocBook(from) # digits from opts.
          )

setMethod("convert", c("data.frame", target = "DocbookTarget"),
           function(from, opts = NULL, target, context = NULL)
             matrix2DocBook(from) # digits from opts.
          )

setMethod("convert", c("table", target = "DocbookTarget"),
           function(from, opts = NULL, target, context = NULL)
             if(length(dim(from)) == 2)
                matrix2DocBook(from) # digits from opts.
             else
               stop("Don't know how to creat Docbook version of table with dimensions ", paste(dim(from), collapse = ", "))
          )


setMethod("convert", c("ANY", target = "DocbookTarget"),
           function(from, opts = NULL, target, context = NULL) {
  con = textConnection("foo", "w", local = TRUE)
  on.exit(sink)
  sink(con)
  cat("\n", file = con)
  print(from)
  cat("\n", file = con)  
  sink()
  on.exit()
  txt = textConnectionValue(con)
  newXMLNode("programlisting", newXMLTextNode(txt, cdata = TRUE))
})


