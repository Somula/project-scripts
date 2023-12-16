#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP"

echo "Scripting started at $TIMESTAMP"

VERIFY(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R Failed.$N"
        exit 1
    else
        echo -e "$2 is $G Success.$N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R Please log in as root user. $N"
    exit 1
else
    echo -e "$G Successfully logged in as root user. $N"
fi

dnf module disable nodejs -y &>> $LOGFILE

VERIFY $? "Nodejs is disabled"

dnf module enable nodejs:18 -y &>> $LOGFILE

VERIFY $? "Nodejs is enabled"

dnf install nodejs -y &>> $LOGFILE

VERIFY $? "Installing the nodejs is"

id roboshop  &>> $LOGFILE
if [ $? -ne 0 ]
then
    useradd roboshop  &>> $LOGFILE
    VERIFY $? "Adding the user"
else
    echo "Successfully already created the user"
fi


mkdir -p /app  &>> $LOGFILE

VERIFY $? "Creating the directory"

cd /app  &>> $LOGFILE

VERIFY $? "going into the directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOGFILE

VERIFY $? "downloading the application"

unzip -o /tmp/cart.zip  &>> $LOGFILE

VERIFY $? "Unzipping the zip file"

npm install  &>> $LOGFILE

VERIFY $? "Packages installing"

cp /home/centos/project-scripts/cart.service /etc/systemd/system/cart.service  &>> $LOGFILE

VERIFY $? "Creating the cart.service"

systemctl daemon-reload  &>> $LOGFILE

VERIFY $? "Loading the cart.service"

systemctl enable cart  &>> $LOGFILE

VERIFY $? "Enabling the cart.service"

systemctl start cart  &>> $LOGFILE

VERIFY $? "Starting the cart.service"






