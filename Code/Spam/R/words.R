cleanText =
function(x)   {
  tolower(gsub("([[:punct:]]|[0-9]|-{3,})*", " ", x))
}

createMessageWords = 
function(x) {
 if(is.null(x))
  return(character())

 x = unique(unlist(strsplit(cleanText(x), "[ \t]+")))

 x[x != ""]
}


computeFrequencies =
  #
  # Create a matrix with
  #   the number of messages that contain a word for both the spam and HAM collections.
  #   then convert these to probabilities
  #   then compute the log odds and log(1 - odds).
  #
function(messagesWords, spam, bow = unique(unlist(messagesWords)))
{
  # make this .5 as the entry to avoid the 0 problem.
  spamCounts = matrix(0, 4, length(bow), dimnames = list(c("spam", "not spam", "present-log-odds", "absent-log-odds"), bow))

   # For each of the SPAM messages, add 1 to each of the words in the message
  sapply(messagesWords[spam], function(x)  spamCounts[1, x] <<-  spamCounts[1, x] + 1)
   # And similarly for HAM messages.
  sapply(messagesWords[!spam], function(x)  spamCounts[2, x] <<-  spamCounts[2, x] + 1)

   # Now get the proportions.
   numSpam = sum(spam)
   numHam = length(spam) - numSpam

    # Prob(word|spam)
   spamCounts["spam",] = (spamCounts[1,] + .5)/(numSpam + .5)
    # Prob(word | ham)
   spamCounts["not spam",] = (spamCounts[2,] + .5)/(numHam + .5)
  

      # log(spamCounts[1,]/spamCounts[2,])
   spamCounts["present-log-odds",] = log(spamCounts[1,]) - log(spamCounts[2,]) 
   spamCounts["absent-log-odds",] = log((1 - spamCounts[1,])) - log((1 - spamCounts[2,]))

   spamCounts
}


computeMessageProbability = 
   function(words,  freqTable) {

       # drop any words that are not in the frequency table.
       # Discards words we didn't see in our training data.
      words = words[!is.na(match(words, colnames(freqTable)))]


       #  Find the probabilities of being present for the words that are actually
       #  present in the message, and then find the probabilities of being absent
       #  of the words that aren't present.
       # and take
       #
      present = (colnames(freqTable) %in% words)

       # compute log odds ratio of
       # joint probability a message is spam versus ham.
      ans = sum(freqTable["present-log-odds", present]) + sum(freqTable["absent-log-odds", !present])
      
       # Add the log(P(spam)/P(ham)) = log(# spam/ # ham) in the training data.

      ans
   }



#########################################################
#
#Cross validation

# Break the messages into k groups



#####################################################
# Extracting the text from a full mail message


getTextPart =
function(msg, header)
{
  if(length(header) == 0)
    type = NA
  else
    type = tolower(header["Content-Type"])
  
  txt = character()
  if(!is.na(type)) {
    if(length(grep("html", type)) > 0) {
        txt = c(txt, getHTMLText(msg))
    } else if(length(grep("plain", type))) {
        txt = c(txt, msg)
    }
  } else
    txt = msg

  txt
}

getText =
function(msg)
{
  txt = list()
  if(length(msg$body$attachments) > 0) {
    txt = lapply(msg$body$attachments, function(x) getTextPart(x$text, x$header))
  }
 
  txt[[length(txt) + 1]]  =  getTextPart(msg$body$text, msg$header)

  unlist(txt)
}

# Extract the text within the HTML messages.
#
# Stray > in
#   /home2/duncan/tmp/RSpamData/messages/spam_2/01005.57464e29367579f95dd487c9b15eb196
# message.

getHTMLText =
function(msg)
{
  txt = character()


  if(length(grep("<body>", msg)) == 0)
    msg = paste("<html><body>", msg, "</body></html")
  
  htmlTreeParse(paste(msg, collapse=" "), asText = TRUE,
                handlers = list(text = function(x) {
                                  x = xmlValue(x)
                                  txt <<- c(txt, x)}
               ))


  txt
}



#########################
# Unneeded.

getBagOfWords =
function(msgs, clean = TRUE) 
{
  return(unique(unlist(strsplit(cleanText(unlist(msgs)), "[ \t]+"))))


  # This is slower. We have to recompile the regular expression
  # for each message rather than just once.
  unique(unlist(sapply(msgs, function(x) {
                               if(is.null(x))
                                  return(character(0))
                               if(clean)
                                 x = cleanText(x)
                               strsplit(x, "[ \t]+")
                             })))
}



# Wrong way to do this

getMessageWords =
function(txt)
{
 if(length(txt) == 0)
   return(character(0))

 con = textConnection(gsub("[;,.\"\\.)(:$\\[\\]]", "", txt))
 on.exit(close(con))
 scan(con, what = "")
}  
