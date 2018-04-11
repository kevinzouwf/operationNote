email_File=/tmp/email.log
function main(){
        printf "$1\n $2\n $3\n" >> /tmp/aaaa
        echo "$3" >$email_File
        /usr/bin/dos2unix $email_File 
        /bin/mail -s "$2" "$1" <$email_File
}
echo  $2  >> /tmp/test
main "$1" "$2" "$3"
#echo "$2" |/usr/local/python-2.7.11/bin/python /usr/local/zabbix/alertscripts/emaysms.py send -k /opt/emaysms.py/key 18010073860 &>>/tmp/python.log
#status=$(echo $2|awk -F ':|on' '{print $1}')
#host=$(echo $2|awk -F ':|on ' '{print $3}'|awk -F '.' '{print $1}')
#message=$(echo $2|awk -F ': | on ' '{print $2}'|sed 's/\ /_/g')
#echo $status >> /tmp/hello
#echo $host >> /tmp/hello
#echo $message >> /tmp/hello
#/usr/local/python-2.7.11/bin/python send_mail.py 18010073860 $host $status $message >> /tmp/hello
