# Script to check the kth nearest neighbor routine on a new set of data
# It also compares the classification tree approach to the 
# kth nearest neighbor.

source("myKNN.S")
load("knnData.rda")

# Figure out which variables are logical versus continuous
logVars = vector()
for (i in 1:ncol(derivedEmails)) {
  if (mode(derivedEmails[,i]) == "logical") logVars = c(logVars,i)}
conVars = (1:ncol(derivedEmails))[-logVars]
logVars= logVars[-1]


# Construct the distance matrix from the 
# combined data.

testEmails = rbind(derivedEmails,newEmails)
binDist = dist(testEmails[,logVars],method="binary")
binDist = as.matrix(binDist)
conDist = dist(testEmails[,conVars],method="canberra")
conDist = as.matrix(conDist)
bothDist = (10*binDist) + conDist
remove(binDist,conDist)

# Call subroutines to make the prediction and compute the error
actualClass = testEmails[,1]
knnPreds = knnPredict(bothDist[ -(1:5762), 1:5762],actualClass[1:5762],1,10)
knnCorrect = knnCheck(knnPreds, actualClass[-(1:5762)])
knnErrs = predError(knnCorrect, actualClass[-(1:5762)])

# Here we turn to the classification tree method
# First we build the tree based on the old emails
# then we use the tree to predict spam/ham for the
# new emails.

library(rpart)

formChar =
   paste("isSpam ~", paste(names(derivedEmails[, -1]), collapse=" + "))

logVars = vector()
for (i in 1:ncol(derivedEmails)) {
  if (mode(derivedEmails[,i]) == "logical") logVars = c(logVars,i)}

derDF = derivedEmails
for (i in logVars) {derDF[,i] = as.factor(derivedEmails[,i])}

rpA = rpart(as.formula(formChar), derDF, method="class")

plot(rpA,uniform=TRUE)
text(rpA)

newDF = newEmails
for (i in logVars) {newDF[,i] = as.factor(newEmails[,i])}

predict(rpA, newdata=newDF[,-1], type="class")
newPreds = predict(rpA, newdata=newDF[,-1], type="class")
oldPreds = predict(rpA, newdata=derDF[,-1], type="class")

1- sum(as.logical(oldPreds) & derivedEmails[,1])/sum(derivedEmails[,1])
sum(as.logical(oldPreds) & (!derivedEmails[,1]))/sum(1-derivedEmails[,1])

1-sum(as.logical(newPreds) & (newEmails[,1]))/sum(newEmails[,1])
sum(as.logical(newPreds) & (!newEmails[,1]))/sum(1-newEmails[,1])


whichTI = which(as.logical(newPreds) & (!newEmails[,1]))
whichTII = which((!as.logical(newPreds)) & (newEmails[,1]))

#For analysis of why the new emails are not well predicted
#by either rpart or knn see diffAnn.txt
# plus the following boxplots.

totalEmails = rbind(derivedEmails,newEmails)
attach(totalEmails)
newInd = (1:(5762+750)) > 5762
isSN = (isSpam+1)*2 + newInd
isSN = factor(isSN,labels=c("Old Ham","New Ham","Old Spam", "New Spam"))

boxplot((1+bodyCharacterCount)~isSN,log='y', main="Body Character Count")
boxplot(percentCapitals~isSN,main ="Percent Capital Letters in Subject" )
boxplot(percentSubjectBlanks~isSN, main="Percent of Blanks in Subject")


