#!/bin/bash
tcp_status_fun(){
	TCP_STAT=$1
	#netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,state[key]}' > /tmp/netstat.tmp
	TCP_DATA=$(ss -ant | awk 'NR>1 {++s[$1]} END {for(k in s) print k,s[k]}')
	TCP_STAT_VALUE=$(echo $TCP_DATA|grep "$TCP_STAT"  | cut -d ' ' -f2)
	if [ -z $TCP_STAT_VALUE ];then
		TCP_STAT_VALUE=0
	fi
	echo $TCP_STAT_VALUE
}

nginx_status_fun(){
	NGINX_PORT=$1
	NGINX_COMMAND=$2
    NGINX_URL='http://127.0.0.1:"$NGINX_PORT"/nginx_status/'
#    NGINX_DATA=$(/usr/bin/curl $NGINX_URL 2>/dev/null)
    NGINX_DATA=$(/usr/bin/wget -q http://127.0.0.1/nginx_status -O - 2>/dev/null)
    #echo "$NGINX_DATA"
  	case $NGINX_COMMAND in
		active)
            echo "$NGINX_DATA"| awk 'NR==1{print $NF}'
			;;
		reading)
            echo "$NGINX_DATA"| awk 'NR==4{print $2}'
			;;
		writing)
            echo "$NGINX_DATA"| awk 'NR==4{print $4}'
			;;
		waiting)
            echo "$NGINX_DATA"| awk 'NR==4{print $6}'
			;;
		accepts)
            echo "$NGINX_DATA"| awk 'NR==3{print $1}'
			;;
		handled)
            echo "$NGINX_DATA"| awk 'NR==3{print $2}'
			;;
		requests)
            echo "$NGINX_DATA"| awk 'NR==3{print $3}'
            ;;
		esac 
}

memcached_status_fun(){
	M_PORT=$1
	M_COMMAND=$2
	echo -e "stats\nquit" | nc 127.0.0.1 "$M_PORT" | grep "STAT $M_COMMAND " | awk '{print $3}'
}

redis_status_fun(){
	R_PORT=$1
	R_COMMAND=$2
	(echo -en "auth f7ypY/JwjAI9MQ==\r\nINFO \r\n";) | nc 127.0.0.1 "$R_PORT" > /tmp/redis_"$R_PORT".tmp
        sed -i  -e 's/,/\n/g' -e 's/=/:/g' -e 's/\r//g' /tmp/redis_"$R_PORT".tmp
	REDIS_STAT_VALUE=$(grep ""$R_COMMAND":" /tmp/redis_"$R_PORT".tmp |awk -F [:]+   '{print $NF}')
 	echo $REDIS_STAT_VALUE	
}

main(){
	case $1 in
		tcp_status)
			tcp_status_fun $2;
			;;
		nginx_status)
			nginx_status_fun $2 $3;
			;;
		memcached_status)
			memcached_status_fun $2 $3;
			;;
		redis_status)
			redis_status_fun $2 $3;
			;;
		*)
			echo $"Usage: $0 {tcp_status key|memcached_status key|redis_status key|nginx_status key}"
	esac
}

main $1 $2 $3
