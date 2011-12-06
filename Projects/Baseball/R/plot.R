plotPayrolls =
  #
  # Example:
  #
  # d = dbGetQuery(con, "select Salaries.yearID AS Year, Teams.name AS Team, SUM(Salaries.salary) AS Payroll, Teams.lgID as League FROM Master, Teams, Salaries WhERE Salaries.yearID = Teams.yearID AND Master.playerID = Salaries.playerID AND Teams.teamID = Salaries.teamID GROUP BY Team, Year ORDER BY Team, Year;")
  #
  #
  # plotPayrolls(d, add = FALSE, main = "Payroll for Baseball Teams over years")
  # boxplot(Payroll ~ Year, data = d,at = 1985:2003, add = TRUE, col="red", lwd=2, notch = TRUE)
  #
  #
function(d, dd = by(d, d[,"Team"], function(x) x), ...,
          xlab = "Year", ylab = "Payroll", add = FALSE,
          showLeague = "League" %in% colnames(d)
         )
{
 if(!add)
   plot(0, xlim = range(d[,"Year"]), ylim = range(d[,"Payroll"]), type = "n", ..., xlab = xlab, ylab = ylab)

 sapply(1:length(dd), function(i) {
                        lines(dd[[i]][,"Year"], dd[[i]][,"Payroll"], col = i, lty = i)
                        if(showLeague)
                          points(dd[[i]][,"Year"], dd[[i]][,"Payroll"], col = i,
                                   pch = ifelse(dd[[i]][1,"League"] == "AL", "+", "o"))
                        TRUE
                     })
 
 legend(min(d[,"Year"]), max(d[,"Payroll"]), names(dd), col = 1:length(dd), lty = 1:length(dd), cex = .90)

 if(showLeague)
   legend(mean(d[,"Year"]), max(d[,"Payroll"]),
           c("American League", "National League"),  pch = c("+", "o"))
 
 invisible(dd)
}  
