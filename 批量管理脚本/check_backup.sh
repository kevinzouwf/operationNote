flag_num=$(find /data/ -type f -name "flag_$(date +%F)"|wc -l)
if [ $flag_num -eq 4 ];then
    echo "$(date +%U%T) 节点服务器打包正常" >/opt/mail_$(date +%F)
else
    echo "$(date +%U%T) 节点服务器有打包异常" >/opt/mail_$(date +%F)
fi
echo ================================================ >>/opt/mail_$(date +%F)
failed=$(find /data/ -type f -name "flag_$(date +%F)"|xargs md5sum -c|grep -v OK)
echo $failed
count=$(echo $failed |wc -l)
echo $count
if [ $count -eq 0 ];then
  echo "$(date +%U%T) 备份服务器上的备份全部正常" >>/opt/mail_$(date +%F)
else
  echo "$(date +%U%T) 备份服务器上的备份有异常" >>/opt/mail_$(date +%F)
  echo " echo $failed" >>/opt/mail_$(date +%F)
fi

mail -s "backup info $(date +%F\ %T)" 921070747@qq.com </opt/mail_$(date +%F)
####delete 
find /backup/ -type f -name "*.tar.bz2" -mtime +180|xargs rm -f

