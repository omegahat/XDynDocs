checkImages =
function(doc)
{
   if(is.character(doc))
      doc = htmlParse(doc)
   src = xpathSApply(doc, "//iframe[@src]|//img[@src]", xmlGetAttr, "src")
   src[!file.exists(src)]
}

renameReferences =
function(doc, to = ".", base = NA,
         xpath = "//iframe[@src]|//img[@src]|//a[@href]|//link[@href]|//script[@src]")
{
   if(is.character(doc))
      doc = htmlParse(doc)
   xpathSApply(doc, xpath,  # Need to handle the <a href> carefully so as not to damage references to external things
                       function(x)
                         renameReference(x, to, base, if(xmlName(x) %in% c("iframe", "img", "script")) "src" else  "href"))
   doc
}


renameReference =
function(node, to, base, at = "src")
{
browser()
   id = xmlGetAttr(node, at, NA)
   if(is.na(id))

      # external references are left as is.
   if(grepl("^(http|ftp)", id))
     return(node)

   id = if(is.na(base))
           basename(id)
        else
           gsub(sprintf("^%s", base), "", id)

   tmp = gsub(sprintf("%s$", .Platform$file.sep), "", c(to, id))

   xmlAttrs(node) = structure(sprintf("%s%s%s", tmp[1], .Platform$file.sep, tmp[2]), names = at)

   node
}


getAllReferences =
function(doc, xpath = c("//img/@src", "//a/@href", "//script/@src", "//iframe/@src", "//link/@href"),
          omitExternal = TRUE)
{
    if(is.character(doc))
      doc =  htmlParse(doc)
    xp = paste(xpath, collapse = "|")
    ans = xpathSApply(doc, xp, as, "character")

    if(omitExternal)
      ans = ans[ ! grepl( "^(http|ftp)", ans) ]

    ans
}

fixSVGDimensions =
function(doc, all = FALSE)
{
   if(is.character(doc))
      doc = htmlParse(doc)

   xp = if(all) "//iframe[@src]" else "//iframe[@src and @width='NaN']"
   xpathApply(doc, xp, fixSVGDim)

   doc
}


fixSVGDim =
function(node, ptToPixelFactor = 1.34)
{
   ats = xmlAttrs(node)
   if(!file.exists(ats["src"])) {
      warning("cannot find ", ats["src"])
      return(node)
   }

   if(FALSE)
      svg = xmlParse(ats["src"])
   else {
       svg = xmlParse(paste(c(readLines(ats["src"], 2), "</svg>"), collapse = ""), asText = TRUE)
   }
   svg.ats = xmlAttrs(xmlRoot(svg))
   dims = as.numeric(gsub("pt", "", svg.ats[c("width", "height")])) * ptToPixelFactor

   xmlAttrs(node) = structure(dims, names = c("width", "height"))
   node
}
