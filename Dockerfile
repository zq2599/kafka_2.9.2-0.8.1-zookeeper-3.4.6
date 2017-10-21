# Docker image of kafka cluster
# VERSION 0.0.1
# Author: bolingcavalry

#基础镜像使用kinogmt/centos-ssh:6.7，这里面已经装好了ssh，密码是password
FROM kinogmt/centos-ssh:6.7

#作者
MAINTAINER BolingCavalry <zq2599@gmail.com>

#定义工作目录
ENV WORK_PATH /usr/local/work

#定义日志目录
ENV LOG_PATH /usr/local/work/log

#定义zookeeper的Data目录
ENV ZK_DATA_PATH $WORK_PATH/zkdata

#定义zookeeper文件夹名称
ENV ZK_PACKAGE_NAME zookeeper-3.4.6

#定义kafka文件夹名称
ENV KAFKA_PACKAGE_NAME kafka_2.9.2-0.8.1

#将kafka的bin目录加入PATH
ENV PATH $WORK_PATH/$KAFKA_PACKAGE_NAME/bin:$PATH

#定义jdk1.8的文件夹
ENV JDK_PACKAGE_FILE jdk1.8.0_144

#定义jdk1.8的文件名
ENV JDK_RPM_FILE jdk-8u144-linux-x64.rpm

#创建工作目录
RUN mkdir -p $WORK_PATH

#创建日志目录
RUN mkdir -p $LOG_PATH

#创建zookeeper的Data目录
RUN mkdir -p $ZK_DATA_PATH

#把分割过的jdk1.8安装文件复制到工作目录
COPY ./jdkrpm-* $WORK_PATH/

#用本地分割过的文件恢复原有的jdk1.8的安装文件
RUN cat $WORK_PATH/jdkrpm-* > $WORK_PATH/$JDK_RPM_FILE

#本地安装jdk1.8，如果不加后面的yum clean all，就会报错：Rpmdb checksum is invalid
RUN yum -y localinstall $WORK_PATH/$JDK_RPM_FILE; yum clean all

#删除jdk分割文件
RUN rm $WORK_PATH/jdkrpm-*

#删除jdk安装包文件
RUN rm $WORK_PATH/$JDK_RPM_FILE

#把kafka压缩文件复制到工作目录
COPY ./$KAFKA_PACKAGE_NAME.tgz $WORK_PATH/

#解压缩
RUN tar -xvf $WORK_PATH/$KAFKA_PACKAGE_NAME.tgz -C $WORK_PATH/

#删除压缩文件
RUN rm $WORK_PATH/$KAFKA_PACKAGE_NAME.tgz

#把kafka压缩文件复制到工作目录
COPY ./$ZK_PACKAGE_NAME $WORK_PATH/$ZK_PACKAGE_NAME