factorial.prod =
function(n)
{
   if(n == 0 || n == 1)
     return(1)

   prod(1:n)
}  


factorial =
function(n)
{
   if(n == 0 || n == 1)
     return(1)

   n * factorial(n-1)
}  
