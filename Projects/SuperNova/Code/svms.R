nova = read.csv("nova.csv")

#Split into training and test sets
set.seed(19848492)
test.samp = c(sample(5000, size = 500), 5000 + sample(5000, size = 500))
nova.train = nova[-test.samp,]
nova.test = nova[test.samp,]
library(e1071)

costs = c(0.5,(1:10)^2)
gammas =  c(0.0001, 0.001, 0.005, 0.01)
obj <- tune(svm, V1 ~ ., data = nova.train, 
              ranges = list(gamma = gammas, cost = costs),
             )
obj$performances
obj$best.model

#Performance of best model on test set.
table(nova.test$V1, predict(obj$best.model, nova.test))
