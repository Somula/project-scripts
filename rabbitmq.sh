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
        exit 1
    else
        echo -e "$2 is $G Success. $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e " $R Please log as a root user. $N"
    exit 1
else
    echo -e " $G Successfully logged as a root user. $N"
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VERIFY $? "Installing the erlang package"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VERIFY $? "Installing the rabbitmq-server package"

dnf install rabbitmq-server -y &>> $LOGFILE

VERIFY $? "Installing the rabbitmq-server"

systemctl enable rabbitmq-server &>> $LOGFILE 

VERIFY $? "Enabling rabbitmq-server"

systemctl start rabbitmq-server &>> $LOGFILE

VERIFY $? "Starting rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VERIFY $? "Adding user to the server"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VERIFY $? "setting permissions to the user"