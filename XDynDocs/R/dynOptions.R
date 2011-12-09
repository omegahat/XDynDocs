capitalize =
function(x)
{
  paste(toupper(substring(x, 1, 1)), substring(x, 2), sep = "")
}

getTargetFormatClass =
function(x)
{
  return(getTargetFormat(x))
#XXXX kill of the rest
  k = paste(x, "Target", sep = "")
  if(is.null(getClassDef(k))) 
      k = paste(capitalize(x), "Target", sep = "")

  new(k)
}

DynamicOptions =
  # Create an instance of a DynamicDocContext (or subclass)
  # and copy the arguments from ... by matching the names
  # to slots and performing the conversion to the appropriate
  # type. This is a user-friendly way to write a constructor
  # function. The user can specify the class of interest or
  # provide an existing instance to be filled in.
function(target, ..., env = dynDocsEnv(), obj =  new(.class), .class = "DynamicDocContext")
{
 obj@targetFormat = getTargetFormatClass(target)

 args = list(...)

 ignored = character()
 slots = getSlots(class(obj))
 for(i in names(args)) {
     w = pmatch(i, names(slots))
     if(is.na(w))
        ignored = c(ignored, i)
     else {

        if(names(slots)[w] == "device" && is.character(args[[i]])) {
              # take "SVG" or c(SVG = "devSVG")
           args[[i]] = structure(list(get(args[[i]], mode = "function")),
                                   names = if(length(names(args[[i]])))
                                              names(args[[i]])
                                           else
                                               args[[i]])
        }
       
        slot(obj, names(slots)[w]) <- as(args[[i]], slots[i])
     }
     
 }
 obj@env = env
 
 if(length(obj@name) == 0)
   obj@name = "original"

 if(!("width" %in% names(args))) 
    obj@width = getOption("width", 72)


# cat("DynamicOptions(): width", obj@width, "\n")

 if(length(ignored)) 
   warning(simpleWarning("ignoring arguments to DynamicOptions: ", paste(ignored, collapse = ", "),
                         class = "IgnoredArguments",
                          ignored = ignored, functionName = "DynamicOptions"))  
  obj
}


.getDynOption =
function(val = character(), simplify = TRUE)
{
  if(length(convertStack) == 0)
     opts = new("DynamicDocContext")
  else
     opts = convertStack[[1]]

  if(length(val) == 0)
    return(opts)

  slots = slotNames(opts)
  ans = lapply(val, function(x) {
                       if(x %in% slots)
                         slot(opts, x)
                       else
                         slots@other[[x]]
                    })
  if(simplify && length(ans) == 1) #XXX
    ans[[1]]
  else
    ans
}  

setNodeOptions =
    # This takes the attributes from the XML node r:dynOptions and 
    # populates the target object which is of class 'DynamicDocContext',
    # or more specifically a derived class of that.
    # It handles the case where some of the attributes have a prefix that identify
    # a particular target format.
function(node, target) 
{
  opts = xmlAttrs(node)
  ns = attr(opts, "namespaces")
  slots = slotNames(target)  

  setOpt =
    function(id, val) {
        if(id %in% slots)
           slot(target, id) <<- as(val, class(slot(target, id)))
        else
           target@other[[id]] <<- val
    }
  
  if(!is.null(ns)) {
        # so some of the attributes have a prefix, e.g. fo: or html:
        # process the general (non-prefixed) ones first, then the specific
        # ones for the current target.
    
     is.generic = ns == ""
     mapply(setOpt, names(opts)[is.generic], opts[is.generic])

       # now get the ones that match this particular target.
       # Should use URIs rather than prefixes. But for now....
     targetPrefix = tolower(gsub("Target$", "", class(target@targetFormat)))
     for.target = ns == targetPrefix
     mapply(setOpt,  names(opts)[for.target], opts[for.target])
     
  } else  # set them all as there are no prefixes on the attribute names.
    mapply(setOpt, names(opts), opts)

  target
}

pushDynDocOptions =
  # push some of the options in a DynamicDocContext into R's options.
function(opts)
{
   ropts = names(options())
   slots = slotNames(opts)
   slots = slots[slots %in% ropts]

# cat("Setting width option from ", getOption("width"), "to", opts@width, "\n")
   do.call("options", structure(lapply(slots, function(id) slot(opts, id)), names = slots))
   length(slots)
}

popDynDocOptions =
function()
{
  tmp = convertStack[[2]]
  convertStack <<- convertStack[-1]
#cat("popping r:dynOptions", tmp@name, ", # options on stack", length(convertStack), "\n")
  XDynDocs:::pushDynDocOptions(tmp)
  TRUE
}
# There is a tension here between (multi-method) dispatching and
# closures. Perhaps R.oo would help, but that doesn't use multi-method
# dispatch.

setDynDocOptions =
  #
  #  Called from the start of an r:dynOptions node to set the 
  #  options for the dynamic document processor for a collection of
  #  sub-nodes.
function(node, target, env = NA)  
{
  if(FALSE && length(convertStack) > 0) {
     tmp = convertStack[[1]]
  } else {
     # tmp@targetFormat = 
     tmp = DynamicOptions(target)  # new(paste(target, "Target", sep = "")))
     #tmp = new("DynamicDocContext")
         # isn't target already what we want here.

  }

  if(is.na(env))
    if(length(convertStack))
       env = convertStack[[1]]@env
    else
       env = dynDocsEnv()

   tmp@env = env
  
    # set the options
  if(inherits(node, "XPathNodeSet"))
     node = node[[1]]
  #XXX recursive? Infinitely. No, need to call function named differently in other environment
  tmp = XDynDocs:::setNodeOptions(node, tmp) # , tmp@targetFormat)
  XDynDocs:::pushDynDocOptions(tmp)
  convertStack <<- c(tmp, convertStack)


  TRUE
}









######################
#
# This sets R's options, not dynamic options.
#
#
processOptions =
  #
  #
  # This takes options from an r:code node or a similar r: node such as r:plot
  # and sets them. It returns the old values of the options so they can be restored.
  # Handle child nodes, not just attributes for richer content.
  #
  #  Allow new options that don't match existing names
function(node, allowUmatched = FALSE)
{
  atts = xmlAttrs(node, FALSE, TRUE)  # Want to have the namespace definitions, but not the prefixes.
  
  nsDefs = names(attr(atts, "namespaces"))

  atts = atts[ nsDefs %in%  c("http://www.r-project.org", "http://www.r-project.org/options")]

  
  i = match(names(atts), names(options()))

  ids = names(atts)[ !is.na(i) ]

  if(length(ids)) {
    opts = options()
    tmp = lapply(ids, function(id) as(atts[id], class(opts[[id]])))
    names(tmp) = ids
    old = options()
    options(tmp)
    old
  } else
    NULL

#  setOptions(node, "FO")  
#  ids
}
