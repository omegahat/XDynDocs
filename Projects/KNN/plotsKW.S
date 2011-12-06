lineplots = 
   function(data, w = 1, type = 1, xlim = c(1,20), 
      ylim =c(0.01, 0.02), color = FALSE, 
      lx = mean(xlim), ly = mean(ylim) )
{

if (is.logical(color) && color) {
 coll = c("black","green","blue","red","orange")
# coll = coll[w]
 nameW = c("w = 1", "w = 5", "w = 10", "w = 15", "w = 20")
# nameW = nameW[w]
}
else coll = NULL

 plot(1-data[[w[1]]][type[1],], 
      xlim=xlim,ylim=ylim, type ="l",lwd=2, col=coll[1])
 for (i in w[-1]) {
   points(1-data[[i]][type[1],], type="l", lwd=2, col=coll[i])
 }
 if (length(type) >1) {
  for (i in w) {
   points(1-data[[i]][type[2],], type="l", lwd=2, col=coll[i])
   }
 }
 if (color)
   legend(lx, ly,legend=nameW[w], fill=coll[w] ,bty="n")

}
