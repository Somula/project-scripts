#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date "+%F-%H-%M-%S")
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Scripting started on $TIMESTAMP"

VERIFY(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R Failed. $N"
    else
        echo -e "$2 is $G Success. $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e " $R Please log as a root user. $N"
else
    echo -e " $G Successfully logged as a root user. $N"
fi

cp /home/centos/project-scripts/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VERIFY $? "Coping the mongoDB repos"

dnf install mongodb-org -y &>> $LOGFILE

VERIFY $? "Installing the mongoDB"

systemctl enable mongod &>> $LOGFILE

VERIFY $? "Enabling the mongoDB-server"

systemctl start mongod &>> $LOGFILE

VERIFY $? "Starting the mongoDB-server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VERIFY $? "In Configuration giving all permissions"

systemctl restart mongod &>> $LOGFILE

VERIFY $? "Restarting the mongoDB-server"

