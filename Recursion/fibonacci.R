# See Wikipedia
# http://en.wikipedia.org/wiki/Fibonacci_number

# Nice and elegant.
fibonacci =
function(n)
{
  if(n == 0 || n == 1)
     return(n)

  fibonacci(n - 1) + fibonacci(n - 2)  
}

answers = c(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946)

a = sapply(0:(length(answers) - 1), fibonacci)
if(!all(answers == a)) {
  stop("Error in fibonacci sequence for n = ", paste((length(answers)-1)[ answers != a], collapse = ", "))
}

# More complex algorithm, but much faster.
fib2 =
function(n)
{
  if(n == 0 || n == 1)
     return(n)
  if(n == 2)
    return(1)

  f1 = f2 = 1
  for(i in seq(2, n-1)) {
    f = f1 + f2
    f2 = f1
    f1 = f
  }

  f
}  

.Fibonacci<- c(1, 1)
  
dynFibonacci <-
function(n)
{
  curMax = length(.Fibonacci)
  if(curMax >= n)
      return(.Fibonacci[n])

  for(i in seq(curMax + 1, n)) {
     .Fibonacci[i] <<- .Fibonacci[i - 1]  + .Fibonacci[i - 2] 
  }

  .Fibonacci[n]
}
