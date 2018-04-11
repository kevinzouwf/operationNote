#!/bin/bash
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
readarray -t array_data <<< "$1"
num=${#array_data[@]}
printf '{\n'
printf '\t"data":[ '
for line in "${array_data[@]}";do
        APP_NAME=$(echo $line | awk -F '[ :\r]+' '{print $1}')
        APP_VALUE=$(printf "$line"| awk -F '[: \r]+' '{print $2}')
		[ -z $APP_NAME ] && continue
		[ -z  $APP_VALUE ] && continue
        printf '\n\t\t{'
        printf "\"{#APP_NAME}\":\"${APP_NAME}\", \"{#APP_VALUE}\":\"${APP_VALUE}\"},"
		#printf "\"}"
		#printf ","
		((num--))
		[ "$num" == 0 ] && break
done
printf '\n\t]\n'
printf '}\n'
