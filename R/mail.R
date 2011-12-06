
readArchive =
function(fileName)
{
  library(RSPerl)

  .PerlExpr("use Mail::Box::Mbox;")
  folder = .PerlNew("Mail::Box::Mbox", folder = fileName)
  on.exit(folder$close())

  n = folder$nrMessages()

  msgs = folder$messages()
  
  messages = list(n)
  data = as.data.frame(list(messageId = character(n),
                     subject = character(n),
                     date = integer(n),
                     from = character(n),
                     numLines = integer(n),
                     size = integer(n)
                     numParts = integer(n)
                     ))

  for(i in 1:n) {

    m = msgs[[i]]
    data[i, messageId] = m$messageId()
    data[i, "subject"] = m$subject()
    data[i, "date"] = m$timestamp()
#    data[i, "from"]
    data[i, "numLines"] = m$body()$nrLines()
    data[i, "size"] = m$size()
    data[i, "numParts"] = NA
    
  }
}
