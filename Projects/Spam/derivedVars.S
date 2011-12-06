# See HWspamReasons.tex for the groups and variable definitions. 
# Group A 

# Re:....

# Does it have an Re: in the subject.


# Checked.
#----------
# bodyCharacterCount
# percentCapitals
# fromNumericEnd
# isRe.
# percentSubjectBlanks
# numAttachments
# numLinesInBody
# subjectExclamationCount
# replyUnderline
# multipartText


# Deal with this one. Only 194 that aren't working correctly, but need to get this right.
# numRecipients  where do the 0's come  from; @ and , as splitting character.
#
#  There are 191 messages without any listed recipients.
# There are 53 with no information, i.e. "  " or " undisclosed recipients: ;"
#

# timeDifference

countSubjectPattern =
function(msg, pattern = "!")
{
       # Alternatively
       #  substring(a, 1:nchar(a), 1:nchar(a)) == pattern
       ifelse(!("Subject" %in% names(msg$header)), NA,
                   length(grep(pattern, strsplit(msg$header[["Subject"]], "")[[1]])) )
}

VarFuncs = list(
isSpam =
  expression(msg$spam)
,
isRe =
 function(msg) {
   # Can have a Fwd: Re:  ... but we are not allowing this here.
   # We may want to look at In-Reply-To field to see if the message is actually a response.
   # That might be more appropriate.
    "Subject" %in% names(msg$header) && length(grep("^[ \t]*Re:", msg$header[["Subject"]])) > 0
 }
,
numLinesInBody =
  function(msg)
      length(msg$body$text)
,
bodyCharacterCount =
      function(msg)
        sum(nchar(msg$body$text))
,
replyUnderline =
     function(msg) {
       if(!"Reply-To" %in% names(msg$header))
         return(FALSE)

      txt <- msg$header[["Reply-To"]]       
      length(grep("_", txt)) > 0  && length(grep("[0-9A-Za-z]+", txt)) > 0
     }
,
subjectExclamationCount =
     expression(countSubjectPattern(msg))
,  
subjectQuestCount =
     expression(countSubjectPattern(msg, "\\?"))
,
numAttachments =
   # expression(ifelse("attachments" %in % names(msg$body), length(msg$body[["attachments"]], NA)))
   expression(length(msg$body[["attachments"]]))
,
priority =
  function(msg) {
    ans <- FALSE
# Look for names X-Priority, Priority, X-Msmail-Priority
# Look for high any where in the value
    ind = grep("priority", tolower(names(msg$header)))
    if (length(ind) > 0)  ans <- length(grep("high", tolower(msg$header[ind]))) >0

    ans
  }
,
numRecipients =
  function(msg) {
    # unique or not.
    els = getMessageRecipients(msg$header)

    if(length(els) == 0)
      return(NA)

      # Might use , as the split pattern. However
      # This  has to handle Rose, Bobby <brose@med.wayned.edu>
      # and detect this as a single recipient.
      #
      # But using the @ as we do below causes problems with lines like
      #  " \"yyyy-cuteftp@spamassassin.taint.org\" <yyyy-cuteftp@spamassassin.taint.org>"    

     # Split each line by ","  and in each of these elements, look for
     # the @ sign. This handles
    tmp = sapply(strsplit(els, ","), function(x) grep("@", x))
    sum(sapply(tmp, length))
  }
,
percentCapitals =
function(msg)
{
   x = msg$body$text
   if(length(x) == 0 || sum(nchar(x)) == 0)
     return(NA)

   # Avoid pasting toegether for efficiency reasons.
   # x = paste(x, collapse = "\n")
   #
   # Drop all the empty lines and then break each line into
   # characters. Then, construct TRUE/FALSE for each character
   # being in LETTERS and divide by the total number of characters.
   # We could also do this as
   #
   #   sum(nchar(gsub("[[:punct:][:blank:]][A-Z]", "", x)))/sum(nchar(gsub("[[:punct:][:blank:]]", "", x)))
   #
   x = x[x != ""]
   els = strsplit(x, "")
   ans = sum(sapply(els, function(x) sum(x %in% LETTERS)))
   ans/sum(nchar(gsub("[[:punct:][:blank:]]", "", x)))
}
,
isInReplyTo =
function(msg)
{
    "In-Reply-To" %in% names(msg$header) 
}
,
sortedRecipients =
function(msg)
{
  ids = getMessageRecipients(msg$header)
  all(sort(ids) == ids)
}
,
subjectPunctuationCheck =
function(msg)
{
  if("Subject" %in% names(msg$header)) {
    el = gsub("['/.:@-]", "", msg$header["Subject"])
    length(grep("[A-Za-z][[:punct:]]+[A-Za-z]", el)) > 0
    }
   else
     FALSE
},
hourSent =
function(msg)
{
 date = msg$header["Date"] 
# Need to handle that there may be only one digit in the hour 
 locate = regexpr("[0-2]?[0-9]:[0-5][0-9]:[0-5][0-9]", date) 

 if(hour == "")

 if (locate < 0)
     locate = regexpr("[0-2]?[0-9]:[0-5][0-9]", date) 
 if (locate < 0) return(NA)

 hour = as.numeric(substring(date, locate, locate+1))

 locate = regexpr("[+-][0-2][0-9]00", date) 
 if (locate < 0) offset = 0
 else offset = as.numeric(substring(date, locate, locate + 2))
 (hour - offset) %% 24
}
,
multipartText =
function(msg)
{
  numAtt = length(msg$body$attachments) 
  if( numAtt == 0)
    return(FALSE)

  types = getAttachmentTypes(msg)
  length(grep("(html|plain|text/plain)", types)) > (numAtt/2) 
}
,
containsImages =
function(msg)
{
  if(length(msg$body$attachments) == 0)
    return(FALSE)

  types = getAttachmentTypes(msg)

  if(length(types) < 1)
    return(FALSE)
     
 # any(!is.na(match(tolower(types), tolower(MIMEImageTypes))))
  length(grep("^ *image", tolower(types))) > 0 
}
,
isPGPsigned =
function(msg)
{
  if(length(msg$body$attachments) == 0)
    return(FALSE)

  types = getAttachmentTypes(msg)
  length(grep("pgp", tolower(types))) > 0
},
percentHTMLTags =
function(msg)
{
  if(length(msg$body$attachments) == 0)
    return(0)

  types = getAttachmentTypes(msg)
  which = grep("html", types)
  if(length(which) == 0 )
    return(0)

  els = gsub("[[:space:]]", "", msg$body$attachments[[which]]$text)
  totchar = sum(nchar(els))
  totplain = sum(nchar(gsub("<[^<]+>", "", els )))
  (totchar - totplain)/totchar
},
subjectSpamWords =
function(msg)
{
 if("Subject" %in% names(msg$header))
    length(grep(paste(SpamCheckWords, collapse = "|"), tolower(msg$header[["Subject"]]))) > 0
  else
    NA
}  
,
percentSubjectBlanks =
function(msg)
{
  if("Subject" %in% names(msg$header)) {
    x = msg$header[["Subject"]]
    # should we count blank subjects as 0 or 1 or NA? 
    if (nchar(x) == 1) 0
    else 1 - nchar(gsub("[[:blank:]]", "", x))/nchar(x)
  } else
    NA
}
,
messageIdHasNoHostname =
function(msg)
{
   # Or use partial matching.
  idx = pmatch("Message-", names(msg$header))

  if(is.na(idx))
    return(NA)

  tmp = msg$header[[idx]]
  return(length(grep(".*@[^[:space:]]+", tmp)) ==  0)

#  tmp = gsub("[[:space:]]*<.*@(.*)>", "\\1", tmp)
#  if(tmp == tmp)
#      tmp = gsub("[[:space:]]*.*@(.*)", "\\1", tmp)
}
,
fromNumericEnd =
function(msg)
{
  # If we just do a grep("[0-9]@",  )
  # we get matches on messages that have a From something like
  # " \"marty66@aol.com\" <synjan@ecis.com>"
  # and the marty66 is the "user's name" not the login
  # So we can be more precise if we want.
 login = gsub("^.*<", "", msg$header[["From"]])
 login = strsplit(login, "@")[[1]][1]
 length(grep("[0-9]+$", login)) > 0
},
isYelling =
function(msg) 
{
    if ( "Subject" %in% names(msg$header) ) { 
       el = gsub("[^[:alpha:]]", "", msg$header["Subject"])
       if (nchar(el) > 0) nchar(gsub("[A-Z]", "", el)) < 1 
       else FALSE
       }
    else 
     NA
 },
percentForwards =
function(msg)
{
   x = msg$body$text
   if(length(x) == 0 || sum(nchar(x)) == 0)
     return(NA)

#   x = x[x != ""]
   ans = length(grep("^[[:space:]]*>", x)) 
   ans / length(x)
},
isOriginalMessage =
function(msg)
{
   x = msg$body$text
   if(length(x) == 0)
     return(NA)

#   x = gsub("[^[:alpha:]]", "", x) 
#   "originalmessage" %in% tolower(x) 
# The gsub is slow compared to the following
# This missed end of Original Message, and it doesnt find fowarded message

   length(grep("^[^[:alpha:]]*original[^[:alpha:]]+message[^[:alpha:]]*$", tolower(x) ) ) > 0 
},
isDear =
function(msg)
{
   x = msg$body$text
   if(length(x) == 0)
     return(NA)

   length(grep("^[[:blank:]]*dear +(sir|madam)\\>", tolower(x))) > 0 
},
isWrote =
function(msg)
{
   x = msg$body$text
   if(length(x) == 0)
     return(NA)

   length(grep("(wrote|schrieb|ecrit|escribe):", tolower(x) )) > 0 
},
averageWordLength =
function(msg)
{
  txt = msg$body$text
  if(length(txt) == 0 || sum(nchar(txt)) == 0) {
    types = getAttachmentTypes(msg)
    idx = match("plain", types)
    if(!is.na(idx))
      txt = msg$body$attachments[[idx]]$text
    else
      return(NA)
  }

  # So txt is now a character vector.
  txt = gsub("[^[:alpha:]]", " ", txt)
  tmp = unlist(sapply(strsplit(txt, "[[:space:]]+"), nchar) )
  mean(tmp[ tmp > 0 ])
}
,
numDollarSigns=
function(msg)
{
# Have to handle the case that there might be no body, just attachments.
   x = msg$body$text
   if(length(x) == 0 || sum(nchar(x)) == 0)
     return(NA)

#   x = x[x != ""]
   sum(nchar(gsub("[^$]","", x)))
},
hasRedHTMLFont =
function(msg)
{
  types = getAttachmentTypes(msg)
  which = match("html", types)
  if(is.na(which))
    return(FALSE)

  txt = paste(msg$body$attachments[[which]]$text, collapse = "\n")

  ans <- FALSE 
  try(htmlTreeParse(txt, asText = TRUE, isURL = FALSE,
                    handlers = list(font = function(node) {
                                                  col = xmlGetAttr(node, "color")
                                                  if(!is.null(col) && col %in% c("red", "Red", "RED", "#FF0000", "#F00"))
                                                      ans <<- TRUE
                                                  NULL
                                                })))

  return(ans)               
#  grep("<(font|FONT|Font)[^>]color=[^ ]red.*>" 
}
,
hasClickLink =
function(msg)
{
  types = getAttachmentTypes(msg)
  which = match("html", types)
  if(is.na(which))
    return(FALSE)

  txt = paste(msg$body$attachments[[which]]$text, collapse = "\n")

  ans <- FALSE 
  try(htmlTreeParse(txt, asText = TRUE, isURL = FALSE,
                    handlers = list(a = function(node) {
                                      if(!is.null(xmlGetAttr(node, "href"))) {
                                         txt = xmlValue(node)
                                         # If this is NULL, could have an image in the XML node.
                                         if(!is.null(txt) && length(grep("click|push", tolower(txt))) > 0)
                                                ans <<- TRUE
                                      }
                                      NULL
                                    })))

  return(ans)               
}
)

SpamCheckWords =
 c("viagra", "pounds", "free", "weight", "guarantee", "million", "dollars",
    "credit", "risk", "prescription", "generic", "drug", "money back", "credit card")  


MIMEImageTypes =  c("image/jpeg", "image/png")


getAttachmentTypes =
function(msg)
{
  if(length(msg$body$attachments) == 0)
    return(character(0))
  
  sapply(msg$body$attachments,
           function(x) {
             if("Type" %in% names(x$header))
               x$header[["Type"]]
             else if("Content-type" %in% names(x$header)) {
                strsplit(x$header[["Content-type"]], ";")[[1]][1]            
             } else
                ""
           }
         )
}  

getMessageRecipients =
function(header)
{
    c(if("To" %in% names(header))  header[["To"]] else character(0),
      if("Cc" %in% names(header))  header[["Cc"]] else character(0),
      if("Bcc" %in% names(header)) header[["Bcc"]] else character(0)      
     )
}  


createDerivedDataFrame =
function(data = Emails,  operations = VarFuncs, verbose = FALSE)
{  
  els =
   lapply(names(operations),
       function(x) {
          if(verbose)
            print(x)
          
           e = operations[[x]]
           if(is.function(e))
             v = sapply(data, e)
           else
             v = sapply(data, function(msg) eval(e))

#XXX may need this - do for rpart.
#           if(is.logical(v))
#             v = as.factor(v)

           v
       })

   d = as.data.frame(els)
   names(d) <- names(operations)

   invisible(d)
}  

#names(els) <- names(VarFuncs)
if(FALSE) {
sapply(Emails[1:10],
         function(msg) {
            x = lapply(names(VarFuncs), function(x) {
                                        e = VarFuncs[[x]]
                                        if(is.function(e))
                                          e(msg)
                                       else
                                          eval(e)
                                     })

            names(x) <- names(VarFuncs)
            x
         })
}
