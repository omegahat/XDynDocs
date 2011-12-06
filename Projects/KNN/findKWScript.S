# This script finds the best metric, k and w 
# for the derived emails using 10-fold cross-validation

source("myKNN.S")
load("knnData.rda")


# 
actualClass = derivedEmails[,"isSpam"]


logVars = which(sapply(derivedEmails, is.logical))

conVars = (1:ncol(derivedEmails))[-logVars]
logVars= logVars[-1]

binDist = as.matrix(dist(derivedEmails[, logVars], method = "binary"))


for(i in c("euclidean", "manhattan", "canberra")) {

  print(i)
  conDist = as.matrix(dist(derivedEmails[, conVars], method= i))


# Add names to outKNN elements.
# Array.

  assign(paste("outKNN", i, sep = "."), outKNN <- knnExpt(binDist, conDist, actualClass, w = c(1,5,10,15,20)))

#  save(outKNN,file =paste("outKNN", i, ".rda", sep = ""))
}



# Check to see if it does better using only the variables
# chosen by rpart (and earlier ones)
# Use names.
partVars = c(1,2,3,4,5,6,8,11,12,16,21,23,24,25,27)
partLogVars = c(2,5,12,16,23,24,27)
partConVars = c(3,4,6,8,11,21,25)

binDist = dist(derivedEmails[, partLogVars], method = "binary")
conDist = dist(derivedEmails[, partConVars], method = "canberra")
actualClass = derivedEmails[,1]

binDist=as.matrix(binDist)
conDist=as.matrix(conDist)

partOutKNN = knnExpt(binDist,conDist, actualClass, w=c(1,5,10,15,20))

# Also can change ths input parameters to one of the functions
# to see if the process when get a tie in the neighorhood makes
# a difference.  Thre are three scenarios implemented: break the tie
# with a coin toss, drop the furthest neighbor i.e. use the result
# from k-1, or use the result from k=1.  The k-1 option produces the
# smoothest curve.
# This is a script to make plots of the type I and II errors
# for various values of k (the number of neighbors) and 
# w (the weight used in combining the continuous and discrete
# distance matrices).

source("plotsKW.S")

lineplots(outKNN,w=1:5, type=1:2, ylim=c(0,.5), xlim=c(1,100), color=TRUE, lx = 70, ly=.2)
text(20,0.32,labels="Type II Error",pos=3)
text(10,0.03,labels="Type I Error",pos=3) 

lineplots(outKNN,w=1:5, type=2, ylim=c(0.015,.03), xlim=c(1,15), color=TRUE, lx = 10, ly=.02, ylab="Type I error")

lineplots(outKNN,w=1:5, type=1, ylim=c(0.1,.25), xlim=c(1,15), color=TRUE, lx = 10, ly=.15, ylab="Type II Error")

lineplots(outKNN,w=c(1,3), type=1:2, ylim=c(0.01,.25), xlim=c(1,15), color=TRUE, lx = 10, ly=.1)
abline(v=2,col="grey")
segments(9.5,0.0,9.5,0.021, col="grey")
text(9.5,0.01,labels="2.1%",pos=4)
text(2,0.01,labels="2.2%",pos=4)
text(1.3,0.125,labels="11.1%",pos=1)
text(1.3,0.145,labels="13.1%",pos=1)
text(4.5,0.03,labels="Type I Error",pos=3)
text(6,0.175,labels="Type II Error",pos=3)
