n = 100
x = rnorm(n)
e = rnorm(n)

y = 3 + 10*x + e

fit = lm(y ~ x)
plot(fit)

