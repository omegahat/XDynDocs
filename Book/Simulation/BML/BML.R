    ####   moveBlue
moveBlue = 
function(grid, locations = grid$locations, G = grid$G, klass = class(grid))
{
  w = ( locations$carType == "blue" )

  potential = locations[w, 1:2]
  potential[, 1] = potential[, 1] - 1
  potential[ potential[,1] == 0, 2] = r

  i = G[ cbind(potential[,1], potential[,2]) ] 
  ok = (i == 0)


  locations[ which(w)[ok], 1:2]  = potential[ok,]
  G[ cbind(locations[which(w)[ok], 1], locations[which(w)[ok], 2]) ] = 0
  G[ cbind(potential[ok, 1], potential[ ok, 2]) ]  = 2 # blue
  
cat("Moved", sum(ok), "out of", sum(w), "\n")
  structure(list(locations = locations, G = G), class = klass)
}

    ####   createGrid
createGrid =
function(n = c(15, 15), r = 10, c = 11, prob = c(red = .5, blue = .5),
          density = NA, exact = FALSE)
{
   # if we have only on n, and it is a proportion
   # then turn it into a count as a proportion of 
   # the grid size
  if(length(n) == 1 && n < 1)
     n = r * c * n

  if(!missing(density)) 
     n = r * c * density

     # if we have only one count, then replicate it 
     # that many times and allow the last grouping to pick up 
     # any slack.    
  if(length(n) == 1 && length(colors) > 1)  {
       tmp = rep(floor(n/(length(colors)-1)), length(colors)-1)
       n = c(tmp, n - as.integer(sum(tmp)))
  }

  locations = expand.grid(1:r, 1:c)
  locations = locations[sample(1:nrow(locations), sum(n)), ]
  
  locations$carType = if(!exact) 
                          factor(sample(names(prob), sum(n), prob = prob, replace = TRUE), levels = names(prob))
		      else 
                          factor(rep(names(prob), n), levels = names(prob))


  G = matrix(0L, r, c)
  G[ cbind(locations[, 1], locations[,2]) ] = as.integer(locations$carType)
  class(G) = "Grid"

  structure(list(locations = locations, G = G), class = "BMLGrid")
}

    ####   xplot.Grid
plot.Grid =
function(x, y, ...)
{
#   image(z = t(x[nrow(x):1, ncol(x):1]),  col = c("transparent", "red", "blue"), axes = FALSE)
   image(z = x,  col = c("transparent", "red", "blue"), axes = FALSE)
   box()
}

    ####   plot.Grid
plot.Grid =
function(x, y, ...)
{
   image(z = t(x)[ , nrow(x):1], col = c("transparent", "red", "blue"), axes = FALSE)
   box()
}

    ####   
plot.BMLGrid =
function(x, y, ...)
{
  plot(x$G)
}

    ####   plot.BMLGrid
plot.BMLGrid =
function(x, y, ..., addGrid = FALSE)
{
  plot(0, 0, type = "n", 
       xlim = c(0, ncol(x$G)), ylim = c(0, nrow(x$G)), 
       axes = FALSE, xlab = "columns", ylab = "rows", ...) # , pty = "s", ...)

  axis(1)
  r = nrow(x$G)
  tmp = pretty(1:r)
  axis(2, at = tmp, labels = rev(tmp))
  box()


   # While we may want to loop, rect is vectorized
   # and it is actually simpler to write in this form
   # since we merely omit the for loop and indices
  rect(x$locations[, 2] - 1, r - x$locations[, 1],  
       x$locations[, 2], r - x$locations[, 1] + 1, 
       border = NA,
       col = as.character(x$locations$carType)) # , density = 0) # density = NA is very slow.

  if(addGrid) {
      abline(v = 0:ncol(x$G))
      abline(h = 0:nrow(x$G))
  }
}

    ####   moveBlue
moveBlue = 
function(grid, locations = grid$locations, G = grid$G, klass = class(grid))
{
   w = ( locations$carType == "blue" )

   for(i in which(w)) {
         r = locations[i, 1]
         c = locations[i, 2]
	 if(r == 1)
            rprime = nrow(G)
         else
            rprime = r - 1

         if( G[ rprime, c ] == 0 ) {
             G[ r, c ] = 0
             G[ rprime, c ] = 2
   	     locations[i, 1:2] = c(rprime, c)
         }
   }

   structure(list(locations = locations, G = G), class = klass)
} 

    ####   moveRed
moveRed = 
function(grid, locations = grid$locations, G = grid$G, klass = class(grid))
{
   w = ( locations$carType == "red" )

   for(i in which(w)) {
         r = locations[i, 1]
         c = locations[i, 2]
	 if(c == ncol(G))
            cprime = 1
         else
            cprime = c + 1

         if( G[ r, cprime ] == 0 ) {
             G[ r, c ] = 0
             G[ r, cprime ] = 1
   	     locations[i, 1:2] = c(r, cprime)
         }
   }

   structure(list(locations = locations, G = G), class = klass)
} 

    ####   run
run = 
function(g = createGrid(), steps = 100, ask = FALSE, ...)
{
  if(is.logical(ask))
    ask = if(ask) 1 else NA

    funs = list(moveRed, moveBlue)
    if(!is.na(ask))
       plot(g, ...)
    for(t in 1:10) {
       f = funs[[ t%%2 + 1]]
       g = f(g)

       if(!is.na(ask) && ask %% t == 0) {
         plot(g, ...)
         readLines(n = 1)
       }
    }

    invisible(g)
}

    ####   vectorizedMove2
vectorizedMove = 
function(type, val, grid, locations = grid$locations, G = grid$G, klass = class(grid), speed = c(1, 1), ...)
{
   w = ( locations$carType == type )
   loc = locations[w, ]
  
   r = loc[, 1]
   c = loc[, 2]

   if(type == "blue") {
      c.next = c
      r.next = r - 1
      r.next[ r.next == 0] = nrow(G)
   } else {
      r.next = r
      c.next = c + 1
      c.next[c.next > ncol(G)] = 1
   }

   movers = G[ cbind(r.next, c.next) ] == 0
   if(any(movers)) {
       G[ cbind(r, c)[movers, drop = FALSE] ]  = 0
       G[ cbind(r.next, c.next)[movers,  drop = FALSE] ] = val 
       locations[which(w) [movers], 1:2 ] = cbind(r.next, c.next)[movers, drop = FALSE]
   }

   structure(list(locations = locations, G = G), class = klass)
} 

    ####   vectorizedRun
vectorizedRun = 
function(g = createGrid(), steps = 100, ask = FALSE, ...)
{
  if(is.logical(ask))
    ask = if(ask) 1 else NA

    if(!is.na(ask))
       plot(g, ...)

    types = levels(g$locations$carType)
    for(t in 1:steps) {
       g = vectorizedMove(types[1], 1L, g)
       g = vectorizedMove(types[2], 2L, g)
       if(!is.na(ask) && ask %% t == 0) {
         plot(g, ...)
         readLines(n = 1)
       }
    }

    invisible(g)
}

    ####   vectorizedMove2
vectorizedMove = 
function(type, val, grid, locations = grid$locations, G = grid$G, klass = class(grid), speed = c(1, 1), ...)
{
   w = ( locations$carType == type )
   loc = locations[w, ]
  
   r = loc[, 1]
   c = loc[, 2]

   if(type == "blue") {
      c.next = c
      r.next = r - 1
      r.next[ r.next == 0] = nrow(G)
   } else {
      r.next = r
      c.next = c + 1
      c.next[c.next > ncol(G)] = 1
   }

   movers = G[ cbind(r.next, c.next) ] == 0
   if(any(movers)) {
       G[ cbind(r[movers], c[movers])] = 0
       G[ cbind(r.next[movers], c.next[movers]) ] = val 
       locations[which(w) [movers], 1:2 ] = cbind(r.next, c.next)[movers, drop = FALSE]
   }

   structure(list(locations = locations, G = G), class = klass)
} 

    ####   vectorizedMove3
vectorizedMove = 
function(type, val, grid, locations = grid$locations, G = grid$G, klass = class(grid), speed = c(1, 1), ...)
{
   w = ( locations$carType == type )
   loc = locations[w, ]
  
   r = loc[, 1]
   c = loc[, 2]

   if(type == "blue") {
      c.next = c
      r.next = r - 1
      r.next[ r.next == 0] = nrow(G)
   } else {
      r.next = r
      c.next = c + 1
      c.next[c.next > ncol(G)] = 1
   }

   movers = G[ cbind(r.next, c.next) ] == 0
   if(any(movers)) {
       locations[which(w) [movers], 1:2 ] = cbind(r.next, c.next)[movers, drop = FALSE]
       G[] = 0L
       G[ cbind(locations[, 1], locations[,2]) ] = as.integer(locations$carType)
   }

   structure(list(locations = locations, G = G), class = klass)
} 

    ####   crun
crun =
function(g, steps = 1000, verbose = FALSE, velocity = FALSE, speed = c(1, 1))
{
  red = as.matrix(g$locations[ g$locations$carType == "red", 1:2])
  blue = as.matrix(g$locations[ g$locations$carType == "blue", 1:2])

  movesPerStep = matrix(0L, steps, 2)
  ans = .C("R_BML", G = g$G, dim(g$G), 
                    red = red, nrow(red), 
                    blue = blue, nrow(blue), as.integer(steps), 
                    as.logical(verbose), movesPerStep = movesPerStep, speed = as.integer(speed))

  g$locations = as.data.frame(rbind(ans$red, ans$blue))
  names(g$locations) = c("row", "column")
  g$locations$carType = factor(c(rep("red", nrow(red)), rep("blue", nrow(blue))), levels = c("red", "blue"))
  g$G = ans$G
  class(g$G) = "Grid"

  if(velocity)
     invisible(list(bml = g, movesPerStep = ans$movesPerStep))
  else
     invisible(g)
}

    ####   testRun
testRun = 
function(g = createGrid(), numSteps = 5, plot = TRUE, speed = c(1, 1), ..., runFunc = crun)
{
  if(plot)  {
     par(mfrow = c(1, numSteps), ...)
     on.exit(par(mfrow = c(1, 1)))
     plot(g, ...)
  }

  ans = vector("list", numSteps)
  ans[[1]] = g
  for(i in 2:numSteps) { #XXX what if numSteps is 1
     ans[[i]] = runFunc(ans[[i - 1]], 1, speed = speed)
     if(plot)
         plot(ans[[i]], ...)
  }
  invisible(ans)
}

    ####   cantMove
cantMove = 
function(type, grid, locations = grid$locations, G = grid$G, speed = c(1, 1))
{
   w = ( locations$carType == type )
   loc = locations[w, ]
  
   r = loc[, 1]
   c = loc[, 2]

   if(type == "blue") {
      c.next = c
      r.next = r - 1
      r.next[ r.next == 0] = nrow(G)
   } else {
      r.next = r
      c.next = c + 1
      c.next[c.next > ncol(G)] = 1
   }

   movers = G[ cbind(r.next, c.next) ] == 0

   if(!all(movers))
      locations[ which(w)[ !movers ] , ] 
   else
      locations[ 0, ]
}

    ####   findJamLengths
findJamLengths =
function(col)
{
  i = which(col == 0) 
  diff(i)
}

setClass("a", contains = "character")
