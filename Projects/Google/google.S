google =
function(query, n = -1, verbose = FALSE)
{
 con = socketConnection("www.google.com", 80, open = "w+", blocking=TRUE)
 if(!is.logical(n) || n)
   on.exit(close(con))

 query = htmlSubstituteCharacters(query)

 cmd = paste("GET /search?hl=en&ie=ISO-8859-1&oe=ISO-8859-1&q=", query, "&btnG=Google+Search", " HTTP/1.1\r\n", sep="")
 cat(cmd, file = con)

 cat("Host: www.google.com\r\n", file = con)
 cat("\r\n", file = con)

 
 if(is.logical(n) && !n)
   return(con)

 processHTTPResponse(con, n, verbose)
}

readHeader =
function(con)
{
   # read the header first to get information about the transfer
 header = character()
 while(TRUE) {
   tmp = readLines(con, n = 1)
   if(tmp == "")
     break

   header = c(header, tmp)
 }


 tmp = strsplit(header, ":[ \t]+")
 header  = sapply(tmp, function(x) paste(x[-1], sep=": "))
 names(header)  = sapply(tmp, function(x) x[1])

 header
}

processHTTPResponse = 
function(con, n = -1, verbose = FALSE)
{
 header = readHeader(con)

  # If the content is chunked, need to handle this by reading that many bytes
 if("Transfer-Encoding" %in% names(header) && header[["Transfer-Encoding"]] == "chunked") {
   val = readChunks(con, verbose)
 } else {
    # Alternatively, just read the lines until an EOF (end of file).
   val = readLines(con, n = n-7)
 }

 attr(val, "header") = header

 val
}

readChunks =
#
#
#
function(con, verbose = TRUE) 
{
  txt = character(0)

  while(TRUE) {
    l = readLines(con, n = 1)
    if(l == "")
      l = readLines(con, n = 1)

    if(length(l) == 0)
      break

    size = fromHEX(l)

    if(size > 0) {
      if(verbose)
        cat("Reading", size, "bytes", l, "\n")

      tmp = readNumBytes(con, size, verbose)
      txt = c(txt, tmp)
    } else
       break
  }

  invisible(txt)
}

readNumBytes =
function(con, numBytes, verbose = TRUE) 
{
 numRead = 0
 txt = character()

 while(numRead < numBytes) {
   x = readLines(con, n = 1)
   numRead = numRead + nchar(x) + 1 # extra one for the \r in \r\n that is dropped?

   if(verbose)
      cat("Num read", nchar(x), " total", numRead, "of", numBytes, "\n")

   if(nchar(x) == 0)
      break

   txt[length(txt)+1] = x
  }

  if(verbose)
   cat("# characters read", sum(nchar(txt)), "in", length(txt), "lines", "\n")

 txt

# paste(txt, collapse="\n")
}


fromHEX =
function(val)
{
  if(length(val) < 1)
    return(integer())

   # Break the elements of the string into individual elements
   # e.g. cb5 into  "c", "b", "5"
  els = tolower(substring(val, 1:nchar(val), 1:nchar(val)))

   # Now create the generic map of the digits 0, 1, 2, .., 9, a, b, c, d, e, f
   # to decimal
  d = 0:15
  names(d) = c(0:9, letters[1:6])


   # map the actual hexadecimal digits to decimal
  els = d[els]

   # Now add up the elements
  sum((16^c((length(els)-1):0))*els)
}



HTMLCharacterSet = 
c(
 " " = "20",
 "/" = "2F",
 "+" = "2B",
 "$" = "24",
 "'" = "27",
 "(" = "28",
 ")" = "29",
 "\"" = "22",
 "%" = "25",
 "|" = "7C"
)

htmlSubstituteCharacters =
#
# Convert special characters in an HTML query 
# to their Hexadecimal equivalents.
#
function(cmd, characterSet = HTMLCharacterSet)
{
  els = substring(cmd, 1:nchar(cmd), 1:nchar(cmd))

  idx = match(els, names(characterSet))
  els[!is.na(idx)] = paste("%", characterSet[idx[!is.na(idx)]], sep="")

  paste(els, collapse="")
}
