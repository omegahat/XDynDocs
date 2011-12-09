n = 100
x = rnorm(n)
e = rnorm(n)

y = 3 + 10*x + e


a = 1:3
b = sum(a)
k = rpois(b)


fit = lm(y ~ x)
plot(fit)

