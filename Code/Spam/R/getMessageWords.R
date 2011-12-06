
getMessageWords =
function(filename)
{
  if(length(filename) == 1 && file.exists(filename))
     txt = readLines(filename)
  else
     txt = filename
  
  txt = tolower(gsub("[[:punct:]]", " ", txt))

  con = textConnection(txt)
  on.exit(close(con))
  w = scan(con, what = "", sep=" ")
  w = unique(w)
  w = w[w != ""]

  w
}

getMessageWords =
function(filename)
{
  if(length(filename) == 1 && file.exists(filename))
     txt = readLines(filename)
  else
     txt = filename
  
  txt = paste(txt, collapse="\n")
   
    # remove punctuation, numbers and change to lower case.
    # Try to do this in one regular expression and hope that
    # it is not excessively complex so that we gain by avoiding
    # multiple calls to gsub(). Is it worth timing?
  txt = tolower(gsub('[[:punct:]]+|([[:punct:][:space:]]*[0-9]+[[:space:][:punct:]]*)', " ", txt))

    # In this context, we can break the results into words
    # by splitting on any amount of white space.
    # This is better than a single space or TAB
    # as it discards " " or "  ", etc. that might result.

    # In our version, we are only interested in the presence
    # or absence of a word, not the number of times it occurs.
    # So we compute the unique words.
  words = unique(strsplit(txt, "[[:space:]]+")[[1]])

  if(length(words) == 0)
    return(character())
  
   # All messages start with Subject: so we
   # get rid of this in the first position
   # as subject (since we have removed : and moved
   # to lower case earlier.)
  if(words[1] == "subject")
    words = words[-1]

    # Remove the stop words
  words = words[!(words %in% StopWords)]

    # throw away single letter words.
  words[is.na(match(words, c(letters, "")))]
}
