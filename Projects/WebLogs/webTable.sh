cut -f 1 -d ' ' AnsonJanuary.log > /tmp/IP
cut -f 4 -d ' ' AnsonJanuary.log | sed -e 's/\[//' > /tmp/Date
cut -f 6 -d ' ' AnsonJanuary.log | sed -e 's/"//' > /tmp/Action
cut -f 7 -d ' ' AnsonJanuary.log > /tmp/Document
cut -f 8 -d ' ' AnsonJanuary.log | sed -e 's/"$//' > /tmp/Protocol
cut -f 9 -d ' ' AnsonJanuary.log > /tmp/Status
cut -f 10 -d ' ' AnsonJanuary.log > /tmp/Bytes
cd /tmp
paste IP Date Action Document Protocol Status Bytes > AnsonTable.dat
