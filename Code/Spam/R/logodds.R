showWordLogOdds = 
function(tb.lingSpam, tb.SpamAss) {
 par(mfrow=c(2,2))
 hist(tb.lingSpam[3,], xlim=c(-9,7), main="LingSpam Present")
 hist(tb.lingSpam[4,], xlim=c(-1,1.5), main="LingSpam Absent")

 hist(tb.SpamAss[3,], xlim=c(-9,7), main="Spam Assassin Present")
 hist(tb.SpamAss[4,], xlim=c(-1,1.5), main="Spam Assassin Absent") 
}

compareLogOdds =
function(tb.lingSpam, tb.SpamAss)
{
 par(mfrow=c(1,2))
 commonWords = intersect(colnames(tb.lingSpam), colnames(tb.SpamAss))
 
 plot(tb.lingSpam[3,commonWords], tb.SpamAss[3,commonWords],
       xlab = "Lingspam", ylab = "Spam Assassin", main = "Log-odds Word Present")
 plot(tb.lingSpam[4,commonWords], tb.SpamAss[4,commonWords],
        xlab = "Lingspam", ylab = "Spam Assassin", main = "Log-odds Word Absent")
}

