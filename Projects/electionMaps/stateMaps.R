
source("beckerFun.r")
# the becker function finds the individual polylines for each
# state polygon. 
# Note that some state are made up of multiple polygons

#Getthe centroid of the polygons for all state pieces
mapR = map("state", plot=FALSE, fill= TRUE)
statePolys = polys(mapR[["x"]],mapR[["y"]])
stateCenters = sapply(statePolys, centroid.polygon)

#pick out index for one polygon from each state
onePoly = sort( c( (1:63)[- grep(":",mapR[["names"]])], 
                          grep(":south",mapR[["names"]]),
                          grep(":main",mapR[["names"]]) ) )

#reduce the number of polygon centers to one per state +DC
stateCenters1 = stateCenters[ onePoly,]


# need the state total votes counts for bush and kerry 
stateVotes = read.table("stateVotes.txt", header = TRUE, row.names = "state")
attach(stateVotes)
totalVote = bushVote + kerryVote
maxV = max(totalVote)
stateRad = 3*sqrt(totalVotes/maxV)

# first map uses red and blue circles  
colorsRB = ifelse(bushVote > kerryVote, "red", "blue")
colorsRB2 = ifelse(bushVote > kerryVote, rgb(1,0,0,.4), rgb(0,0,1,0.4))

pdf("stateCirclesRB.pdf")
map("state")
symbols(stateCenters1[1,],stateCenters1[2,], circles = stateRad,
            add=TRUE, inches=FALSE, fg = colorsRB, bg = colorsRB)
dev.off()


# Now make a map with thermometers
pdf("stateTherms.pdf")
therms = matrix(c(rep(1.2,49) , rep(3,49), bushProp) , ncol = 3, byrow = FALSE)

map("state")
symbols(jitter(stateCenters1[1,],amount=0.1),jitter(stateCenters1[2,],amount=0.5), 
        thermometers= therms, add=TRUE, inches=FALSE, fg = "red", bg = "blue")
dev.off()


# Now make a map with shades of red and blue

bushProp = bushVote/totalVote
summary(bushProp)
quantile(bushProp, probs = seq(0,1,0.1))
#        0%        10%        20%        30%        40%        50%        60% 
#0.09368454 0.43236528 0.45917441 0.48254635 0.50476729 0.52650871 0.56080074 
#       70%        80%        90%       100% 
#0.58584312 0.60691385 0.64243466 0.72939211 

pdf("bushPropHist.pdf")
hist(bushProp, breaks = 10, xlab = "Proportion of Votes for Bush", main = "")
dev.off()

kerryProp = 1 - bushProp
kerryStrength = cut(kerryProp, breaks = c(0, .40, .44, .48, 
                               .499, .501, .52, .56, .60, 1))

brewerRGB = read.table("EMD/StatComp/Projects/electionMaps/brewercolors")
brewerColors = rgb(brewerRGB[,1],brewerRGB[,2],brewerRGB[,3],maxColorValue=255)
stateColors = brewerColors[kerryStrength]

map("state")
symbols(stateCenters1[1,],stateCenters1[2,], circles=(sqrt(totalVotes/maxV)*2), 
       add = TRUE, inches = FALSE, fg = stateColors, bg = stateColors)

# Put a legend on the map
breakLegend = c("    < 40%", "40 - 44%","44 - 48%","48 - 50%", "50 - 52%", "52 - 56%", "56 - 60%", "    > 60%")
brewerColors8 = brewerColors[-5]
map("state")
map.axes()
legend(-75,35,legend=breakLegend,fill = brewerColors8[8:1])
text(-72, 35.7, "Bush Vote")

# Now try squares rather than circles and use the new found legend
pdf("stateSquareBrewerLegend.pdf",pointsize=6)
map("state",fill=TRUE,bg="gray90",col="gray80")

symbols(stateCenters1[1,],stateCenters1[2,], squares=(sqrt(totalVotes/maxV)*3), 
       add = TRUE, inches = FALSE, fg = stateColors, bg = stateColors)
legend(-75,35,legend=breakLegend,fill = brewerColors8[8:1])
text(-72, 35.7, "Bush Vote")

symbols(rep(-120,4), c(30,29,28,27.5), 
        squares=(sqrt(c(8000000, 4000000, 1000000, 500000)/maxV)*3),
        add = TRUE, inches = FALSE, bg = brewerColors[4])
text(rep(-116, 4), c(30.7, 29.3, 28.1, 27.3), 
      c("8,000,000","4,000,000","1,000,000","  500,000"))
text(-120,32,"Total Voters")
dev.off()



# Make a map with transparent colors
brewerColorsT = rgb(brewerRGB[,1], brewerRGB[,2], brewerRGB[,3], 
                     150, maxColorValue = 255)
stateColorsT = brewerColorsT[kerryStrength]

#pdf("test4.pdf", version = "1.4")
map("state")
symbols(stateCenters1[1,],stateCenters1[2,], circles=(sqrt(totalVotes/maxV)*2), 
       add = TRUE, inches = FALSE, fg = stateColorsT, bg = stateColorsT)
#dev.off()

pdf("stateBrewerTrans.pdf", version = "1.4", pointsize = 6)
map("state")
symbols(stateCenters1[1,],stateCenters1[2,], circles=(sqrt(totalVote/maxV)*2),
        add = TRUE, inches = FALSE, fg = stateColorsT, bg = stateColorsT)
legend(-75,35,legend=breakLegend,fill = brewerColors8[8:1])
text(-72, 35.7, "Bush Vote")

symbols(rep(-120,4), c(30,29,28,27.5), 
        circles=(sqrt(c(8000000, 4000000, 1000000, 500000)/maxV)*2),
        add = TRUE, inches = FALSE, bg = brewerColorsT[4])
text(rep(-116, 4), c(30.7, 29.3, 28.1, 27.3), 
      c("8,000,000","4,000,000","1,000,000","  500,000"))
text(-120,32,"Total Voters")
dev.off()

