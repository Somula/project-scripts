#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP"

echo "Script started at $TIMESTAMP"

VERIFY(){
    if [ $1 -ne 0]
    then
        echo -e "$2 is $R Failed.$N"
    else
        echo -e "$2 is $G Success.$N"
    fi
}

if [ $? -ne 0 ] &>> $LOGFILE
then 
    echo -e "$R Please logging as root user.$N"
    sudo su &>> $LOGFILE
    VERIFY $? "Succesfully logged as root user."
else
    echo -e "$G Already your a root user. $N"
fi

dnf install nginx -y &>> $LOGFILE

VERIFY $? "Installing the nginx"

systemctl enable nginx &>> $LOGFILE

VERIFY $? "Enabling the nginx"

systemctl start nginx &>> $LOGFILE

VERIFY $? "Starting the nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VERIFY $? "Removing the default html file"

cd /usr/share/nginx/html &>> $LOGFILE

VERIFY $? "Opening the /usr/share/nginx/html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

VERIFY $? "Downloading the application"

unzip /tmp/web.zip &>> $LOGFILE

VERIFY $? "Unzipping the application"

cp /home/centos/project-scripts/roboshop.conf /usr/nginx/default.d/roboshop.conf &>> $LOGFILE

VERIFY $? "Creating the roboshop.conf file"

systemctl restart nginx &>> $LOGFILE

VERIFY $? "Restarting the application nginx"
