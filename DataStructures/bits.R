dyn.load("bits.so")

bits =
  #
  # Takes a number and decomposes it into bits
  #
  #
function(x, real = FALSE)
{
  x = ifelse(real, as.numeric(x), as.integer(x))
  nbytes = ifelse(real, 8, 4)
  bits = .C("R_getBits", x, as.integer(nbytes), bits = integer(nbytes * 8))$bits

  if(!real)
     names(bits) = paste("2", 0:(length(bits)-1), sep = "^")

  bits
}

