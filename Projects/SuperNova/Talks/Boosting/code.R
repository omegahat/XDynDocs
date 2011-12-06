library(rpart)
nova <- read.table("scaled.csv", sep=",")
dim(nova)
nova$V1 <- as.factor(nova$V1)
levels(nova$V1) <- c("Other", "SN")
names(nova) <- c("class", "apsig", "perinc", "pcygsig", "mxy", "fwx", "fwy", "neighbordist", "new1sig", "new2sig", "sub1sig", "sub2sig", "sub2minsub1", "dsub1sub2", "holeinref", "bigapratio", "relfwx", "relfwy", "roundness", "wiggliness")

set.seed(19848492)
test.samp <- c(sample(5000, size = 500), 5000 + sample(5000, size = 500))
nova.train <- nova[-test.samp,]
nova.test <- nova[test.samp,]

N <- nrow(nova.train)
weights <- rep(1/N, N)
M <- 100
alpha <- numeric(M)
t.pred <- matrix(nrow = nrow(nova.test), ncol = M)
for(m in 1:M){
	fit <- rpart(class ~ ., data = nova.train, weights = weights, control = rpart.control(maxsurrogate = 0, maxdepth = 7, minsplit = 1, cp = 0.1, xval = 0))
	fit <- prune(fit, cp =  fit$cptable[fit$cptable[,"nsplit"]==6, "CP"])
	pred <- predict(fit, type = "vector") 
	err <- sum(weights * (pred != as.numeric(nova.train$class)))/sum(weights)
	alpha[m] <- log((1-err)/err)
	weights <- weights * exp(alpha[m] * (pred != as.numeric(nova.train$class)))
	
	#get test predictions
	t.pred[ , m] <- predict(fit, nova.test, type = "vector")
	
	
	}
all.pred <- sign(((t.pred*2)-3) %*% alpha)

error.f = function(n){
	pred <- sign((t.pred*2-3)[, 1:n] %*% as.matrix(alpha[1:n]))
	err <- table(pred, nova.test$class)[1,2] + table(pred, nova.test$class)[2,1]
	err/1000
}

error <- sapply(1:100, error.f)

q <- qplot(1:100,error, type = "line")
q$xlabel <- "Boosting Iterations"
q$ylabel <- "Test Error"



gbm1 <- gbm(class ~ ., data = nova.train)
  