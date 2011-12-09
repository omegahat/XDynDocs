.onAttach =
function(libname, pkgname)
{
  if(Sys.getenv("XML_CATALOG_FILES") == "")
     catalogLoad(system.file("XML", "catalog.xml", package = pkgname))

  #  Should check that we can resolve all the pieces we will need
  m = catalogResolve(names(URIMap))
  if(any(is.na(m))) {
    i = is.na(m)
    catalogAdd(names(m)[i], paste(system.file(package = "XDynDocs"), m[i], sep = .Platform$file.sep))
  }
}

URIMap = 
    c('http://www.omegahat.org/XSL/'  = "XSL/OmegahatXSL/",
      'http://www.omegahat.org/XDynDocs/' = '',
      'http://docbook.sourceforge.net/release/xsl/current/' = 'XSL/docbook-xsl-current/'
     )

addXDynDocsLiveCatalogEntries = 
#
#  add the entries to the catalog in memory
#
#
function(dir = system.file(package = "XDynDocs"), map = URIMap)
{
  dir = gsub("/$", "", dir)
  dir = gsub("/+", "/", dir)

  ok = catalogResolve(paste(names(map), "foo", sep = ""))
  map = map[is.na(ok)]

  if(length(map))
     mapply(catalogAdd, names(map), paste(dir, map, sep = "/"))
  else
     TRUE
}


createXDynDocsCatalog = 
 #
 # if dupBase is TRUE, then copy the current contents of the catalog and add ours
 # and use that static snapshot.
 #  Otherwise, delegate to that catalog in ours
 #
 # Can add to the live catalog in memory (after loading it implicitly via a catalogResolve) 
 # But we also want to create a new catalog for people to use outside of R.
 #
function(dir = system.file(package = "XDynDocs"), 
         catalogs = Sys.getenv("XML_CATALOG_FILES"), 
         stdCatalog = "/etc/xml/catalog", dupBase = FALSE, map = URIMap,
         file = NULL)
{
  dir = gsub("/$", "", dir)
  dir = gsub("/+", "/", dir)

  ok = catalogResolve(paste(names(map), "foo", sep = "/"))
  if(!any(is.na(ok)))
     return(character()) # nothing to do.

  if(missing(stdCatalog) && catalogs != "")
      stdCatalog = strsplit(catalogs, .Platform$path.sep)[[1]] [1] 

   # what if there really is no catalog ?
  cur = xmlParse(XML:::catalogDump())

  top = xmlRoot(cur)
  if(!dupBase)
    removeNodes(xmlChildren(top))

  if(length(stdCatalog) && !is.na(stdCatalog))
      newXMLNode("nextCatalog", attrs = c(catalog = stdCatalog),  parent = top)

  map = map[is.na(ok)]
  mapply(function(from, to)
           newXMLNode("rewriteURI", attrs = c(uriStartString = from, rewritePrefix = to), parent = top),
         names(map), paste(dir, map, sep = "/"))

  saveXML(cur, file)
}
