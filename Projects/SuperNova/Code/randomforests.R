nova <- read.csv("nova.csv")

#Split into training and test sets
set.seed(19848492)
test.samp <- c(sample(5000, size = 500), 5000 + sample(5000, size = 500))
nova.train <- nova[-test.samp,]
nova.test <- nova[test.samp,]

library(randomForest)

rf <- randomForest(class ~ ., data = nova.train, importance = TRUE, proximity = TRUE, keep.forest = FALSE, ntree= 1000)
pred <- predict(rf, nova.test)
table(nova.test$class, pred)
#     Other  SN
#Other   484  16
#SN       39 461


importance <- data.frame(rf$importance)
names(importance) <- c("Other", "SN", "Decrease", "Gini")
plot(importance$names, importance$Decrease, las = 2)

rf2 <- randomForest(class ~ ., data = nova.train, mtry = 2, ntree= 1000, importance = TRUE, proximity = TRUE, keep.forest = FALSE)

rf8 <- randomForest(class ~ ., data = nova.train, mtry = 8, ntree = 1000, importance = TRUE, proximity = TRUE, keep.forest = FALSE)

