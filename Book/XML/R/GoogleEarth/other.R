a = function() {
apply(subset(temperature, month == "July"), 1,
       function(row) {
         city = strsplit(row[1, "city"], ",")[[1]][1]
               #xxxx why attrs has to be a list, not a character vector!
         tt$addNode("Placemark", attrs = list(id = row[1, "city"]), close = FALSE)
         tt$addNode("name", city)
         tt$addNode("description", paste("Summer temperature for", city, row["temp"]))
         tt$addNode("Point", close = FALSE)
         
#         tt$addNode("coordinates", paste(row[c("latitude", "longitude")], collapse = ", "))         
#         tt$addNode("coordinates", paste(row["latitude"], - as.numeric(row["longitude"]), sep = ", "))
         tt$addNode("coordinates", paste(- as.numeric(row["longitude"]),  row["latitude"], sep = ", "))
         tt$closeNode(num = 2)
       })
}

b = function(months = levels(temperature$month)) {

#                if(length(months) > 1) {
#                    # perhaps have all the information.
#                  paste("<table>",
#                        c("<tr>", paste("<td>", months, "</td>", sep = ""), "</tr>"),
#                        c("<tr>", paste("<td>", months, "</td>", sep = ""), "</tr>")                         
#                }

  
invisible(
sapply(months,
       function(mnth) {
         apply(subset(temperature, month == mnth), 1,
               function(row) {
                 city = strsplit(row["city"], ",")[[1]][1]
               #xxxx why attrs has to be a list, not a character vector!
                 tt$addNode("Placemark", attrs = list(id = row[1, "city"]), close = FALSE)
                 label = if(length(months) > 1) paste(row["temp"], mnth) else row["temp"]
                 tt$addNode("name", label)
                 tt$addNode("TimeStamp", close = FALSE)
                   tt$addNode("when", paste("1997", sprintf("%02d", match(mnth, month.name)), sep = "-"))
                   tt$closeNode()
                 desc = paste("Temperature for", city, row["temp"], "in", mnth)
                 tt$addNode("description", desc)
                 tt$addNode("Point", close = FALSE)
         
#         tt$addNode("coordinates", paste(row[c("latitude", "longitude")], collapse = ", "))         
#         tt$addNode("coordinates", paste(row["latitude"], - as.numeric(row["longitude"]), sep = ", "))
                 tt$addNode("coordinates", paste(- as.numeric(row["longitude"]),  row["latitude"], sep = ", "))
                 tt$closeNode(num = 2)
               })
       }))
}
