library(XML)

useStyle = TRUE

if(!exists("temperature") || class(temperature) != "data.frame") {
   # This version has intentional errors.
  load(url("http://eeyore.ucdavis.edu/stat32/Data/Temperature.rda"))
  temperature$level = cut(temperature$temp, 4)
}

  # Generate some colors to use to represent the different levels of temperature
temperatureColors = rev(rainbow(length(levels(temperature$level))))


  # Create the KML document
tt = xmlTree("kml", namespaces = c("http://earth.google.com/kml/2.1"))
tt$addTag("Document", close = FALSE)

   # Put a little HTML description of what we are displaying.
tt$addTag("description",
           'Illustrates the temperatures of 50 different cities at 4 different times of the year.\nGenerated from R by <a href="http://www.stat.ucdavis.edu/~duncan">Duncan Temple Lang</a>')

  # A top-level, global style to which we can refer within Placemarks, etc.
if(useStyle) {
 tt$addTag("Style", attrs = list(id = "me"), close = FALSE)
    tt$addTag("IconStyle", close = FALSE)
      tt$addTag("scale", .35)
      tt$addTag("color", "#FFFF0000")
      tt$closeNode()
    tt$addTag("LabelStyle", close = FALSE)
    tt$addTag("scale", 1)
           # note the alpha-blue-green-red order
      tt$addTag("color", "#FFFFFF00")
      tt$closeNode()
 tt$closeNode() 
}

f =
  #
  #  loop over the cities and process each of the specified
  #  months
  #
  #
function(showImages = FALSE, style = "me", months = levels(temperature$month))
{
 invisible(
  by(temperature, temperature$city,
     function(city) {

       name = strsplit(city[1, "city"], ",")[[1]][1]
       tt$addNode("Folder", close = FALSE)
       tt$addNode("name", name)
       
       by(city, city$month,
           function(row) {

                 tt$addNode("Placemark", attrs = c(id = row[1, "city"]), close = FALSE)
                   mnth = as.character(row[1, "month"])
                   label = if(length(months) > 1) paste(row[1, "temp"], mnth) else row[1, "temp"]
                   tt$addNode("name", label)

                 if(showImages) {
                   tt$addTag("IconStyle", close = FALSE)
                      tt$addTag("Icon", close = FALSE)
                        tt$addTag("href", imageName(city[1, "city"]))
                      tt$closeNode()                 
                   tt$closeNode()
                 } else {
                   tt$addNode("styleUrl", paste("#", style, sep = ""))                   
                 }
                 
                 tt$addNode("TimeStamp", close = FALSE)
                   tt$addNode("when", paste("1997", sprintf("%02d", match(mnth, month.name)), sep = "-"))
                   #tt$closeNode()
                 tt$closeNode()
                 
                 if(length(months) > 1) {
                       # we don't need the table now that we have 
                   desc = list(name,
                               "<table>",
                               c("<tr>", paste("<td>", months, "</td>", sep = ""), "</tr>"),
                               c("<tr>", paste("<th>", city$temp, "</th>", sep = ""), "</tr>"),
                               "</table>",
                               c("<img src='", imageName(city[1, "city"], mini = TRUE), "'>"))
                   desc = paste(sapply(desc, paste, collapse = ""), collapse = "\n")
                   tt$addNode("description", close = FALSE)
                      tt$addCData(desc)
                   tt$closeNode() # description
                 } else {
                   desc = paste("Temperature for", city, row["temp"], "in", mnth)
                   tt$addNode("description", desc)
                 }
                 tt$addNode("Point", close = FALSE)
                    tt$addNode("coordinates", paste(- as.numeric(row["longitude"]),  row["latitude"], sep = ", "))
                 tt$closeNode() # Point
                 tt$closeNode() # Placemark         # should be one closeTag(2)                 
           })


               # Ground Overlay to show the time series curve of temperature across the 4 months.
       tt$addNode("GroundOverlay", close = FALSE)
         tt$addNode("name", city[1, "city"])       
         tt$addNode("Icon", close = FALSE)
           tt$addNode("color", "#88FFFFFF")
           tt$addTag("href", imageName(city[1, "city"]))
           tt$closeNode()
         tt$addNode("LatLonBox", close = FALSE)
           off = c(.5, .5)*3
           loc = as.numeric(city[1, c("longitude", "latitude")])
           box = c(north = loc[2] + off[2], south = loc[2] - off[2],
                   east = -loc[1] + off[1], west = -loc[1] - off[1])
           sapply(names(box), function(i) tt$addNode(i, box[i]))
         tt$closeNode() # LatLonBox
       tt$closeNode() # GroundOverlay

       tt$closeNode() # Folder
   })
 )
}

f()

 # Create the screen overlay that will display the legend in the lower left corner.
 # The legend should have no margins in R.
tt$addNode("ScreenOverlay", close = FALSE)
  tt$addNode("name", "Temperature legend")
  tt$addNode("Icon", "/tmp/legend.png")
  tt$addNode("screenXY", attrs = c("x" = 2, "y" = 2, xunits = "pixels", yunits = "pixels"))
  tt$addNode("overlayXY", attrs = c("x" = 0, "y" = 0))
  tt$addNode("size", attrs = c("x" = 300, "y" = 300, xunits = "pixels", yunits = "pixels"))
tt$closeNode()  # ScreenOverlay

tt$closeNode()  # KML root node

saveXML(tt, "/tmp/doc.kml")
system("open /tmp/doc.kml")
