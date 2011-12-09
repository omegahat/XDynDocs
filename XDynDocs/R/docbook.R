docbookVersion =
function(file = catalogResolve("http://docbook.sourceforge.net/release/xsl/current/VERSION"))
{
  doc  = xmlTreeParse(file, useInternal = TRUE)
  xmlValue(doc[["//fm:Version"]])
}

