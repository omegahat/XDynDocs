fop =
  # invoke the fop processor on the specified file.
function(file, fop = getOption("FopExec", FopExec), fopArgs = character())
{
  if(is.na(fop))
     stop("no setting for the FOP executable")

  if(!file.exists(fop)) 
     stop("The file ", fop, " does not exist so cannot run FOP")

  out = c(file, gsub("fo$", "pdf", file))
  fopCmd = paste(fop, paste(fopArgs, collapse = " "), out[1], out[2])
  system(fopCmd) == 0
}
