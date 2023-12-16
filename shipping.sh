#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

if [ $ID -ne 0 ] &>> $LOGFILE
then
    echo -e "$R Please login as root user.$N"
else
    echo -e "$G Succesfully login as root user.$N"
fi

VERIFY(){
    if [ $1 -ne 0 ] &>> $LOGFILE
    then 
        echo -e "$2 is $R Failed$N."
    else
        echo -e "$2 is $G Success$N."
    fi

}

dnf install maven -y &>> $LOGFILE

VERIFY $? "Installing the maven"

id roboshop &>> $LOGFILE
if [ $? -ne 0 ] &>> $LOGFILE
then
    useradd roboshop &>> $LOGFILE
    VERIFY $? "Adding the roboshop user"
    
else
    echo "Your are already a roboshop user"
fi

mkdir -p /app &>> $LOGFILE

VERIFY $? "Creating the app directory"

cd /app &>> $LOGFILE

VERIFY $? "Going into the app directory"

curl -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

VERIFY $? "Downloading the shipping service"

unzip -o /tmp/shipping.zip &>> $LOGFILE

VERIFY $? "Unzipping the shipping service"

mvn clean package &>> $LOGFILE

VERIFY $? "Clean the packages of the service"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE

VERIFY $? "Renaming the file of target/shipping-1.0.jar shipping.jar"

cp /home/centos/project-scripts/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE

VERIFY $? "Importing the shipping.service to /etc/systemd/system/shipping.service"

systemctl daemon-reload &>> $LOGFILE

VERIFY $? "Reloading of the service"

systemctl enable shipping &>> $LOGFILE

VERIFY $? "Enabling of the service"

systemctl start shipping &>> $LOGFILE

VERIFY $? "Starting of the service"

dnf install mysql -y &>> $LOGFILE

VERIFY $? "Installing of the service"

mysql -h mysql.lingaaws.tech -uroot -pRoboShop@1 </app/schema/shipping.sql &>> $LOGFILE

VERIFY $? "Inserting the data into service"

systemctl restart shipping &>> $LOGFILE

VERIFY $? "Restarting of the service"


