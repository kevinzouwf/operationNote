#!/bin/sh
a=$1
test=aaa
file=${a:=fff$test}
echo $file
