FO.ns = c(fo="http://www.w3.org/1999/XSL/Format")

matrix2FO =
function(obj, digits = 3, ..., doc = NULL)
{
  tbl = newXMLNode("fo:table",  namespaceDefinitions = FO.ns, doc = doc)  
 
  rnames = rownames(obj)

  num.cols = ncol(obj) + as.integer(length(rnames) > 0)
  
  make.row = function(row, rowName = "", tag = "fo:table-row")
             {
              
               tr = newXMLNode(tag, parent = if(tag == "fo:table-row") body else tbl)

               if(tag == "fo:table-header")
                 tr = newXMLNode("fo:table-row", attrs = c('border-bottom' = "solid", 'border-color' = 'red', 'border-width' = '2px', color = "green"),
                                    parent = tr)
               
               if(length(rnames)) {
                  o = newXMLNode("fo:table-cell", parent = tr)
                  newXMLNode("fo:block", rowName, attrs = c('text-align' = "right"), parent = o)
               }

                   
               sapply(row, function(x) {
                             tmp = newXMLNode("fo:table-cell",  parent = tr)

                             attrs = if(tag == "fo:table-header")
                                        c('font-weight' = "bold", 'text-align' = 'right', 'border-collapse' = 'collapse', 'border-bottom' = 'solid', 'border-color'= 'red', 'padding' = '6pt')
                                     else
                                        c('text-align' = ifelse(is(x, "numeric"), "right", "left"), color = "red")
                             
                             newXMLNode("fo:block", format(x, digits = digits), attrs = attrs, parent = tmp)
                           })
             }
  
  if(length(colnames(obj))) 
    make.row(colnames(obj), tag = "fo:table-header")

  
  body = newXMLNode("fo:table-body", parent = tbl)  
  sapply(seq(length = nrow(obj)),
          function(i) {
             make.row(obj[i,], rnames[i])
           })

  tbl
}



if(FALSE)
tmp =
  #
  # Where is args defined
  #
function()
{  
  tbl = newXMLNode("fo:table",  namespaceDefinitions = FO.NS)

  bdy = newXMLNode("fo:table-body", parent = tbl)

  row = newXMLNode("fo:table-row", parent = bdy)
    cell = newXMLNode("fo:table-cell", parent = row)
    newXMLNode("fo:block", name, "(", parent = cell)  
  sapply(seq(along = args),
         function(i) {
           row = newXMLNode("fo:table-row", parent = bdy)
           cell = newXMLNode("fo:table-cell", parent = row)
           newXMLNode("fo:block", parent = cell)

           cell = newXMLNode("fo:table-cell", parent = row)
           block = newXMLNode("fo:block", parent = cell)           

           newXMLNode("fo:basic-link", names(args)[i], attrs = c('internal-destination' = names(args)[i],
                                                                 'background-color'="gray"),
                               parent = block)

           if(!is.missing.arg(args[[i]])) {
             newXMLNode("fo:block",
                        " = ", paste(deparse(args[[i]]), collapse = "\n"),
                         attrs = c(hyphenate="false", 'font-family'="monospace", 'text-align'="start",
                                   'wrap-option' = "no-wrap", 'white-space-treatment'="preserve",
                                   'white-space-collapse' = "false"), parent = block) # 'linefeed-treatment'="preserve",
           }
         })

  tbl
}

setMethod("convert", c("data.frame", target = "FOTarget"),
           function(from, opts = NULL, target, context = NULL)
             matrix2FO(from))
