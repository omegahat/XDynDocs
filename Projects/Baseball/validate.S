# This is to be run after we have loaded the  data
# to ensure that it has been read correctly.
# Connect to the database

d = dbDriver("MySQL")
con = dbConnect(d, "BaseballDatabank04")


getTableCounts = 
function()
{
     # Get the information about the number of rows in each table.
  counts = sapply(dbListTables(con), function(x) as.integer(dbGetQuery(con, paste("SELECT COUNT(*) FROM", x))))
     # counts shouldn't have xref_stats?
  counts = counts[- match("xref_stats", names(counts))]
}

counts04 = getTableCounts()

dbNames = as.character(dbGetQuery(con, "show databases"))
if("BaseballDatabank03" %in% dbNames) {
    dbGetQuery(con, "USE BaseballDatabank03"))
    counts03 =  getTableCounts()

    counts03 <= counts04[names(counts03)]
}

numLines = sapply(list.files(pattern = "\.csv1$"), function(x) length(readLines(x)))

# Check the names of the tables correspond to the names of the files
names(numLines) = gsub("\\.csv1$", "", names(numLines))


if(!all(names(counts) %in% names(numLines)))
  stop("Problems with names of tables")

# The -1 is because of the header.
all(counts == (numLines[names(counts)] - 1))

