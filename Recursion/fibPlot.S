

plot(1:ncol(fibonacci.times), fibonacci.times[3,]/10,
       xlab = "n", ylab = "Seconds", col = "red",
       main = "Seconds for each call to fibonacci and fib2",
       cex.main = 1.2, cex.axis = 1.2, cex.lab = 1.2, cex = 1.2)
points(1:ncol(fibonacci.times), fib2.times[3,] / 1000, pch = "+", col = "blue")

legend(2, .9*max(fibonacci.times[3,]/10), c("recursive", "iterative"), pch = c("o", "+"))



plot(1:ncol(fibonacci.times), fib2.times[3,]/1000,
       xlab = "n", ylab = "Seconds", col = "blue",
       main = "Seconds for each call to iterative fib2",
       cex.main = 1.2, cex.axis = 1.2, cex.lab = 1.2, cex = 1.2)


matplot(cbind(dynFib2.times[3,]/1000, fib2.times[3,]/1000), xlab = "n", ylab = "Seconds", main = "Time per call to fib2 and dynFibonacci", pch = c("+", "*"))
