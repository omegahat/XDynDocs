# This is a function for handling the training data and the test data
# for each of our cross validation groups.
doCVSet = function(messages, testIndices, spam) {
                # Get the training data
               trainingMessages = messages[-testIndices]
               trainingSpam = spam[-testIndices]               

                # Compute the bag of words for the training
                # messages and the probabilities for these messages
                # In this case, we want the bag of words to be the entire
                # set from all our regular data, not just this training data. 
                # Alternatively, we just drop words in our test data
                # that aren't in the training data.
               tb = computeFrequencies(trainingMessages, trainingSpam)

               messageProbs = sapply(messages[testIndices], computeMessageProbability,  tb)
               messageProbs + log(sum(trainingSpam) / sum(!trainingSpam))
}
