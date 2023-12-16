#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

id [ $ID -e 0 ]
then
    echo -e "$G Succesfully login as root user.$N"
else
    echo -e "$R Please login as root user.$N"
fi

VERIFY(){
    if [ $1 -e 0 ]
    then 
        echo -e "$2 is $G Success$N."
    else
        echo -e "$2 is $G Failed$N."
    fi

}

dnf install maven -y

VERIFY $? "Installing the maven"

id roboshop
if [ $? -e 0 ]
then
    echo "Your are already a roboshop user"
else
    useradd roboshop
    VERIFY $? "Adding the roboshop user"
fi

mkdir -p /app

VERIFY $? "Creating the app directory"

cd /app

VERIFY $? "Going into the app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

VERIFY $? "Downloading the shipping service"

unzip /tmp/shipping.zip

VERIFY $? "Unzipping the shipping service"

mvn clean packages

VERIFY $? "Clean the packages of the service"

mv target/shipping-1.0.jar shipping.jar

VERIFY $? "Renaming the file of target/shipping-1.0.jar shipping.jar"

cp /home/centos/project-scripts/shipping.service /etc/systemd/system/shipping.service

VERIFY $? "Importing the shipping.service to /etc/systemd/system/shipping.service"

systemctl daemon-reload

VERIFY $? "Reloading of the service"

systemctl enable shipping

VERIFY $? "Enabling of the service"

systemctl start shipping

VERIFY $? "Starting of the service"

dnf install mysql -y

VERIFY $? "Installing of the service"

mysql -h @mysql.lingaaws.tech -uroot -pRoboShop@1 </app/schema/shipping.sql

VERIFY $? "Inserting the data into service"

systemctl restart shipping

VERIFY $? "Restarting of the service"


