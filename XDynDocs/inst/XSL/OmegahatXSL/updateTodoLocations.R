library(XML)
todo = xmlParse("Todo.xsl.in")
nodes = getNodeSet(todo, "//link[@rel='stylesheet']|//script[@language='JavaScript']")

location = Sys.getenv("XDYNDOCS")
#location = "file:///Users/nolan/Classes/StatComputing/XDynDocs/inst"
#location = commandArgs(TRUE)[1]

cat("Location:", location, "\n")
sapply(nodes,
        function(node, location) {
           atName = if(xmlName(node) == "link") "href" else "src"
           val = xmlGetAttr(node, atName)
           xmlAttrs(node) = structure(gsub("@XDYNDOCS@", location, val), names = atName)
           TRUE
        }, location = location)

saveXML(todo, "Todo.xsl")
cat("updated", sprintf("%s/Todo.xsl\n", getwd()))
print(file.info("Todo.xsl"))








