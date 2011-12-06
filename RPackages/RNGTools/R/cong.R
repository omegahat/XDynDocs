rng =
  #
  # Gentle, page 38, Question 1.2
  # Random Number Generation and Monte Carlo Methods.
  #
function(a = 17, m = 2^13 - 1, seed = m/2)
{
  Next = function(...) {
         seed <<- ((a*seed) %% m)
         seed / m
  }
  gen = function(n = 1) {
        sapply(1:n, Next)
     }
}  
