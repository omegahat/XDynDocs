classifySpamAssassin = 
function(messages, wordProbs, tau, spamProportion)
{
 library(NaieveBayes)
 data(StopWords)

  # We will collect the vectors of words for each message
  # into a list for use later outside of this function.
 ctr = 1
 messageWords = vector("list", length(messages))

  # Break each message down into its vector of words and
  # compute the log-odds ratio for the message words using
  # the training probabilities (i.e. the ling spam results
  # from computeFrequencies)
  # Ignore messages that are HTML or have attachments.
 logOdds = sapply(messages, function(x) {
                             getNonHTMLText(x)
                               # Put this vector into messageWords.
                             messageWords[[ctr]] <<- words
                             ctr <<- ctr + 1                             

                              # Get the log-odds ratio for these words.
                              # Scale later by log(Pr(spam)/Pr(ham)).
                             computeMessageProbability(words, wordProbs)
                           })

  # Get ready to discard the NA elements coming from HTML or attachments.
 els = which(!is.na(logOdds))

  # Get only the messages with no HTML and no attachments.
 messageWords = messageWords[els]
 names(messageWords) = names(messages)[els]

  # Subset and scale by log(Pr(Spam)/Pr(HAM))
  # from the training set.
 logOdds = logOdds[els] + log(spamProportion)
 
  # Now compute which were actually spam based on
  # the names of the directories of each message.
 actualSpam = rep(FALSE, length(messageWords))
 actualSpam[grep("spam", names(messageWords))] = TRUE


 list("typeI" = typeIErrorRate(tau, logOdds, actualSpam),
      "typeII" = typeIIErrorRate(tau, logOdds, actualSpam),
      numMessages = length(messages),
      whichMessages = els,
      actualSpam = actualSpam,
      messageWords = messageWords,
      logOdds = logOdds
      )  
}  


compare =
function(logOddsLingSpam = computeFrequencies(messageWords, isSpam),
         logOddsSpamAssassin = computeFrequencies(spamAssassinResults$messageWords,
                                           spamAssassinResults$actualSpam))
{
  # Find the words in common
  commonWords = intersect(colnames(logOddsSpamAssassin), colnames(logOddsLingSpam))
  cat("Number of common words", length(commonWords), "\n")

  par(mfrow=c(1, 2))

  plot(logOddsLingSpam["present-log-odds", commonWords],
       logOddsSpamAssassin["present-log-odds", commonWords],
       xlab = "Ling Spam", ylab = "Spam Assassin",
   #    main = "Log-Odds for words present in message"
      )

  plot(logOddsLingSpam["absent-log-odds", commonWords],
       logOddsSpamAssassin["absent-log-odds", commonWords],
       xlab = "Ling Spam", ylab = "Spam Assassin",
   #    main = "Log-Odds for words absent in message"
      )       

invisible(list(logOddsLingSpam = logOddsLingSpam,
               logOddsSpamAssassin = logOddsSpamAssassin,
               commonWords = commonWords))
}
