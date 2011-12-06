nova <- read.csv("nova.csv")

#Split into training and test sets
set.seed(19848492)
test.samp <- c(sample(5000, size = 500), 5000 + sample(5000, size = 500))
nova.train <- nova[-test.samp,]
nova.test <- nova[test.samp,]

library(rpart)
fit <- rpart(class ~ ., nova.train, cp = 0.0001)

#fit <- rpart(V1 ~ ., nova.train, cp = 0.001, parms = list(split = "information"))
#pdf("cp2.pdf", width = 8, height = 8)
pdf("cp.pdf", width = 8, height = 8)
plotcp(fit)
dev.off()
printcp(fit)
summary(fit)
save(fit, file = "fit.Rdat")
#save(fit, file = "fit2.Rdat")

#fit14 <- prune(fit, cp = 0.0014)
fit11 <- prune(fit, cp = 0.00244)

#pdf("tree2.pdf", height = 12, width = 12)
pdf("tree.pdf", height = 12, width = 18)
plot(fit11, uniform = TRUE)
text(fit11, use.n = TRUE)
#plot(fit14, uniform = TRUE)
#text(fit14, use.n = TRUE)
dev.off()
pred <- predict(fit11, nova.test, type = "vector")
table(nova.test$V1, pred)
#pred <- predict(fit14, nova.test, type = "vector")
#table(nova.test$V1, pred)

library(ggplot)
#class is name of function and was causing problems
names(nova)[1] <- "Class"
q <- qplot(perinc, neighbordist, nova, colour = Class)
q <- ggvline(q, position = -0.6567, range = c(-1,1))
split <- data.frame(x = c(-1, -0.6567), y = -0.2743)
q <- ggline(q, data = split, aes = list(x = x, y = y), colour = "grey30")
split <- data.frame(x = c(-0.7388), y = c(-0.2743,1))
q <- ggline(q, data = split, aes = list(x = x, y = y), colour = "grey50")
q
ggsave(q, "leftside.pdf")

#============ Try with priors =================#

#Raquel says (more than 10,000 negatives for every 
#positive, due to the rare occurrences of Type Ia supernovae 
#and the large sets of data gathered nightly)
#so try prior P(sn) = 1/10000 P(other) = (10000-1)/10000
#no cost
priors = c(1/10000, (10000-1)/10000)
fitp1 <- rpart(class ~ ., nova.train, cp = 0.0001, parms = list(prior = priors) )

printcp(fitp1)
0.12622 + 0.00515
#[1] 0.13137
pdf("cpp1.pdf", width = 8, height = 8)
plotcp(fitp1)
dev.off()
plot(fitp1, uniform = TRUE)
text(fitp1, use.n = TRUE)
##Very Badly behaved#####

#Try more moderate priors
priors = c(1/100, (100-1)/100)
fitp2 <- rpart(class ~ ., nova.train, cp = 0.0001, parms = list(prior = priors) )
printcp(fitp2)
plotcp(fitp2)
#Still no good :(

priors = c(9/10, 1/10)
fitp3 <- rpart(class ~ ., nova.train, cp = 0.0001, parms = list(prior = priors) )
printcp(fitp3)
plotcp(fitp3)
#This works :)
0.34978 + 0.018860
[1] 0.36864
fitp311 <- prune(fitp3, cp = 0.00588889 )
pdf("treep3.pdf", width = 8, height = 8)
plot(fitp311, uniform = TRUE)
text(fitp311, use.n = TRUE)
dev.off()

pred <- predict(fitp311, nova.test, type = "vector")
table(nova.test$class, pred)
#       pred
#          1   2
#  Other 494   6
#  SN    142 358



priors = c(7/10, 3/10)
fitp4 <- rpart(class ~ ., nova.train, cp = 0.0001, parms = list(prior = priors) )
printcp(fitp4)
plotcp(fitp4)
#This works :)
0.18733 + 0.0079423
#0.1952723
0.00318519 
fitp419 <- prune(fitp4, cp = 0.00318519 )
pdf("treep4.pdf", width = 8, height = 8)
plot(fitp419, uniform = TRUE)
text(fitp419, use.n = TRUE)
dev.off()
pred <- predict(fitp419, nova.test, type = "vector")
table(nova.test$class, pred)
#       pred
#          1   2
#  Other 470  30
#  SN     59 441

#Bad!

#============== Costs ==================#
#Cost twice as much to misclassify an other
costs = matrix(c(0,2,1,0), nrow = 2)
fitc1 <- rpart(class ~ ., nova.train, cp = 0.0001, parms = list(loss = costs) )
fitc133 <- prune(fitc1, cp = 0.00111111)
pdf("treec1.pdf", width = 8, height = 8)
plot(fitc133, uniform = TRUE)
text(fitc133, use.n = TRUE)
dev.off()
pred <- predict(fitc133, nova.test, type = "vector")
table(nova.test$class, pred)

#Cost thrice as much to misclassify an other
costs = matrix(c(0,3,1,0), nrow = 2)
fitc2 <- rpart(class ~ ., nova.train, cp = 0.0001, parms = list(loss = costs) )
fitc121 <- prune(fitc1, cp = 0.00244444 )
pdf("treec2.pdf", width = 8, height = 8)
plot(fitc121, uniform = TRUE)
text(fitc121, use.n = TRUE)
dev.off()
pred <- predict(fitc121, nova.test, type = "vector")
table(nova.test$class, pred)


#============== Bagging ================#
library(ipred)
bag.fit <- bagging(class ~ ., data = nova.train, nbagg = 50)
pred <- predict(bag.fit, nova.test)
table(pred, nova.test$class)
       
#pred    Other  SN
#  Other   474  37
#  SN       26 463

