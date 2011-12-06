
findCountyCenters = function() {
   source("~/EMD/StatComp/Projects/electionMaps/beckerFun.r")

# the becker function finds the individual polylines for each
# state polygon. 
# Note that some state are made up of multiple polygons

#Getthe centroid of the polygons for all county pieces
   mapR = map("county", plot=FALSE, fill= TRUE)
   countyPolys = polys(mapR[["x"]],mapR[["y"]])
   countyCenters = sapply(countyPolys, centroid.polygon)

#pick out index for one polygon from each county
   nC = ncol(countyCenters)

   onePoly = sort( c( (1:nC)[- grep(":",mapR[["names"]])], 
                   grep(":south",mapR[["names"]]),
                   grep(":san juan",mapR[["names"]]),
                   grep(":main",mapR[["names"]]) 
                 ) 
              )

#reduce the number of polygon centers to one per county
   countyCenters1 <<- countyCenters[ , onePoly]
   polyNames = mapR[["names"]][ onePoly ]
   polyNames <<- gsub(":.*$","", polyNames)

# pull out the subset in the voting dataframe that matches
# the polyNames. For those counties that we have no vote
# tallies we will get NAs 
}

#pdf("countyBrewerTrans.pdf", version = "1.4", pointsize = 6)

# need the state total votes counts for bush and kerry 
makeCountyMap =  function(centers = countyCenters1, 
      bushVote = bushVote, kerryVote = kerryVote, type="county", 
      scale = 3, breaks = breaks, transparent = NULL, boundary = FALSE)
 {
    totalVote = bushVote + kerryVote
    maxV = max(totalVote, na.rm = TRUE)
    Radius = scale * sqrt(totalVote/maxV)

    bushProp = bushVote/totalVote
    kerryProp = 1 - bushProp
    kerryStrength = cut(kerryProp, breaks = breaks )

    brewerRGB = read.table("~/EMD/StatComp/Projects/electionMaps/brewercolors")

    if (is.null(transparent))
         brewerColors = rgb(brewerRGB[,1], brewerRGB[,2], brewerRGB[,3],
                             maxColorValue=255)
    else
         brewerColors = rgb(brewerRGB[,1], brewerRGB[,2], brewerRGB[,3],
                             transparent, maxColorValue=255)
    stateColors = brewerColors[kerryStrength]

    if (boundary) map("county", fill=TRUE, bg="gray90", col="gray80")
    else  map("state", fill=TRUE, bg="gray90", col="gray80")

    symbols(centers[1,], centers[2,], squares= Radius,
             add = TRUE, inches = FALSE, fg = stateColors, bg = stateColors)
}


mm = function(centers = countyCenters1) {
  load("~/CountyVotes04/countyClean.rda")
  countyVotePlot = countyVote[polyNames, ]
  attach(countyVotePlot)
  makeCountyMap(centers = centers, 
      bushVote = bushVote, kerryVote = kerryVote, type="county", 
      scale = 3, breaks = breaks, transparent = NULL, boundary = FALSE)

   breaks = c(0, .40, .44, .48, .499, .501, .52, .56, .60, 1)
   breakLegend = c("    < 40%", "40 - 44%","44 - 48%","48 - 50%", 
                   "50 - 52%", "52 - 56%", "56 - 60%", "    > 60%")
   brewerColors8 = brewerColors[-5]

    legend(-75,35,legend=breakLegend,fill = brewerColors8[8:1])
    text(-72, 35.7, "Bush Vote")

#    symbols(rep(-120,4), c(30,29,28,27.5), 
#        squares=(sqrt(c(8000000, 4000000, 1000000, 500000)/maxV)*3),
#        add = TRUE, inches = FALSE, bg = brewerColors[4])
#   text(rep(-116, 4), c(30.7, 29.3, 28.1, 27.3), 
#      c("8,000,000","4,000,000","1,000,000","  500,000"))
#   text(-120,32,"Total Voters")
}
