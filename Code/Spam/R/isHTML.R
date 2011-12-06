
isHTML =
function(m)
{
  if("Content-Type" %in% names(m$header)) {
    return(length(grep("html", tolower(m$header[["Content-Type"]]))) > 0)
  }

  return(FALSE)
}  


getNonHTMLText =
function(x) {
  if(isHTML(x) || length(x$body$attachments) > 0)
    return(NULL)
  
  words = getMessageWords(x$body$text)
  words
}
