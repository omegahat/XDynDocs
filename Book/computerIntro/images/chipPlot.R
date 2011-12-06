bestplot = function() {
  Chips = read.table("chips.txt", header = TRUE, row.names = 1)
  Chips$Clock[9:10] = Chips$Clock[9:10]*1000

  Chips = Chips[-5]

  ChipsN = as.data.frame(lapply(Chips[-1], function(x) x/x[1]))

  ylabel = "Change relative to 1975 - log scale"
  xlabel = "Date"
  coll = c("black","red","green","blue")
  matplot(Chips$Date, cbind(ChipsN[c(1,3,5)],1/ChipsN[2]),
        type="l", log="y", lwd=2, lty=1, ylab=ylabel, xlab=xlabel, col=coll)

  varl = names(ChipsN[c(1,3,5,2)])
  legend(1976,1000,legend=varl,fill=coll,bty="n")

  abline(v=1993,col="grey")
  abline(v=1985,col="grey")
  mtext(text="Pentium",side=3,line=-1.2,at=1993+0.1,adj=0)
  mtext(text="32 bit processor",side=3,line=-1.2,at=1985+0.1,adj=0)
}

