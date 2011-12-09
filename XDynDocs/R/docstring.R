doc = function(fun) {
  b = body(fun)
  if(!is(b, "{"))
    return(NA)
  
  b = b[[2]]

  if(is.character(b))
    b
  else
    NA
}

# will be fooled by simple functions that return a literal.

f = function(x, y)
{
  "This is a function that adds its first two arguments after multiplying them by 2 and 3 respectively"
  2*x + 3*y
}

g = function() 1
