varNames =
function(dir = ".")
{
  ff = list.files(dir, full = TRUE, pattern = ".txt$")
  unique(basename(gsub("[0-9]+\\.txt$", "", ff)))
}

readNASAData =
function(dir = ".")  
{
  dir = paste(dir, .Platform$file.sep, sep = "")
  varNames = unique(gsub("[0-9]{1,2}.txt", "", list.files(dir, pattern = ".txt$")))

  d = lapply(varNames,
              function(var) {
                        # Could look for the   files = list.files(pattern = paste("^", var,"[0-9]{1,2}.txt" sep = ""))
                   files = paste(dir, .Platform$file.sep, var, 1:72, ".txt", sep = "")
                   unlist(lapply(files, function(f) {
                                          d = read.table(f, skip = 7, na.strings = "....")
                                          d = unlist(d[, -(1:3)])
                                        }))
            
         })

   d = as.data.frame(d)
   names(d) = varNames
  
   d$longitude = rep(seq(113.75, by = -2.5, length = 24), rep(24, 24))
   d$latitude = rep(seq(36.25, by = -2.5, length = 24), nrow(d)/24)

   dates = sapply(paste(dir, .Platform$file.sep, "cloudhigh", 1:72, ".txt", sep = ""),
                  function(f) {
                    tmp = readLines(f, n = 5)[5]
                    as.POSIXct(strptime(gsub(".* :", "", tmp), " %d-%b-%Y %H:%M"))
                  })

   d$date = rep(dates, rep(24*24, 72) )
   class(d$date) = c("POSIXt", "POSIXct")
  
   d
}

if(FALSE) {
  nasa = readNASAData("~/NASA/Files")
  tmp = read.table("intlvtn.dat", header = TRUE)
  elevation = as.matrix(tmp)
  dimnames(elevation) <-  list(rownames(tmp), gsub("X\\.", "", colnames(tmp)))
}


if(FALSE) {
levelplot(temperature ~ longitude * latitude | months(date), nasa)
}
