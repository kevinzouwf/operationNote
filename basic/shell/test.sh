#!/bin/bash
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
#变量定义举例：
myName="sandow"
myUrl="http://magdre.github.io"
myAge=34
#调用变量
echo "hell everyone my name is $myName, my blog site is $myUrl,"
echo "Today, I'm ${myAge}years old"
#删除变量
unset myName

echo "File Name: $0"
echo "First Parameter : $1"
echo "Second Parameter : $2"
echo "Quoted Values: $@"
echo "Quoted Values: $*"
echo "Total Number of Parameters : $#"
