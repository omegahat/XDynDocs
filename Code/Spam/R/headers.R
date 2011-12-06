# Recursive attachments, i.e. attachments within attachments.
#  identified by an multipart Content-Type.
#  See the message with 19 attachments.
#  /home2/duncan/tmp/RSpamData/messages/hard_ham/00240.8623673c2a6f2cde10ab31423f708feb

#
# Ensure that when there is no header, it comes back as a character()
# not a list().
#



splitMessage =
function(x, attachments = TRUE, filename = "")
{
 filename = ""

   # If the given string is actually a file name,
   # then read its contents. This is just
   # a convenience to allow us to test this
   # code interactivelyand directly without
   # calling it indirectly via other functions.
 if(length(x) == 1 && file.exists(x)) {
   filename = x
   x = readLines(x)
 }

  # Have to handle any files that aren't actually mesages.
  # Occurs in the actual Spam Assassin corpus.
 if(length(grep("^mv ", x[1]))) {
   warning(paste(filename, "is not a mail message"))
   return(NULL)
 }

  # Get the first empty line.
  el = match("", x) 
  header = processHeader(x[1:(el-1)]) 

  message = x[(el+1):length(x)]
  if(attachments) 
    message = splitBody(message, header = header, filename = filename)

  return(list(header=header, body=message))
}


processHeader =
  #
  # Takes the lines in the header of a message or attachment and
  # brings the continuation lines to their "parent" lines
  # and then breaks these name: value lines into
  # a named vector of values with names given by the {name} vector.
  #
function(h)
{
#XXX
   if(length(h) == 0 || all(h==""))
     return(character(0))

    # Handle the first line by replacing a
    # From at the beginning of the line with
    # X-From: to make it look like the other name: value
    # elements.
   h[1] = gsub("^From", "X-From:", h[1])

    # Now find the continuation lines.
    # We are looking for space or TAB characters in the first
    # character
   continuations = grep("^[ \t]", h, extended = TRUE)
   if(length(continuations) > 0) {
      # So we have continuation lines.
      # Loop over them - backwards - and paste
      # the line to the one before it.
      # When we see two consecutive continuation lines
      # e.g.  To: duncan
      #         bob
      #         jane
      # we will paste "jane" to "bob", and then
      # that new line ("bob jane") to "duncan"
      # and get what we want.
     for(i in rev(continuations)) {
       h[i-1] = paste(h[i-1], h[i], sep="\n")
     }

     # Discard the continuation lines.
     h = h[-1*continuations]
   } 
   

    # Now turn the name: value lines into a named vector
   x = strsplit(h, ":")

    # Put any values that contained : back together again.
   header = sapply(x, function(x) {
       paste(x[-1], collapse=":")
      })
   names(header) = sapply(x, function(x) x[1])

   #XXX
   if(is.list(header) && length(header) == 0)
     header = character()
   
   header
}  


readMessages =
function(files = list.files(pattern = "^[0-9]*\\\.", path = dir, full.names = TRUE),
          dir = ".", isSpam = FALSE, verbose = TRUE, ...)
{
   messages = vector("list", length(files))
   names(messages) = files
   
   for(i in files) {
     if(verbose)
       cat(i, "\n")
     
     messages[[i]] = splitMessage(i, ..., filename = i)
     messages[[i]]$spam = isSpam
   }

   invisible(messages)
}


Directories = c("easy_ham", "easy_ham_2", "hard_ham", "spam", "spam_2")

readAllMessages =
function(dirs = system.file("messages", Directories, package = "RSpamData"),
          verbose = 0, ...)
{
 ans =  vector("list", length(dirs))
 names(ans) = dirs
 
 for(i in dirs) {
   if(as.logical(verbose))
     cat("Directory:" , i, "\n")
   isSpam = (length(grep("spam", i)) > 0)
   ans[[i]] = readMessages(dir = i, verbose = verbose > 1, isSpam = isSpam, ...)
 }

 invisible(unlist(ans, recursive = FALSE))
}  


splitBody = 
#
# Takes a message and its (processed) header
# and returns the message broken into 
# its different attachment elements.
# The input should be in lines, i.e. a character vector
# of the lines in the body
# and the header shoyuld be pre-processed to be a 
# named character vector of entries.
#
function(message,  boundary = NULL, header, filename="") 
{
 if(is.null(boundary)) {
    if("Content-Type" %in% names(header))
      boundary = getBoundary(header["Content-Type"])
 }

 if(is.null(boundary) || is.na(boundary))
   return(list(text = message))

 prefix = paste("--", boundary, sep = "")

 starts = (1:length(message))[!is.na(match(message, prefix))]
 ends  = (1:length(message))[!is.na(match(message, paste(prefix, "--", sep = "")))]

#XXX Need this.
 if(length(starts) == 1 && length(ends) == 0)
     ends = length(message)
 
 pos = sort(c(starts, ends))

 if(length(pos) == 0) {
   warning("Message (", filename, ") with boundary for multipart attachments, but can't find match: ", boundary)
   return(list(text = message))
 }
 
 text = message[ - seq(min(pos), max(pos))]
 
 attachments = list()
 for(i in 1:(length(pos)-1)) {
   which = (pos[i] + 1):(pos[i+1]-1)
   attachments[[i]] = processAttachment(message[ which])
 }

 list(text = text, attachments = attachments)
}

processAttachment =
function(lines)
{
   breakPoint = match("", lines)
   header = lines[1:(breakPoint-1)]

   x = processHeader(header)
   header = sapply(x, function(x) {
                        x = gsub("^[ \t]*(.*)[ \t;]*$", "\\1", x)
#XXX
                        x = gsub(";$", "", x)
                        x
                      }
                  )
#   names(header) = sapply(x, function(x) x[1])

   if("Content-Type" %in% names(header)) {
     tmp = strsplit(header["Content-Type"], "/")[[1]][2]
     header["Type"] = gsub(";.*", "", tmp)
   }
  list(header = header, text = lines[-c(1:breakPoint)])
}

getBoundary =
#
# This extracts the boundary identifier string
# given in the type variable
# that should be obtained from
# the Content-Type entry in the header.
function(type)
{
  if(length(names(type)) > 0 && "Content-Type" %in% names(type) )
     type = type["Content-Type"]
  
  type = gsub("\"", "", type)

  boundary = rep(NA, length(type))
  which = grep(" multipart", type)
  if(length(which)) {
     # allow for space after the = sign
    boundary[which] = gsub(".*boundary= *([^;]*);?.*", "\\1", type[which])
  }

  boundary
}
