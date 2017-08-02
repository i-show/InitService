#!/bin/bash
###########################################################################
# Copyright Statement:
# --------------------
# This software is protected by Copyright and the information contained
# herein is confidential. The software may not be copied and the information
# contained herein may not be used or disclosed except with the written
# permission of Magcomm Inc. (C) 2015
# -----------------
# Author : y.haiyang
# Version: V1.1
# Update : 2017-07-19
############################################################################
readonly TMP_PATH=/tmp/init
readonly USER_NAME=ishow

function echoMe()
{
    echo -e "\e[01;32m*************************************************\e[0m"
    echo -e "\e[01;32m*\e[0m"

    for tag in "$@"
    do
        echo -e "\e[01;32m*\e[0m  \e[01;34m $tag \e[0m"
        echo -e "\e[01;32m*\e[0m"
    done

    echo -e "\e[01;32m*************************************************\e[0m"
}

function echoStart()
{
    echo -e "\e[01;32m*************************************************\e[0m"
    echo -e "\e[01;32m*\e[0m"
}

function echoMiddle()
{
    for tag in "$@"
    do
        echo -e "\e[01;32m*\e[0m  \e[01;34m $tag \e[0m"
        echo -e "\e[01;32m*\e[0m"
    done
}

function echoEnd()
{
    echo -e "\e[01;32m*************************************************\e[0m"
}

echoMe  "解压文件中，请不要离开！"

if [ ! -d $TMP_PATH ] ; then
    mkdir $TMP_PATH
fi


echoMiddle "解压脚本中..."
cp -a conf/ $TMP_PATH
cp -a utils/ $TMP_PATH
cp -a init.sh $TMP_PATH
echoMe "开始配置！"

cd $TMP_PATH

# 添加权限
chmod  a+x  ./init.sh


# 增加用户
echoMe "创建用户中..."
#sudo adduser $USER_NAME
#sudo passwd
#sudo sed -i '/## Allow root to run/a\'${USER_NAME}'    ALL=(ALL)       ALL' /etc/sudoers
sudo su $USER_NAME
