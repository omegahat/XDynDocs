diamonds <- read.table("~/Documents/diamonds.csv", sep=",", header = TRUE)
diamonds$price <- diamonds$price * 0.651
diamonds$clarity <- factor(diamonds$clarity, levels = c("IF", "VVS1", "VVS2",  "VS1",  "VS2", "SI1", "SI2", "I1"))
diamonds[diamonds == 0] = NA
diamonds = diamonds[-c(24068, 49190, 11183, 11964, 48411), ]


set.seed(1937519430)
n = nrow(diamonds)
test.samp <- c(sample(n, size = 1/10*n))
dia.train <- diamonds[-test.samp,]
dia.test <- diamonds[test.samp,]

library(randomForest)
rf <- randomForest(price ~ carat + cut + color + clarity + height + width + depth + totaldepth + table, data = dia.train, importance = TRUE, proximity = TRUE, keep.forest = TRUE, ntree = 1000, na.action = na.omit)

sum((dia.test$price - predict(rf, dia.test))^2)/nrow(dia.test)
rf

