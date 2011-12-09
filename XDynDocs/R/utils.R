dQuote =
  # For avoiding fancy quotes.
function(x)
{
  sprintf('"%s"', as.character(x))
}


getEvalEnvironment =
function(dynOpts, envMissing, default = globalenv())
{
   env = default
       # comes from closure generator.
   if(envMissing)
        env = if(exists(".environment", inherits = TRUE)) 
                 get(".environment")
              else
                 dynOpts@env

   if(is.null(env))
       env = default

  env
}
