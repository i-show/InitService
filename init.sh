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
# Version: V0.0.1
# Update : 2017-07-19
############################################################################
#需要添加的库，可以在此方便添加
readonly GAP=" "
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 固定路径方便修改
readonly USER_NAME=$USER
readonly LOCAL_PATH=$PWD
readonly INIT_PATH=$LOCAL_PATH
readonly INIT_UTILS_PATH=$INIT_PATH/utils
readonly INIT_CONFIGURE_PATH=$INIT_PATH/conf

readonly CONFIGURE_HOME=/opt/configure
readonly GRADLE_HOME=/opt/environment/gradle
readonly JAVA_HOME=/opt/environment/java
readonly TOMCAT_HOME=/opt/environment/tomcat
readonly ANDROID_HOME=/opt/environment/android/
readonly ANDROID_SDK_HOME=$ANDROID_HOME/sdk
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++


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

function timing()
{
    local time=$1
    local tipStart=$2
    local tipEnd=$3

    while [ $time -ge 0 ]
        do
            echo -e  "\e[01;34m $tipStart\e[0m\e[01;31m$time\e[0m\e[01;34m$tipEnd \e[0m"
            sleep 1
            let "time-=1"
    done
}

echoMe "请确保已经运行过install.sh"

timing 8

if [[ ! -f /home/$USER ]] ; then
	echo "用户不存在"
    exit
fi

echoMe "下载常用库中..."
sudo yum install unzip java-1.8.0-openjdk git mariadb mariadb-server


# 创建目录
echoMe "配置文件路径创建"
sudo mkdir /exchange /opt
sudo chmod a+rw /exchange /opt

mkdir -p $CONFIGURE_HOME
mkdir -p $ANDROID_HOME
mkdir -p $ANDROID_SDK_HOME
mkdir -p $JAVA_HOME
mkdir -p $TOMCAT_HOME
mkdir -p $GRADLE_HOME


#配置文件
if [[ ! -f /etc/bashc.bak ]] ; then
    sudo cp -a /etc/bashrc /etc/bashrc.bak
    sudo sed -i '$a #ISHOW Configure'           /etc/bashrc
    sudo sed -i '$a source  /opt/configure/ishow.conf'   /etc/bashrc
    cp -a $INIT_CONFIGURE_PATH/ishow.conf /opt/configure
fi

# 配置VIM和Gitcongig中
echoMe "配置VIM和Gitcongig中..."
cp -a $INIT_UTILS_PATH/.vimrc      ~/
cp -a $INIT_UTILS_PATH/.gitconfig  ~/
sed -i "s/admin/$USER/g" ~/.gitconfig

# 配置Gradle 配置
echoMe "配置Gradle"
cd ~/
wget -c https://downloads.gradle.org/distributions/gradle-3.3-all.zip
cp -a gradle-3.3-all.zip $GRADLE_HOME
cd $GRADLE_HOME
unzip gradle-3.3-all.zip
rm -rf gradle-3.3-all.zip

# Android SDK配置
echoMe "配置AndroidSDK"
cd ~/
wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
cp -a sdk-tools-linux-3859397.zip $ANDROID_SDK_HOME
cd $ANDROID_SDK_HOME
unzip sdk-tools-linux-3859397.zip
rm -rf sdk-tools-linux-3859397.zip
# 更新的因为环境问题无法一次性写完

# 下载java
cd ~/
wget http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz?AuthParam=1500444648_6c2f5ac56fc286d582b9ecc2d60996ce -O jdk-8u141-linux-x64.tar.gz
cp -a jdk-8u141-linux-x64.tar.gz $JAVA_HOME
cd $JAVA_HOME
tar -zxvf jdk-8u141-linux-x64.tar.gz
rm -rf jdk-8u141-linux-x64.tag.gz

# 配置Tomcat
cd ~/
wget https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz 
cp -a apache-tomcat-9.0.0.M22.tar.gz $TOMCAT_HOME
cd $TOMCAT_HOME
tar -zxvf apache-tomcat-9.0.0.M22.tar.gz
mv apache-tomcat-9.0.0.M22  tomcat_9
rm -rf apache-tomcat-9.0.0.M22.tar.gz

# 下载Jenkins的 war包
cd ~/
wget https://mirrors.tuna.tsinghua.edu.cn/jenkins/war-stable/2.60.1/jenkins.war
cp -a jenkins.war $TOMCAT_HOME/tomcat_9/webapps/


# 配置FTP
echoMe "FTP 配置"
sudo yum install vsftpd
sudo systemctl enable vsftpd.service
sudo systemctl restart vsftpd.service
sudo useradd -d /exchange/ -s /sbin/nologin ftp
sudo passwd ftp











