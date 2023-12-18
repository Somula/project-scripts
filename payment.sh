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

dnf install python36 gcc python3-devel -y  &>> $LOGFILE

VERIFY $? "Installing the python"

id roboshop  &>> $LOGFILE
if [ $? -ne 0 ]
then
    useradd roboshop  &>> $LOGFILE
    VERIFY $? "Adding the user"
else
    echo "Successfully already created the user"
fi

mkdir -p /app  &>> $LOGFILE

VERIFY $? "Creating the app directory"

curl -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip  &>> $LOGFILE

VERIFY $? "Downloading the application"

cd /app  &>> $LOGFILE

VERIFY $? "Opening the app directory"

unzip /tmp/payment.zip  &>> $LOGFILE

VERIFY $? "Unzipping the payment file"

pip3.6 install -r requirements.txt  &>> $LOGFILE

VERIFY $? "Installing the application packages" 

cp /home/centos/project-scripts/payment.service /etc/systemd/system/payment.service  &>> $LOGFILE

VERIFY $? "Creating the payment service"

systemctl daemon-reload  &>> $LOGFILE

VERIFY $? "system daemon-reload"

systemctl enable payment  &>> $LOGFILE

VERIFY $? "Enable the payment service"

systemctl start payment  &>> $LOGFILE

VERIFY $? "Starting payment service"




