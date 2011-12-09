#
# We'll probably write a package that links against the C++ code in 
# the highlight distribution.
# This will avoid lots of files, spawning processes and also potentially
# give us more control over aspects of the formatting, e.g.
#  how the links are computed
#
if(FALSE) {
setGeneric("formatCode",
           function(doc, out = "-", format = "html", isText = inherits(doc, "AsIs") || !file.exists(doc), ...)
              standardGeneric("formatCode"))

setMethod("formatCode", "character",
function(doc, out = "-", format = "html", isText = inherits(doc, "AsIs") || !file.exists(doc), ...)
{
#  browser()
  direct = missing(out)
  if(isText) {
     tmp = tempfile()
     cat(doc, file = tmp, sep = "\n")
     doc = tmp
  }

  ans = highlight(doc, out, format)

  if(out == "-")
    ans
  else
    out
})

setMethod("formatCode", "function",
function(doc, out = "-", format = "html", isText = inherits(doc, "AsIs") || !file.exists(doc), ...)
{
  con = textConnection(NULL, "w", local = TRUE)
  on.exit(sink())
  sink(con)
  print(con)
  sink()
  on.exit()
  formatCode(textConnectionValue(con), out, format, TRUE)
})
}

highlight =
function(input, output, format = "html", extraArgs = "", ...)  
{
  if(output != "-")
    output = paste("-o", output)
  else
    output = ""
  cmd = sprintf("highlight -S R --%s %s %s %s", format, output, extraArgs, input)
  system(cmd, intern = TRUE, ...)
}
