TargetExtensions =
 list(fo = c("fo", "pdf"),
      html = "html",
      db = "Rdb",
      docbook = "Rdb",
      tex = c("tex", "pdf"),
      latex = c("tex", "pdf"))

makeTargetFileNames =
  # The idea is that the caller of dynDoc() or whatever, gives us the name of the output file.
  # That might be a .tex, .html, .Rdb, .db, .xml or .fo or .pdf.
  # We strip the extension and then add the extensions for the specified target.
  # This gives us the intermediate files as well as the target.
  # If the caller gave us an intermediate file as the target, then we just return that
  # The caller of this function will get back just one file and should not  proceed to
  # try to generate the derived file from this intermediate file. For example, if the say
  #  foo.fo, we return foo.fo and not c(foo.fo, foo.pdf).
  # 
function(out, target)
{
  if(inherits(out, "AsIs"))
    return(out)
  
  orig = out

  stub = gsub("(.*/)?\\.[^./\\\\]+$", "\\1", out)
  exts = TargetExtensions[[tolower(target)]]
  if(is.null(exts))
     stop("Unsupported target ", target)
  
  ans = sprintf("%s.%s", stub, exts)
  if(ans[1] == orig)
    ans[1]
  else
    ans
}

