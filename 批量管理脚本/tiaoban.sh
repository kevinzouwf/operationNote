#!/bin/bash
function trapper() {
    trap ':'  INT EXIT TSTP TERM HUP
}
while true
do
    trapper
    clear
	cat <<menu
		72) lb01.etiantian.org
		78) lb02.etiantian.org
		73) lamp01.etiantian.org
		74) lnmp01.etiantian.org
		75) db01.etiantian.org
		76) nfs.etiantian.org
		77) rsync.etiantian.org
		q) exit
menu
	read -p "please select:" num
	  case "$num" in
		72) ssh lb01.etiantian.org
		;;
		78) ssh lb02.etiantian.org
		;;
		73) ssh lamp01.etiantian.org
		;;
		74) ssh lnmp01.etiantian.org
		;;
		75) ssh db01.etiantian.org
		;;
		76) ssh nfs.etiantian.org
		;;
		77) ssh rsync.etiantian.org
		;;
		key) sh /server/scripts/sendkey.sh sendkey 
		;;
		q) exit
	         esac
done




