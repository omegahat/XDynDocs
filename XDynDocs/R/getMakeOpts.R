trim =
function(x)
{
  gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)
}

splitParams =
function(vals)
{
  p = trim(strsplit(vals, "-(stringparam|param)")[[1]])
  p = p[ p != ""]
  tmp = strsplit(p, " ")
  ans = sapply(tmp, function(x) paste(x[-1L], collapse = " "))
  structure(ans, names = sapply(tmp, `[`, 1L))
}

getOptions =
function(w) {
  dbk = system(sprintf("make -f inst/Make/Makefile show%sOpts", w), intern = TRUE)
  splitParams(dbk)
}  

makeOptions =
function(opts = c("DB", "FO"), out = "R/XSLOpts.R")
{  
  params = lapply(opts, getOptions)
  names(params) = sprintf("XSL_%s_Opts", opts)

  if(length(out)) {
    con = file(out, "w")
    on.exit(close(con))
    mapply(function(id, x) {
              cat(id, "<-", file = con)
              dput(x, con)
              cat("\n", file = con)
            }, names(params), params)
  }
  
  invisible(params)
}

  

