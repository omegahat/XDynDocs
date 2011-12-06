getMessages =
 #  msgs = getMessages("../data/2007-October.txt.gz")
function(file, removeDuplicates = TRUE)
{
  con = gzfile(file)
  on.exit(close(con))
  txt = readLines(con)
  i = grep("^From [a-zA-Z0-9._-]+ at", txt)

  numMessages = length(i)
  pos = c(i, length(txt))
     # take the pairs that mark the start and end and don't do the last one.
  ans = lapply(seq(length = length(pos) - 1),
                function(i) 
                  txt[pos[i]:(pos[i+1] - 1)]       
               )

  names(ans) = gsub("Message-ID: ", "", sapply(ans, function(x) grep("Message-ID: ", x, value = TRUE)))

  if(removeDuplicates)
    removeDuplicateMessages(ans)
  else  
    ans
}

removeDuplicateMessages =
function(msgs)
{
  ids = names(msgs)[duplicated(names(msgs))]

  idx = lapply(ids, getDuplicateIndices, msgs, names(msgs))
  idx = unlist(idx)
  if(length(idx))
    msgs[ - idx ]
  else
    msgs
}

getDuplicateIndices =
function(id, msgs, ids)
{
  idx = which(id == ids)

  orig = msgs[[ idx[1] ]]
  pred = sapply(msgs[idx[-1]], isSameMessage, orig)
  idx[-1][pred]
}


readMessage =
function(txt)
{
  i = which(txt == "")[1]
  header = txt[1:(i-1)]
  body = txt[i:length(txt)]
  list(header = readHeader(header), body = body)
}

readHeader =
function(txt)
{
  con = textConnection(txt)
  on.exit(close(con))
  read.dcf(con)[1,]
}

senders =
  #
  # What about the third component, the person's name. Can we get that reliably.
  #
function(msgs)
{
  sender = sapply(msgs, function(x) x$header["From"])
  tmp = strsplit(gsub("([^ ]+) at ([^ ]+) .*", "\\1,\\2", sender), ",")
  # Check everything is okay
  #     table(sapply(tmp, length))
  matrix(unlist(tmp), , 2, byrow = TRUE)
}
  


isSameMessage =
function(x, y)
{
    # Check if they are  actually equal or only differ by a "" at the end of either.
 ok = is.logical(all.equal(x, y)) ||
          (length(x) == length(y) + 1) && x[length(x)] == "" && is.logical(all.equal(x[-length(x)], y)) ||
             (length(y) == length(x) + 1) && y[length(y)] == "" && is.logical(all.equal(y[-length(y)], x))

 if(ok)
   return(ok)

   # Now handle the case where they are very similar by differ in the URL for the attachment.
 #
 # [7] "An embedded and charset-unspecified text was scrubbed..."                                    
 # [8] "Name: not available"                                                                         
 # [9] "Url: https://stat.ethz.ch/pipermail/r-help/attachments/20060503/43879567/attachment-0002.pl "

 ok = length(x) == length(y) &&
     ( sum( x == y ) == length(x) - 1 ) &&
       substring(x[ length(x) - 1 ], 1, 25) ==  substring(y[ length(y) - 1 ], 1, 25)

 if(ok)
   return(ok)

 x[1] == y[1]
 
}
