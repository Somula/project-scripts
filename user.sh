#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"

VERIFY(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is $R FAILED.$N"
    else
        echo -e "$2 is $G SUCCESS.$N"
    fi
}

if [ $ID -ne 0  ] &>> $LOGFILE
then
    echo -e "$R Please logging as a root user.$N"
    
else
    echo -e "$G Successfully logging as a root user.$N"
fi

dnf module disable nodejs -y &>> $LOGFILE

VERIFY $? "Disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VERIFY $? "Enabling nodejs"

dnf install nodejs -y  &>> $LOGFILE

VERIFY $? "Installing nodejs"

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]
then
    useradd roboshop  &>> $LOGFILE
    VERIFY $? "Adding the user"
else
    echo -e "$G Already logged as a user.$N" &>> $LOGFILE
fi

mkdir -p /app &>> $LOGFILE

VERIFY $? "Creating a app directory"

cd /app &>> $LOGFILE

VERIFY $? "Opening the app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VERIFY $? "Downloading the file"

unzip /tmp/user.zip &>> $LOGFILE

VERIFY $? "Unzipping the file"

npm install &>> $LOGFILE

VERIFY $? "Installing the packages"

cp /home/centos/project-scripts/user.service /etc/systemd/system/user.service &>> $LOGFILE

VERIFY $? "Creating the user service"

systemctl daemon-reload &>> $LOGFILE

VERIFY $? "Reloading the user service"

systemctl enable user &>> $LOGFILE

VERIFY $? "Enable the user service"

systemctl start user &>> $LOGFILE

VERIFY $? "Starting the user service"

cp /home/centos/project-scripts/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VERIFY $? "Creating a mongo repository"

dnf install mongodb-org-shell -y &>> $LOGFILE

VERIFY $? "Installing the mongodb-client"

mongo --host mongodb.lingaaws.tech </app/schema/user.js &>> $LOGFILE

VERIFY $? "Inserting the data into the database"

systemctl restart user &>> $LOGFILE

VERIFY $? "Restarting the user service"

