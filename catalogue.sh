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

dnf module disable nodejs -y

VERIFY $? "Nodejs is disabled"

dnf module enable nodejs:18 -y

VERIFY $? "Nodejs is enabled"

dnf install nodejs -y

VERIFY $? "Installing the nodejs is"

useradd roboshop

VERIFY $? "Adding the user"

mkdir /app

VERIFY $? "Creating the directory"

cd /app

VERIFY $? "going into the directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VERIFY $? "downloading the application"

unzip /tmp/catalogue.zip

VERIFY $? "Unzipping the zip file"

npm install

VERIFY $? "Packages installing"

cp /home/centos/project-scripts/catalogue.service /etc/systemd/system/catalogue.service

VERIFY $? "Creating the catalogue.service"

systemctl daemon-reload

VERIFY $? "Loading the catalogue.service"

systemctl enable catalogue

VERIFY $? "Enabling the catalogue.service"

systemctl start catalogue

VERIFY $? "Starting the catalogue.service"

cp /home/centos/project-scripts/mongo.repo /etc/mongo.repo

VERIFY $? "Copying the mongo.repo file into configuration directory"

dnf install mongodb-org-shell -y

VERIFY $? "Installing the mongodb "

mongo --host mongodb.lingaaws.tech </app/schema/catalogue.js

VERIFY $? "Inserting the catalogue.js data into mongodb database"

systemctl restart catalogue

VERIFY $? "Restarting the catalogue.service"




