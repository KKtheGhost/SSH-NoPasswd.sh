#!/bin/bash
#Program
#		母机器——免密登录配置sh	
#version 0.1
#History
#2018/08/14 Kivinsae

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin
export PATH

#创建IP监测函数check_ip,监测ip合法性，并且在不合法时及时退出运行。
function check_ip() {
    IP=$ip001
    if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then  #分四段提取IP的数字查是否多于三位数
        FIELD1=$(echo $IP|cut -d. -f1)
        FIELD2=$(echo $IP|cut -d. -f2)
        FIELD3=$(echo $IP|cut -d. -f3)
        FIELD4=$(echo $IP|cut -d. -f4)
        if [ $FIELD1 -le 255 -a $FIELD2 -le 255 -a $FIELD3 -le 255 -a $FIELD4 -le 255 ]; then	#检查每段数字是否大于255
            echo "IP $IP available.";ip002=$IP      #为了便于更改在之后的运行中启用新的变量ip002
        else
            echo "IP $IP not available!";exit 0
        fi
    else
        echo "IP format error!";exit 0
    fi
}

#声明程序作用
echo "Tell me ip Please, I will handle everything!"
#引导用户输入子机器IP
read -p "Please input IP here:" ip001

check_ip			
#运行IP监测函数，如果通过则进入下一步

echo "And now you should input the branch's Passwd twice."

# -f参数判断本机公钥文件id_rsa.pub是否存在
pubkey=~/.ssh/id_rsa.pub
if [ ! -f "$pubkey" ]; then
		#如果公钥文件
  		ssh-keygen -t rsa;
  		scp ~/.ssh/id_rsa.pub root@${ip002}:~/.ssh/id_rsa.pub;
  		res01=1
  		#设定新参数res01作为结果，去给下一个判断循环使用。 
	else
		echo "The public Key is already existed.";
		scp ~/.ssh/id_rsa.pub root@${ip002}:~/.ssh/id_rsa.pub;
		res01=1  
fi

#这个循环用以把子机器需要执行的SH文件传送到子机器的SSH文件夹里
if [ ${res01} == 1 ];then
	scp ./NoPasswd_K.sh root@${ip002}:~/.ssh/
	else
	echo "Script error."
fi

echo "Public KEY has been copied to the branch machine:${ip001}"
exit 0