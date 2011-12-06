load(url("http://eeyore.ucdavis.edu/stat242/HW5/OfflineBaseStationSignals.rda"))
load(url("http://eeyore.ucdavis.edu/stat242/HW5/AccessPointLocations.rda"))

#load("~/Data/Mannheim/AccessPointLocations.rda")
#load("~/Data/Mannheim/OfflineBaseStationSignals.rda")

medians = OfflineBaseStationSignals[ c("x", "y", "orientationLevel", rownames(AccessPointLocations))]

 # Get the signal strengths for each (x, y) that we observer with all the orientation levels
 # and to each base station. This comes out in the form
 # base station 1/orientation level 1 2 3 4 5 6
 # base station 2/orientation level 1 2 3 4 5 6
 # ...
z = with(medians, by(medians, list(x, y), function(x) unlist(x[, -(1:3)])))
signals = z[sapply(z, length)  > 0]

pos = with(medians, by(medians, list(x, y), function(x) x[1, 1:2]))
pos = do.call("rbind", pos) 



library(SVGAnnotation)

 # Create the basic plot of the building with the access points
doc = svgPlot("building.svg", {
          plot(y ~ x, medians, xlim = range(c(AccessPointLocations[,1], medians$x)),
                               ylim = range(c(AccessPointLocations[,2], medians$y)))
          text(AccessPointLocations, labels = seq(length = nrow(AccessPointLocations)), cex = 2)
        }, asXML = TRUE)


txt = getTextPoints(doc)


 # And a onmouseover and onmouseout attribute to each point.
 # Each of these are calls of the form fun(ev, pointIndex, ..)
 # Note that we pass 2 variables containing the data in the variables
 # accessPoints and signals.  These are javascript variables that we will
 # create down below by exporting R objects to Javascript
 #
pts = getPlotPoints(doc)
invisible(mapply(function(node, over, out){
                  addAttributes(node, onmouseover = over, onmouseout = out)
                 }, pts, paste("showStart(evt.target,", seq(along = pts) - 1, ", accessPoints, signals)"),
                    paste("hideLines(evt.target,", seq(along = pts) - 1, ")")))


invisible(sapply(pts, modifyStyle, fill = "white"))


 # Now let's compute the SVG coordinates for the middle of the base stations, i.e. the (x, y)
 # locations for the 6 points but within the SVG coordinate system, not in the R plot coordinates.
mapply(function(x, id) addAttributes(x, id = id), txt, paste("baseStation", seq(along = txt)))

pos = structure(sapply(txt, getBoundingBox), dimnames = list(c("x", "x", "y", "y"), NULL))
accessPoints = matrix(c(apply(pos[1:2,], 2, mean),
                        apply(pos[3:4,], 2, mean)), , 2)

addECMAScripts(doc, "starplot.js", accessPoints = accessPoints, signals = signals) # , insertJS = TRUE)

saveXML(doc, "star.svg")

