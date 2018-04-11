#!/bin/bash
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
awk '

BEGIN {
  printf "#ts date time load QPS"
  fmt = " %.2f";
}
/^TS/ {
  ts     = substr($2, 1, index($2, ".") -1);
  load   = NF - 2;
  diff   = ts - prev_ts;
  prev_ts = ts;
  printf "\n %s %s %s %s", tc,$3,$4,substr($load,1,length($load)-1);

}
/Queries/ {
  printf fmt, ($2-Queries)/diff;
  Queries = $2
}
' "$@"
