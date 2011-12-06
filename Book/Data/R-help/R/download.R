downloadArchive =
function(url = "https://stat.ethz.ch/pipermail/r-help/",
         gzFiles = getArchiveFileList(url))
{
   dir.create("../data")
   downloadWGet(gzFiles, url)
}

readArchiveLinks =
function(url, pattern = NA)
{
  content = getURLContent(url,  ssl.verifypeer = FALSE)
  doc = htmlParse(content, asText = TRUE)
  links = getNodeSet(doc, "//a/@href")
  if(is.na(pattern))
    links
  else
    grep(pattern, unlist(links), value = TRUE)
}

getArchiveFileList =
function(url)
{
  readArchiveLinks(url, "\\.txt\\.gz$")
}  
         

downloadWGet =
function(gzFiles, url)
{
 files = gzFiles
 i = grep("^http", gzFiles)
 url = gsub("/$", "", url) 
 if(length(i) == 0)
    files = paste(url, gzFiles, sep = "/")
 if(length(i) < length(files))
    files[ - i] = paste(url, files[ - i], sep = "/")

 sapply(paste("wget --no-check-certificate -P ../data ", files, sep = ""), system)
}


downloadContent =
function(gzFiles, url)
{
   mapply(function(src, target) {
            #download.file, paste(url, gz, sep = "")
           writeBin(getURLContent(src, ssl.verifypeer = FALSE), target)
          },
          paste(url, gzFiles, sep = ""),
          paste("../data", gzFiles, sep = .Platform$file.sep))
}

downloadThread =
function(url = "https://stat.ethz.ch/pipermail/r-help/",
         files = readArchiveLinks(url, "thread.html$"))
{
   dir.create("../data")
   downloadWGet(files, url)
}
