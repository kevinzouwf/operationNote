#!/bin/sh
grep $1 $2 > temp.txt
awk '
BEGIN {
FS="[: ]"
}
 {
pv[$5$6] += 1
bits[$5$6] += $13
}
END {
for( i in pv)
print i, pv[i],bits[i]| "sort -k2,2nr >latefile"

}
' temp.txt
