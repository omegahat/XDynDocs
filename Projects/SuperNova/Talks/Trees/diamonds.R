diamonds <- read.table("diamonds.csv", sep=",", header = TRUE)
library(ggplot)
library(rggobi)
names(diamonds)
#[1] "shape"      "carat"      "cut"        "color"      "clarity"   
#[6] "totaldepth" "table"      "price"      "width"      "height"    
#[11] "depth"

diamonds$price <- diamonds$price * 0.651
g <-ggplot(diamonds)
#outliers 24067 49189 11182 11963 48410
diamonds$clarity <- factor(diamonds$clarity, levels = c("IF", "VVS1", "VVS2",  "VS1",  "VS2", "SI1", "SI2", "I1"))
#Remove missing dimensions
diamonds[diamonds == 0] = NA

diamonds[c(24068, 49190, 11183, 11964, 48411), ]
#      shape carat       cut color clarity totaldepth table price width height
#24068 Round  2.00   Premium     H     SI2       58.9  57.0 12210  8.09  58.90
#49190 Round  0.51     Ideal     E     VS1       61.8  55.0  2075  5.15  31.80
#11183 Round  1.07     Ideal     F     SI2       61.6  56.0  4954  0.00   6.62
#11964 Round  1.00 Very Good     H     VS2       63.3  53.0  5139  0.00   0.00
#48411 Round  0.51 Very Good     E     VS1       61.8  54.7  1970  5.12   5.15
#      depth
#24068  8.06
#49190  5.12
#11183  0.00
#1964  0.00
#48411 31.80

diamonds = diamonds[-c(24068, 49190, 11183, 11964, 48411), ]


diamonds.sub <- diamonds[sample(nrow(diamonds),1000), ]

qplot(depth, data = diamonds, xlim = c(2,6), breaks = 400, type = "histogram")
qplot(totaldepth, data = diamonds, xlim = c(55,70), breaks = 400, type = "histogram")

qplot(table, data = diamonds, type = "histogram",  breaks = 400, xlim = c(50,70))

qplot(price, data = diamonds, type = "histogram", breaks = 200)


#Highly correlated - some zeros?
qplot(height, width, diamonds)
qplot(depth, height, diamonds)
qplot(width, depth, diamonds)

qplot(width, price, diamonds)

#Not very correlated

qplot(depth, totaldepth, diamonds)

#Note "rounding up" and non linear relationship
qplot(carat, price, diamonds)

#Obvious trend
qplot(price, color, diamonds, type = c("boxplot"))
qplot(price, clarity, diamonds, type = c("boxplot"))


qplot(price, cut, diamonds, type = c("boxplot", "jitter"))
qplot(price, totaldepth, diamonds)
qplot(price, table, diamonds)

set.seed(1937519430)
n = nrow(diamonds)
test.samp <- c(sample(n, size = 1/10*n))
dia.train <- diamonds[-test.samp,]
dia.test <- diamonds[test.samp,]

fit.l <- lm(formula = log(price) ~ carat + cut + color + clarity + totaldepth + 
    table + width + height + depth, data = dia.train)
pred.lm <- predict(fit.l, dia.test)
error <- sum((pred.lm - log(dia.test$price))^2, na.rm = TRUE)
error <- sum((exp(pred.lm) - dia.test$price)^2, na.rm = TRUE)

fit.l2 <- lm(formula = log(price) ~ carat + cut + color + clarity + totaldepth + 
    table + width, data = dia.train[!(is.na(dia.train$height)|is.na(dia.train$depth)),])

fit.p <- lm(formula = price ~ carat + cut + color + clarity + totaldepth + 
	    table + width + height + depth, data = dia.train)
pred.lp <- predict(fit.p, dia.test)
error <- sum((pred.lp - dia.test$price)^2, na.rm = TRUE)



library(rpart)
pdf("cpdia.pdf", width = 8, height = 8)
plotcp(fit)
dev.off()

fit <- rpart(price ~ ., data = dia.train, method = "anova", cp = 0.0001)
fit99 <- prune(fit, cp = 0.00010967)
sum((dia.test$price - predict(fit99, dia.test))^2)/nrow(dia.test)

fit50 <- prune(fit, cp = 0.00033396)
sum((dia.test$price - predict(fit50, dia.test))^2)/nrow(dia.test)

plot(fit50, uniform = TRUE)
text(fit50, use.n = TRUE)


#also fit tree to log(price)?

fit2 <- rpart(log(price) ~ ., data = dia.train, method = "anova", cp = 0.00001)
fit86 <- prune(fit2, cp =  0.00010253 )
sum((log(dia.test$price) - predict(fit86, dia.test))^2)
sum((dia.test$price - exp(predict(fit86, dia.test)))^2)/nrow(dia.test)

library(ipred)
bag.fit <- bagging(price ~ ., data = dia.train, nbagg = 50)
pred <- predict(bag.fit, dia.test)
sum((dia.test$price - predict(bag.fit, dia.test))^2)/nrow(dia.test)

bag.prune <- prune(bag.fit, cp = 0.00033396)
sum((dia.test$price - predict(bag.prune, dia.test))^2)/nrow(dia.test)


