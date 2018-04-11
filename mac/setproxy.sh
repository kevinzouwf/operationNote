#!/bin/bash
on (){
networksetup -setwebproxy Wi-Fi 127.0.0.1 1087
networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 1086
}
off(){
networksetup -setwebproxystate Wi-Fi off
networksetup -setsocksfirewallproxystate  Wi-Fi off
}
$1
