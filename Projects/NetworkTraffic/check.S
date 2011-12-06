extra =
function(x) {
  fields = character()

  extra = 
  function(x) {
    z = xmlValue(x[["Extra"]])
    field = xmlValue(x[["Field"]])

    if(is.null(z) || z == "") {
      warning("Missing documentation in ", field)
      return(x)
    }
    fields[field] <<- z
    
    x
  }
  list(row = extra, vals = function() fields)
}

