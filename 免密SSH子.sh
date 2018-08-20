#!/bin/bash
#Program
#		子机器——免密ssh登录
#version 0.1
#History
#2018/08/14 Kivinsae

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin
export PATH

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo PermitRootLogin yes >> /etc/ssh/sshd_config  #这是在最后一行行后添加字符串
echo StrictModes no >> /etc/ssh/sshd_config  #这是在最后一行行后添加字符串
echo PubkeyAuthentication yes >> /etc/ssh/sshd_config  #这是在最后一行行后添加字符串
echo AuthorizedKeysFile  .ssh/authorized_keys >> /etc/ssh/sshd_config  #这是在最后一行行后添加字符串
echo PasswordAuthentication no >> /etc/ssh/sshd_config  #这是在最后一行行后添加字符串

systemctl restart sshd.service

echo "Branch has been done. Please try NoPasswd SSH Login"
exit 0