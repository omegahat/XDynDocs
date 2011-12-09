x =  1:10
y = mtcars

con = rawConnection(raw(0), "w")
save(x, file = con)
writeBin(rawConnectionValue(con), "/tmp/x.rda")
rm(x)
load("/tmp/x.rda")


con = rawConnection(raw(0), "w")
save(x, y, file = con)
writeBin(rawConnectionValue(con), "/tmp/x.rda")
rm(x)
e = new.env()
load("/tmp/x.rda", e)
objects(e)



con = rawConnection(raw(0), "w")
save(x, y, file = con)
content = rawConnectionValue(con)
library(RCurl)
b64 = base64(content)

rw = base64(b64, mode = "raw")
input = rawConnection(rw)
load(input)


writeBin(rw, "/tmp/raw.rda")
e = new.env()
load("/tmp/raw.rda", e)
objects(e)





