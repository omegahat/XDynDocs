#
# This currently does not do the right thing, but gets the point across.
# It only works with the first orientation level.
#

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
z = z[sapply(z, length)  > 0]

pos = with(medians, by(medians, list(x, y), function(x) x[1, 1:2]))
pos = do.call("rbind", pos) # [sapply(pos, length)]  


     
if(FALSE) {
meds = with(off, by(off, list(x, y, orientationLevel),
                function(x) c(x = x$x[1], y = x$y[1], orientationlevel = x$orientationLevel[1], tapply(x$signal, x$mac, median))))
all(sapply(meds[-1], function(x) all(names(x) == names(meds[[1]]))))

medians = as.data.frame(do.call("rbind", meds))
names(medians) = names(meds[[1]])

medians = medians[,c(1:3, match(rownames(AccessPointLocations), names(medians)))]
}
     

################

library(SVGAnnotation)

 # Create the basic plot of the building with the access points
doc = svgPlot("building.svg", {
          plot(y ~ x, medians, xlim = range(c(AccessPointLocations[,1], medians$x)),
                               ylim = range(c(AccessPointLocations[,2], medians$y)))
          text(AccessPointLocations, labels = seq(length = nrow(AccessPointLocations)), cex = 2)
        }, asXML = TRUE)


 # Add tooltips to each point.
 # Generate the tooltips which are values for each observation.
 # Note that the points are over-plotted, i.e. 8 points for each (x, y) 
tips = apply(matrix(paste(names(medians), t(medians), sep = " = "), , ncol(medians), byrow = TRUE), 1, paste, collapse = ", ")
 
invisible(addToolTips(doc, tips))

 # Add a tooltip to each of the access points.
 # Find the nodes in the XML document first and then add the tooltip.
 # This uses XPath to find the <g> nodes which have the form
 #   <g><use xlink:href="#glyph2-...."/></g>
 # i.e. an href to an element in the <defs> with an id starting with glyph2-...
txt = getNodeSet(doc, '//s:g[starts-with(s:use/@xlink:href, "#glyph2-")]',
                   c( s = "http://www.w3.org/2000/svg", xlink="http://www.w3.org/1999/xlink"))

invisible(mapply(addToolTips, txt, rownames(AccessPointLocations)))

addCSS(doc, insert = TRUE)  # for the invisible rectangle style.


 # And a onmouseover and onmouseout attribute to each point.
 # Each of these are calls of the form fun(ev, pointIndex, ..)
 # Note that we pass 2 variables containing the data in the variables
 # accessPoints and signals.  These are javascript variables that we will
 # create down below by exporting R objects to Javascript
 #
pts = getPlotPoints(doc)
invisible(mapply(function(node, over, out){
                  addAttributes(node, onmouseover = over, onmouseout = out)
                 }, pts, paste("showLines(evt.target,", seq(along = pts) - 1, ", accessPoints, signals)"),
                    paste("hideLines(evt.target,", seq(along = pts) - 1, ")")))

 # Change the fill style value in the points from none to white so that
 # when the viewer moves over the interior, it is considered part of the point
 # and not just the stroke/path of the circle.
invisible(sapply(pts, modifyStyle, fill = "white"))


 # Now let's compute the SVG coordinates for the middle of the base stations, i.e. the (x, y)
 # locations for the 6 points but within the SVG coordinate system, not in the R plot coordinates.
mapply(function(x, id) addAttributes(x, id = id), txt, paste("baseStation", seq(along = txt)))

pos = structure(sapply(txt, getBoundingBox), dimnames = list(c("x", "x", "y", "y"), NULL))
accessPoints = matrix(c(apply(pos[1:2,], 2, mean),
                        apply(pos[3:4,], 2, mean)), , 2)


 # We also export the signals to each base station as an array
 # with 6 elements each of which is a 1328-long vector/array.
signals = as.matrix(t(medians[ - (1:3) ]), dimnames = NULL)
dimnames(signals) = NULL

 #  Now merge the lines.js script into the SVG file and also the
 #  dump the R objects as Javascript variables.
addECMAScripts(doc, "lines.js", accessPoints = accessPoints, signals = signals, insertJS = TRUE)

  # Now save the document to a file and we are read to view it.
saveXML(doc, "foo.svg")

# doc = xmlParse("building.svg")
# mapply(addToolTips, getPlotPoints(doc), tips)
