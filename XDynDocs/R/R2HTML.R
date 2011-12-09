CSS = c(table = "rtable",
        tr = "rtr",
        td = "rtd",
        th = "rth",
        topRule = "rtopRule")

matrix2HTML =
function(obj, digits = 3, border = FALSE, frame = FALSE, ..., doc = NULL,
          css = CSS, div = TRUE, manageMemory = TRUE)
{
  tbl = newXMLNode("table", doc = doc, attrs = c(class = as.character(css["table"])), manageMemory = manageMemory)

  if( (is.logical(border) && border) || is(border, "numeric") || is(border, "character") )
    xmlAttrs(tbl)["border"] = if(is(border, "character")) border else as.integer(border)
  if( (is.logical(frame) && frame) || is(border, "numeric") || is(frame, "character") )
    xmlAttrs(tbl)["border"] = if(is(frame, "character")) frame else as.integer(frame)

  
  rnames = rownames(obj)
  
  make.row = function(row, rowName = "", class = css["tr"]) {
               tr = newXMLNode("tr", parent = tbl, attrs = c(class = as.character(class)), manageMemory = manageMemory)
               if(length(rnames))
                  newXMLNode("th", rowName, attrs = c(class = "thRowName"), parent = tr, manageMemory = manageMemory)
                 
               sapply(row, function(x)
                               newXMLNode("td", format(x, digits = digits),
                                           attrs = c(align = ifelse(is(x, "numeric"), "right", "left"),
                                                     class = as.character(css["td"])),
                                           parent = tr, manageMemory = manageMemory))
             }
  
  if(length(dimnames(obj)[[2]])) {
    make.row(colnames(obj), class = "trColNames")
    tr = newXMLNode("tr", newXMLNode("th", newXMLNode("hr", attrs = c(class = as.character(css["topRule"])), manageMemory = manageMemory),
                      attrs = c("colspan" = ncol(obj) + as.integer(length(rnames) > 0)), manageMemory = manageMemory),
                      parent = tbl, manageMemory = manageMemory)
  }

  
  sapply(seq(length = nrow(obj)),
          function(i) {
             make.row(obj[i,], rnames[i])
           })

  if(div)
     newXMLNode("div", tbl, attrs = c(class = "routput"), manageMemory = manageMemory)
  else
     tbl
}  


setMethod("convert", c("data.frame", target = "HTMLTarget"),
           function(from, opts = NULL, target, context = NULL)
             matrix2HTML(from, manageMemory = TRUE))

setMethod("convert", c("matrix", target = "HTMLTarget"),
           function(from, opts = NULL, target, context = NULL)
             matrix2HTML(from))

setMethod("convert", c("array", target = "HTMLTarget"),
           function(from, opts = NULL, target, context = NULL) {
            if(length(dim(from)) == 1)
                from = matrix(from, 1, nrow(from), dimnames = list(character(), rownames(from)))             
            matrix2HTML(from)
           })

#XXX only for two way tables at present and 1 way tables with NULL
#  as the value of  nrow().
setMethod("convert", c("table", target = "HTMLTarget"),
           function(from, opts = NULL, target, context = NULL) {

             if(is.null(nrow(from))) {
               if(length(from) == 0)
                 return(NULL)
               else {
                 return(convert(structure(as.vector(from), names = names(from)), opts, target, context))
               }
             }

             if(length(dim(from)) == 1)
                from = matrix(from, 1, nrow(from), dimnames = list(character(), rownames(from)))
                 
             matrix2HTML(from)
           })
