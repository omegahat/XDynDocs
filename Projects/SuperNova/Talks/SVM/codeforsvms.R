setwd(""~/Documents/Machine Learning/")

g.mean.x = rnorm(10) + 1
g.mean.y = rnorm(10)
r.mean.x = rnorm(10) 
r.mean.y = rnorm(10) + 1

g.means = sample(1:10, 100, replace = TRUE)
green.x = rnorm(100, g.mean.x[g.means], sd=0.4)
green.y = rnorm(100, g.mean.y[g.means], sd=0.4)

r.means = sample(1:10,100, replace = TRUE)
red.x = rnorm(100, r.mean.x[r.means], sd=0.4)
red.y = rnorm(100, r.mean.y[r.means], sd=0.4)

mix.data = data.frame(x = c(green.x, red.x), y = c(green.y, red.y), group = rep(c(1,2), c(100,100)))

qplot(x,y,mix.data, colour = group)
mix.data$group = as.factor(mix.data$group)

range.x = range(mix.data$x)
range.y = range(mix.data$y)

grid.test = expand.grid(x = seq(range.x[1], range.x[2], length = 50), y = seq(range.y[1],range.y[2],length = 50))
grid.test$group = predict(fit1, grid.test)

fit.data = rbind(mix.data, grid.test)
fit.data$type = rep(c ("2", "1"), c(200,50*50))

fit.data$SV = 1
fit.data$SV[as.numeric(rownames(fit1$SV))] = 2

p = qplot(x,y,fit.data, colour = group, size = type, shape = SV)
scsize(p, to = c(0.5,3))

ggopt(legend.position = "none", aspect.ratio = 1)
##SVM linear different errors allowed
fit1 = svm(group ~ x + y, data = mix.data, kernel = "linear", cross = 5)
fit2 = svm(group ~ x + y, data = mix.data, kernel = "linear", cost = 20, cross = 5)
p = plot.res(fit1)
ggsave(p, "linc1.png", height = 5, width = 5)
p = plot.res(fit2)
ggsave(p, "linc20.png", height = 5, width = 5)

fit3 = svm(group ~ x + y, data = mix.data, kernel = "radial", cross = 5)
p = plot.res(fit3)
ggsave(p, "raddef.png", height = 8, width = 8)



bsvm <- best.svm(group ~ ., data = mix.data, gamma = 2^(-1:2), cost = 2^(2:+ 4), probability=TRUE, tunecontrol = tune.control(cross = 5))
p = plot.res(bsvm)
ggsave(p, "radbs.png", height = 8, width = 8)

obj <- tune(svm, group ~ ., data = mix.data, 
             ranges = list(gamma = 2^(-1:2), cost = 2^(2:4)),
			tune.control = tune.control(cross = 5)
            )


fit4 = svm(group ~ x + y, data = mix.data, kernel = "polynomial")
p = plot.res(fit4)
ggsave(p, "polydef.png", height = 8, width = 8)

fit5 = best.svm(group ~ ., data = mix.data, kernel = "polynomial", degree = 1:4, cost = 2^(2:+ 4), probability=TRUE, tunecontrol = tune.control(cross = 5))
p = plot.res(fit5)
ggsave(p, "polyb.png", height = 8, width = 8)



plot.res = function(fit){
grid.test = expand.grid(x = seq(range.x[1], range.x[2], length = 50), y = seq(range.y[1],range.y[2],length = 50))
grid.test$group = predict(fit, grid.test)
fit.data = rbind(mix.data, grid.test)
fit.data$type = rep(c ("2", "1"), c(200,50*50))
fit.data$SV = "Other"
fit.data$SV[as.numeric(rownames(fit1$SV))] = "Support Vector"
p = qplot(x,y,fit.data, colour = group, size = type, shape = SV)
p = scsize(p, to = c(0.4,3))
p
}