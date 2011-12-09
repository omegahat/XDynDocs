.onLoad = # Attach =
function(...)
{
     # Force the initialization of the catalogs. Should call the real routine in libxml2 for this,
     # xmlInitializeCatalog.

  .onAttach(, "XDynDocs")

if(FALSE) {  
    # Force the regular initialization so that our version doesn't become the unusual default.
  catalogResolve("bob")
  if(FALSE) {  
     localDirs = c(system.file("XSL", "OmegahatXSL", package = "XDynDocs"),
                   system.file("XSL", "docbook-xsl-1.73.2", package = "XDynDocs"))
  
     catalogAdd(c("http://www.omegahat.org/XSL/", "http://docbook.sourceforge.net/release/xsl/current/"),
                  paste(localDirs, .Platform$file.sep, sep = ""))
  } else  
     catalogLoad(system.file("XML", "catalog.xml", package = "XDynDocs"))
}

  # Load the catalog.xml in system.file("XML", "catalog.xml", package = "IDynDocs")
  # While we might think that that means we have to generate it via autoconf when installing the package
  # that is not the case. We can use a relative rewrite and it is expanded correctly based on the location
  # of the catalog.xml file.


  addXDynDocsLiveCatalogEntries()

  # Add a function to allow users to generate the catalog for external use.
  # Easy to do this from within R with the commands above.

  if(!is.null(FopExec) && is.null(getOption("FOP")))
     options(FOP = FopExec)  
}

  
