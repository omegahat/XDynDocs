readTrace = 
function(f = "offline.final.trace.txt", txt = readLines(f, n = n)[-(1:3)], n = -1)
{
    # remove the comment lines
  i = grep("^#", txt)
  if(length(i))
     txt = txt[ - i ]
  
  txt = txt[ txt != ""]

    # break the lines into the primary components separated by ;
  els = strsplit(txt, ";")
    # find out how many signal strengths we have for each record, i.e the number of responders/receivers.
  numMacs = sapply(els, length) - 4

    # now grab the signal strengths and from who
    # End up with a list each whose elements is a matrix consisting of rows
    # of the form:   mac  signal  channel  type
    # with as many rows as there signals detected at that position, orientation and time.
    # That's our data.
    # Note that we split the mac and the values in one go using a regular expression.
  macs = lapply(els, function(x) {
                            macs = x[-(1:4)]   # drop the first four elements
                            if(length(macs) == 0)
                               return(matrix(NA, 0, 4))
                                                      #  "(=|,)"
                            matrix(unlist(strsplit(macs, "[=,]")), , 4, byrow = TRUE)
                          })

  
#  macs = macs[numMacs > 0]
#  numMacs = numMacs[numMacs > 0]

  time = sapply(els, function(x) strsplit(x[1], "=")[[1]][2])
  id = sapply(els, function(x) strsplit(x[2], "=")[[1]][2])
     # x y and z
     # matrix with 3 rows (x, y, z) and n = length(txt) columns
  pos = sapply(els, function(x) { strsplit(gsub("pos=", "", x[3]), ",")[[1]] })
  
  ans = as.data.frame(do.call("rbind", macs))
  names(ans) = c("mac", "signal", "channelFrequency", "mode")  
  ans$time = rep(time, numMacs)
  ans$id = rep(id, numMacs)
  ans$x = rep(as.numeric(pos[1,]), numMacs)
  ans$y = rep(as.numeric(pos[2,]), numMacs)
  ans$orientation = rep(as.numeric(gsub("degree=", "", sapply(els, function(x) x[4]))), numMacs)  

  ans$signal = as.numeric(as.character(ans$signal))
  ans$channelFrequency = as.numeric(as.character(ans$channelFrequency) )
  ans$orientationLevel = roundOrientation(ans$orientation)
  
  tmp = c("adhoc" = "1", "access_point" = "3")
  levels(ans$mode) = names(tmp)[ match(levels(ans$mode), tmp) ]


  if(FALSE) {
     #data.frame(time = time, id = id, x = pos[1,], y = pos[2,], z = pos[3,],
     #           orientation = as.numeric(gsub("degree=", "", sapply(els, function(x) x[4]))),
     #             numResponers = numMacs,
     #           macs = I(macs))
  }
  
  ans
}


 # These are eyeballed off the map
 #  should be able to get from the paper or from a ruler and the map
 # or by back projecting from 
AP =
matrix(c(1, 14,
         2.5, -.8, 
         7.5, 6.5,
         13, -2.8,
          33.5, 2.8,
          33.5, 8.3), , 2, byrow = TRUE,
          dimnames = list(c("00:14:bf:b1:97:90",
                            "00:14:bf:b1:97:8a",
                             "00:0f:a3:39:e1:c0",
                             "00:14:bf:3b:c7:c6",
                             "00:14:bf:b1:97:81",
                             "00:14:bf:b1:97:8d" ),
                           c("x", "y")))

# Lookup Vendor-Mac prefix mapping at
#   http://www.coffer.com/mac_find
# There is no Lancom
if(FALSE) {
 sapply(levels(off$mac),
        function(m) {
             txt = getForm("http://www.coffer.com/mac_find/", string = m, submit = "string")
             doc = htmlParse(txt, error = function(...){})
             ans = xmlValue(getNodeSet(doc, "//a")[[2]])
             if(ans == "How to find/display your MAC Address")
                NA
             else
                ans
        })
} 

# is 97:8a at the top left?


roundOrientation = 
function(x)
{
  refs = seq(0, by = 45, length  = 9)
  q = sapply(x, function(o) which.min(abs(o - refs)))
  c(refs[1:8], 0)[q]
}


if(FALSE) {
 off = readTrace("~/NetworkData/mannheim/offline.final.trace.txt")
 on = readTrace("~/NetworkData/mannheim/online.final.trace.txt")

      # plot the information with the offline and online data points and the access
      # points.
 plot(off$x, off$y, xlim = range(c(off$x, AP[,1])), ylim = range(c(off$y, AP[,2])))
 points(AP, pch = rownames(AP), fg = "red", cex = 2, col = "red")
 symbols(on$x, on$y, circles = rep(.1, length(on$x)), bg = "blue", add = TRUE, inches = FALSE)

    # The number of unique points
 p = paste(off$x, off$y, sep = ",")
 length(unique(p))
    # How many observations at each point.
 nums = by(off, paste(off$x, off$y, sep = ","), nrow)

    # Broken down by orientation.
 nums = by(off, paste(off$x, off$y, sep = ","), function(x) by(x, x$orientationLevel, nrow) )

 table(off$mac)


   # To turn this into a data frame with
   # x, y, orientation, S1, ..., S6
   # First get the rows that correspond to the base stations
   # Time is unique. So
 
 i = as.character(off$mac) %in% rownames(AP)
 sub = off[i, ]
 sub$mac = factor(as.character(sub$mac))
 station.ids = rownames(AP)

 clpse = with(sub, by(sub, paste(x, y, orientationLevel, sep = ","),
                      function(x) {
                        ans = data.frame(x = x$x[1], y = x$y[1], orientationLevel = x$orientationLevel[1])
                        tmp = tapply(x$signal, x$mac, mean, na.rm = TRUE)
                        ans[names(tmp)] = tmp
                        ans[paste("n", names(tmp), sep = ".")] = tapply(x$signal, x$mac, function(x) sum(!is.na(x)))    
                        ans
                      }) )

 clpse = do.call("rbind", clpse)
 
  tmp = data.frame(signal = unlist(clpse[, 4:9]), n = unlist(clpse[, 10:15]), mac = rep(names(clpse)[4:9], each = nrow(clpse)))

  bb = paste(sub$x, sub$y, sub$orientationLevel, sep = ",")
  w = sample(bb, 1)


  tmp1 = sub[ x == 9 & y == 3 & orientationLevel == 180, ]
  tapply(tmp1$signal, tmp1$mac, mean, na.rm = TRUE)
 

   # Now we can 
 sigs = by(sub, sub$time,
                     function(x) {
                           # within this time, reorder the signals based on station.ids
                       idx = match(station.ids, x$mac)
                       x$signal[idx]
                   })
 sigs1 <- do.call("rbind", sigs)

  # An alternative approach is to recognize that sub
  # has the data group by the same times for each
  # of the 6 macs of interest.
  # We have a different number of them for different macs however.
system.time({ 
 nsigs = tapply(sub$signal, as.character(sub$mac), function(x) length(x))

 numObs = length(unique(sub$time))
 ans = replicate(length(station.ids), rep(as.numeric(NA), numObs), simplify = FALSE)
 ans = as.data.frame(ans)
 names(ans) = paste("S", 1:length(station.ids), sep = "")
 rownames(ans) = unique(sub$time)

 system.time(invisible(sapply(seq(along = station.ids),
         function(i)  {
            w =  as.character(sub$mac) == station.ids[i]
            ans[sub$time[w], i] <<- sub$signal[w] 
         })))
        
# tapply(sub, as.character(sub$mac), function(x) length(x))
}
            
  # There are some times where we end up with more than one measurement
  # for the same base station.
   # e.g. t = 1139655586922, has values 00:14:bf:b1:97:90 of -43 and -42.
 
 txt = readLines("offline")
 txt = txt[ - grep("^#", txt) ]
   # put the time as an index for the txt vector.
 names(txt) = gsub("^t=([0-9]+);.*", "\\1", txt)

 i = sample(rownames(ans), 4)
 
 ans[i[1], ]
 txt[i[1]]
 
}




pdist = sub[, c("x", "y")] - AccessPointLocations[ as.character(sub$mac), ]
pdist = rowSums(pdist^2)
plot(sqrt(pdist), sub$signal)
