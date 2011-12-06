meUSA = read.csv("~/ElectionProject/election04/ME", header=FALSE)
nameGOV = tolower(as.character(meUSA[,2]))

meGOV = read.csv("~/EMD/StatComp/Book/electionMaps/MEnames.csv",
          header=FALSE)
nameGOV = tolower(as.character(meGOV[,2]))

nameMatch2 = match(nameGOV,nameUSA)
miss2 = which(is.na(nameMatch2))
nameGOV[miss2]

nameMatch = match(nameUSA,nameGOV)
miss = which(is.na(nameMatch))
nameUSA[miss]

#matched all but two townships
#orneville and trescott

bv = as.numeric(gsub(",","",as.character(meUSA[,4])))
kv = as.numeric(gsub(",","",as.character(meUSA[,5])))
cty = as.character(meGOV[nameMatch,1])

ctyBSum = tapply(bv,cty,sum)
ctyKSum = tapply(kv,cty,sum)

> ctyBSum
  AND   ARO   CUM   FRA   HAN   KEN   KNO   LIN   OXF   PEN   PIS   SAG   SOM
  24453 17726 65184  7355 14385 29577 10103 10370 14368 40189  5261 10063 12951
  WAL   WAS   YOR
 10309  8621 49501
> ctyKSum
  AND   ARO   CUM   FRA   HAN   KEN   KNO   LIN   OXF   PEN   PIS   SAG   SOM
  30345 19539 94699  9464 18037 34051 12693 11351 16829 40285  4378 11688 13555
  WAL   WAS   YOR
  11554  8398 58596




