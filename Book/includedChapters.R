getIncludeChapters =
function(doc = "chapterS08.tex", asDir = TRUE, removeTop = TRUE)
{  
  txt = readLines(doc)
  inputs = grep("\\\\input", txt, val = TRUE)
  ins = gsub(".*\\{([^}]+)\\}.*", "\\1", inputs)
  if(!asDir)
    return(ins)
  
  chaps = dirname(ins)
  if(removeTop)
    chaps = chaps[ chaps != "." ]
  chaps
}

getDirectories =
function(dir = ".")
{
   info = file.info ( list.files(dir) )
   rownames(info[info[, "isdir"], ])
}

if(FALSE) {
 chaps = getIncludeChapters()
 table(chaps)

 dirs = getDirectories()
 setdiff(dirs, chaps)
}
#
#


