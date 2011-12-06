#
# The idea here is to start with one or more URLs
#

traverseLinks =
function(urls, max = -1, filter = dropLink()$dropLink, processURL = processURLLinks)
{
   # list in which we collect the results.
  allLinks = list()
   # character vector in which we collect the URIs which resulted in an error when parsing.
  errors = character()

   # Turn the URLs to get us started into regular strings. This means we can start
   # with URIs.
  toBeProcessed = sapply(urls, function(x) toString.URI(URI(urls)))

    # Go into a dynamic loop that monitors the queue.
  while(length(toBeProcessed)) {

       # Take the first element of the queue.
     u = toBeProcessed[1]
       # parse it using the function given by processURL.
     forwardLinks = try(processURL(u))

       # if we get an error, add it to the errors vector and
       # remove it from the queue.
     if(inherits(forwardLinks, "try-error")) {
       errors = c(errors, u)
       toBeProcessed = toBeProcessed[-1]
       next
     }
    
       # Put these in the results. 
     allLinks[[u]] = forwardLinks          


       # Run the results through user-defined filter
       # to allow discarding some. 
     if(!is.null(filter)) {
           # Todo: Handle expressions also.
       tmp = as.character(sapply(forwardLinks, filter))
       forwardLinks = tmp[!is.na(tmp)]
     }     
     
       # Now clean up the links in the URI so that we can add them to the queue.
       # Check to see if any of them are
       #    a) already processed
       # or b) already in the queue.
     idx = match(forwardLinks, c(names(allLinks), toBeProcessed))
     forwardLinks = forwardLinks[is.na(idx)]

     if(any(forwardLinks == ""))
       stop("empty link added")

       # Add these links to the queue.
     toBeProcessed = c(toBeProcessed, forwardLinks)
       # Take this one off the queue.
     toBeProcessed = toBeProcessed[-1]

       # Check if we have processed the requested number of URIs
     if(max > -1 && length(allLinks) >= max)
       break
  }

   # return the links and the errors.
  list(links = allLinks,
       errors = errors)
}

processURLLinks =
  #
  # Function to parse a single document and retrieve the links
  # within it.
  # 
function(u)
{
  library(XML)  # make certain we have htmlTreeParse()

   # An empty vector in which we store the URIs for the links in the document.
  urls = character()

   # Handle for the <a href="..."> elements in the HTML document.
  a = function(node) {
    val = xmlGetAttr(node, "href", xmlGetAttr(node, "HREF", NA))

    if(!is.na(val)) {
        # Now resolve the URI by merging it with the base URI
        # and the value of the href attribute.
      if(length(grep("^mailto:", val)) == 0) {
         tmp = mergeURI(URI(val), base, reduce = TRUE)
         v = toString.URI(tmp)
       } else
         v = val
      
      if(v == "")
        browser() # This is bad news and so we stop while we try to debug it! 
      else
        urls <<- c(urls, v)

    }
  }

    # Now parse the document.
  base = URI(u)
  htmlTreeParse(u, handlers = list(a = a))

  unique(urls)
}



dropLink=
function(dropped = character(),
          extensions =  c("zip", "exe", "avi", "mpg", "mpeg", "jpeg", "jpg", "gif", "png",
                          "sh", "csh", "pl", "py", "gz", "tar", "ps", "pdf", "doc"))
{
  # regular expression to match the extension of the file
  eexp = paste("\.(", paste(extensions, collapse="|"),  ")$", sep="", collapse="")

   # Function that performs the match.
  dropLink = 
  function(u) {

   if(length(grep("^mailto:", u)))
      return(NA)
    
       # Check whether the URI is in the dropped list.
    if(!is.na(match(u, dropped)))
      return(NA)

       # Check for a specific one by regular expression.
    if(length(grep("wwwak.research", u))) {
      dropped <<- c(dropped, u)
      return(NA)
    }

      # Check for extension match.
    if(length(grep(eexp, u))) {
       dropped <<- c(dropped, u)
       return(NA)
     }


    
      # Handle internal links within a document by dropping these
      # and only looking at the document URI in the link.
     u = gsub("#.*$", "", u)



    u
  }

   # Return the function for matching and also an accessor to extract
   # the collection of dropped URIs after the processing is done.
  list(dropLink = dropLink,
       dropped = function() dropped)
}
