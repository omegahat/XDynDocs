# Extract the text within the HTML messages.
#
# Stray > in
#   /home2/duncan/tmp/RSpamData/messages/spam_2/01005.57464e29367579f95dd487c9b15eb196
# message.

getHTMLText =
function(msg)
{
  if(!require(XML))
    stop("You must install the XML package for parsing HTML text.")

   # Create an empty vector that will store the collection
   # of text entries within the HTML document as we encounter
   # them.
  txt = character()

  isText = !file.exists(msg)
  
   # If the text is not inside a <body> ... </body>
   # tag, then enclose it within one ourselves.
  if(isText && length(grep("<body>", msg)) == 0)
    msg = paste("<html><body>", msg, "</body></html>")

   # Create a function within this function that shares the
   # variables (txt, specifically) and which will process only
   # the XMLTextNode elements in the document as we encounter them
   # when parsing the HTML. 
  textHandler = function(x) {
                     # Append to the txt variable in getHTMLText()
                 txt <<- c(txt, xmlValue(x))
                }

    # Now call the parser with these handlers.   
  htmlTreeParse(paste(msg, collapse=" "),
                asText = isText,
                handlers = list(text = textHandler)
               )


  txt
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

