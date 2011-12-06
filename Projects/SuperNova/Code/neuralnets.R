nova <- read.csv("nova.csv")
nova[, -1] <- scale(nova[, -1])


#Split into training and test sets
set.seed(19848492)
test.samp <- c(sample(5000, size = 500), 5000 + sample(5000, size = 500))
nova.train <- nova[-test.samp,]
nova.test <- nova[test.samp,]

library(nnet)

#fit <- nnet(class ~ ., data = nova.train, size = 5, decay = 0.1, maxit = 300, trace = TRUE)
#table(predict(fit, nova.test, type = "class"), nova.test$class)

#rescale

###Cross vaildation of for different decays
CVnn.nova <- function(formula, data = nova.train,
    size = c(5, 5, 5, 10, 10, 10, 15, 15, 15, 20, 20, 20),
    lambda = rep(c(0.01, 0.05, 0.001),4),
    nreps = 5, nifold = 10, ...){
  CVnn1 <- function(formula, data, nreps = 1, ri,  ...){
  	truth <- data$class
    res <- numeric(length(truth))
    cat("  fold")
    for (i in sort(unique(ri))) {
      cat(" ", i,  sep="")
      for(rep in 1:nreps) {
        learn <- nnet(formula, data[ri !=i,], trace = T, ...)
        res[ri == i] <- res[ri == i] + round(predict(learn, data[ri == i,]))
      }
    }
   cat("\n")
   100 * sum(abs((as.numeric(truth)-1) - round(res/nreps)))/length(truth)
  }
  	
	choice <- numeric(length(lambda))
  	ri <- sample(nifold, nrow(data), replace = TRUE)
  	for(j in seq(along = lambda)) {
    	cat("  size =", size[j], "decay =", lambda[j], "\n")
    	choice[j] <- CVnn1(formula, data, nreps = nreps, ri = ri,
                       size = size[j], decay = lambda[j], ...)
    }
  	cbind(size=size, decay=lambda, fit = choice)
}

CVnn.nova(class ~ ., data = nova.train, maxit = 1000)

best.nnet = function(rep){
	fit <- nnet(class ~ ., data = nova.train, size = 10, decay = 0.05, maxit = 1000, trace = FALSE)
	pred <- predict(fit, nova.test)	
}

preds <- sapply(1:5, best.nnet)
preds <- round(rowSums(preds)/5)
table(preds, nova.test$class)
