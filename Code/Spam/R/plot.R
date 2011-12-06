plotErrors =
function(logOdds, isSpam, showLegend = TRUE, elim = c(.05, .005),
         widths = c(3, 3, 3, 1),
         heights = c(1, 3, 3, 1),
         legendPos = c(min(tp2$values[tp2$error > .98]) + 10, .99))
{
  # Compute the type I and II error rates.
 tp1 = typeIErrorRates(logOdds, isSpam)
 tp2 = typeIIErrorRates(logOdds, isSpam)

 # Organize the screen into rows and columns for the two plots.
 # We have 5 rows and 4 columns.
 # Each value in the matrix refers to the figure, i.e. 1 or 2.
 # And that figure appears in that row and column.
 # So figure 1 is in rows 1 and 5 and hence 1 through 5;
 # and in columns 1 and 4 so 1 through 4.
 # And figure 2 is in rows 2 through 4
 # and columns 2 through 4.
 # We can 
 #layout.show(layout(matrix(c(1, 0, 0, 1,
 #                            0, 2, 0, 2,
 #                            0, 0, 0, 0,
 #                            0, 2, 0, 2,
 #                            1, 0, 0, 1,), 5, 4, byrow=TRUE)))

 # Alternatively we can use a simpler matrix and give relative
 # widths of the columns and heights of rows.
  layout(matrix(c(1, 0, 0, 1,
                  0, 2, 2, 0,
                  0, 2, 2, 0,
                  1, 0, 0, 1,), 4, 4, byrow=TRUE),
         widths = widths,
         heights = heights)
 
 
 plot(0, xlim = range(tp1$values), ylim = c(0, 1), type = "n",
      xlab=expression(tau), ylab= "Error Rate",
      main = "Naive Bayes SPAM Classifier - Type I and II Error Rates", cex=2)

 lines(tp1$values, tp1$error, col = "red")
 points(tp1$values, tp1$error, col = "red", pch = "+")

 lines(tp2$values, tp2$error, col = "green")
 points(tp2$values, tp2$error, col = "green", pch = "o")

 abline(h = .01, lty = 2, col = "blue")

 if(showLegend) {
   legend(legendPos[1], legendPos[2], 
          c("Type I", "Type II"),
          col = c("red", "green"),
          pch = c("+", "o"), cex = 2)
 }

  # Now plot the inset plot which is a zoom in on
  # the region where the Type I error rate is
  # in the region given by elim.
 i = which(tp1$error > min(elim) & tp1$error < max(elim)) 

  # Now do the plotting.
 plot(0, xlim = range(tp1$values[i]), ylim = sort(elim), type = "n",
      xlab=expression(tau), ylab= "Error Rate")
 xlim = range(tp1$values[i])
 lines(tp1$values[i], tp1$error[i], col = "red")
 points(tp1$values[i], tp1$error[i], col = "red", pch = "+")

 i = which(tp2$values > min(xlim) & tp2$values < max(xlim))  
 lines(tp2$values[i], tp2$error[i], col = "green")
 points(tp2$values[i], tp2$error[i], col = "green", pch = "o") 
 
 
  # Show the point where
 tau.star = findTau(tp1)
 abline(h = .01, lty = 2, col = "blue")
 abline(v = tau.star, lty = 2, col = "blue")

 text(tau.star + 1, .9*max(elim),
      substitute(tau == val, list(val = round(tau.star, 2))),
      adj = 0,  # left align the text
      cex = 2)
 
 invisible(list(typeI = tp1, typeII = tp2, tau = tau.star))
}

