tauVar =
function(cv)
{
 apply(cv$testSets, 2, function(x) {
                          tp1 = typeIErrorRates(cv$logOdds[x], cv$isSpam[x])
                          findTau(tp1)
                       })
}  


plotTestSetError =
function(cv, xlim = range(cv$logOdds))
{
 plot(0,
       xlim = xlim,
       ylim = c(0, 1), type = "n",
       xlab = expression(tau),
       ylab = "Type I Error",
       main = "Type I Errors for 10 test sets")

 sapply(1:ncol(cv$testSets),
          function(i) {
            x = cv$testSets[, i]
            logOdds = cv$logOdds[x]
            isSpam = cv$isSpam[x]
            o = order(logOdds)
            tp1 = typeIErrorRates(logOdds[o], isSpam[o])
            print(range(tp1$values))
            lines(tp1$values, tp1$error)

            tau = findTau(tp1)
            abline(v = tau, lty = 2, col = "red")

            tau
            # tp1
          })
}  

