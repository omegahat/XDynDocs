
rdb2HTML = xml2HTML =
function(file, style = 'http://www.omegahat.org/XDynDocs/XSL/OmegahatXSL/html/Rhtml.xsl', 
          ..., out = gsub("\\.(Rdb|xml)$", "\\.html", file), .params = XSL_DB_Opts)
{
  doc = xsltApplyStyleSheet(file, style, ..., .params = .params)
  saveXML(doc, out)
  out
}

rdb2PDF = xml2PDF =
function(file, style = 'http://www.omegahat.org/XDynDocs/XSL/OmegahatXSL/fo/Rfo.xsl',
          ..., out = gsub("\\.(Rdb|xml)$", "\\.pdf", file), .params = c(XSL_DB_Opts, XSL_FO_Opts))
{
  doc = xsltApplyStyleSheet(file, style, ..., .params = .params)
  tt = paste(tempfile(), "fo", sep = ".")
  saveXML(doc, tt)
  fop(tt)
  out
}
