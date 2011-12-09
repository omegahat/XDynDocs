
getThread =
  # Get all the thread.
  # th = getThread("~/Classes/StatComputing/XDynDocs/tests/threadGroup.Rdb", "OLS")
  #
  # Here we get the OLS thread but discard the "optional" removeOutliers.
  #   th = getThread("~/Classes/StatComputing/XDynDocs/tests/threadGroup.Rdb", "OLS", excludeGroups = "removeOutliers")

  function(doc, id, includeGroups = character(), excludeGroups = character())
{
  if(is.character(doc))
      doc = xmlParse(doc)

  xp = sprintf("//task[@thread = '%s'] | //task[not(@thread)]", id)
  nodes = getNodeSet(doc, xp)

  if(length(includeGroups) || length(excludeGroups)) {
    groups = lapply(nodes, getGroupIds)

    if(length(excludeGroups)) {
       i =  sapply(groups, function(x) if(length(x) == 0) FALSE else any(x %in% excludeGroups))
       nodes = nodes[!i]
       groups = groups[i]
    }

    if(length(includeGroups)) {
       i =  sapply(groups, function(x) if(length(x) == 0) TRUE else any(x %in% includeGroups))
       nodes = nodes[i]
    }    
  }
  
  nodes
}

getGroupIds =
  # Get the vector of group ids for each node, with character() if none.
function(x)
{
   xmlGetAttr(x, "groups", character(), function(x) strsplit(x, ",")[[1]])
}


addNodeThreadId =
  #
  # This puts a thread attribute on nodes that do not have one.
  # This therefore allows us to do computations with thread attributes on
  #  r:code, r:plot, etc. elements
  #
  # addNodeThreadId("~/Classes/StatComputing/XDynDocs/tests/nestedTask.Rdb")
  #
function(doc, xpathEls = c("//r:code", "//r:function", "//r:plot", "//r:expr"))
{
  if(is.character(doc))
      doc = xmlParse(doc)

    # get all the elements which do not have a thread attribute but which are in a task
    # node which does have a thread attribute.
  xp = paste(xpathEls, "[not(@thread) and ancestor::task[@thread]]", collapse = " | ")

  nodes = getNodeSet(doc, xp, "r")

  if(length(nodes)) {
    mapply(function(node) {
             #xp = paste(xpathEls, "[not(@thread) and ancestor::task[@thread]]/ancestor::task[@thread]", collapse = " | ")
              xp = "./ancestor::task[@thread]/@thread"
              ids = unlist(getNodeSet(node, xp, "r"))
              xmlAttrs(node) = c(thread = as.character(ids)[length(ids)])
           }, nodes)
  }

  doc
}
