#!/bin/bash

ID=$(id -u)
$R="\e[31m"
$G="\e[32m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"


if [ $ID -ne 0 ] &>> LOGFILE
then
    echo -e "$R Please login as a root user.$N"
else
    echo -e "$G Successfully login as root user.$N"
fi

VERIFY(){
    if [ $1 -ne 0 ]  &>> LOGFILE
    then
        echo -e "$2 is $R Failed.$N"
    else
        echo -e "$2 is $G Success.$N"
    fi
}

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> LOGFILE

VERIFY $? "Installing the version"

dnf module enable redis:remi-6.2 -y &>> LOGFILE

VERIFY $? "Enabling the redis"

dnf install redis -y &>> LOGFILE

VERIFY $? "Installing the redis"

sed -i "s/127.0.0.1/0.0.0../g" /etc/redis.conf &>> LOGFILE

VERIFY $? "Allowing all user to access"

systemctl enable redis &>> LOGFILE

VERIFY $? "Enabling the redis after installation"

systemctl start redis &>> LOGFILE

VERIFY $? "Starting the redis"