# Extract the text from each message as a character vector
# of lines
messageText = lapply(MailAttachments, getText)

# Collapse these lines into words, discarding punctuation
# numbers, etc. and bringing to lower case.
messageWords = lapply(messageText, createMessageWords)

# Compute indicator vector of which messages are spam.
isSpam = sapply(MailAttachments, function(x) x$spam)



# Do the cross validation by applying to each of the k training/test samples
# The result is a list with a vector of probabilities for each of the
# test messages for the CV group.
probs = lapply(1:k, function(i, samples, messageWords, isSpam) {
                       doCVSet(messageWords, samples[, i], isSpam)
                    },
                   samples, messageWords, isSpam)

# Turn this vector into a simple vector of probabilities.
probs = unlist(probs)
# reorder the spam so that it corresponds to the probabilities
# in probs.
isSpam = isSpam[as.vector(samples)]



# order the probs smallest to largest
# and reorder the isSpam also.
#
perm = order(probs)
probs = probs[perm]
isSpam = isSpam[perm]

# now, for each element of probs
# compute the error for thresholding at that level.




