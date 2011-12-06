source("cv.R")
source("cvSample.R")
source("getMessageWords.R")
source("NaiveBayes.R")
source("tauVar.R")
source("plot.R")

library(NaieveBayes)
data(StopWords)

ff = list.files(system.file("messages", package = "NaieveBayes"), full.names = TRUE)
messageWords = lapply(ff, getMessageWords)
names(messageWords) = ff

vfull = NaiveBayes(messageWords = messageWords)
pdf("TypeI-IIErrors.pdf")
errs = plotErrors(vfull[[1]], vfull[[2]], elim=c(.025, .005),
                    widths=c(1,3,3,3), heights = c(2,2,2,1),
                     legendPos = c(-800, .85))
dev.off()

tau = findTau(errs$typeI,  alpha = .01)


pdf("TestSetErrors.pdf"
plotTestSetError(vfull)
dev.off()

pdf("TestSetTaus.pdf")    
plotTestSetError(vfull, c(-50, 0))
dev.off()
    
