#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date "+%F-%H-%M-%S")
LOGFILE="/tmp/$0-TIMESTAMP.log"

if [ $ID -ne 0 ]
then
    echo -e " $R Please log as a root user. $N"
else
    echo -e " $G Successfully logged as a root user. $N"
fi

cp /home/centos/mongo.repo /etc/yum.repos.d/mongo.repo

VERIFY $? "Coping the mongoDB repos"

dnf install mongodb-org -y

VERIFY $? "Installing the mongoDB"

systemctl enable mongod

VERIFY $? "Enabling the mongoDB-server"

systemctl start mongod

VERIFY $? "Starting the mongoDB-server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongo.conf

VERIFY $? "In Configuration giving all permissions"

systemctl start mongod

VERIFY $? "Starting the mongoDB-server"

