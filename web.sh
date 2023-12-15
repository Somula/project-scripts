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
if [ $? -ne 0 ] &>> $LOGOFILE
then 
    echo -e "$R Please logging as root user.$N"
    sudo su &>> $LOGOFILE
    VERIFY $? "Logging as root user"
else
    echo -e "$G Already your a root user. $N"
fi

dnf install nginx -y &>> $LOGOFILE

VERIFY $? "Installing the nginx"

systemctl enable nginx &>> $LOGOFILE

VERIFY $? "Enabling the nginx"

systemctl start nginx &>> $LOGOFILE

VERIFY $? "Starting the nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGOFILE

VERIFY $? "Removing the default html file"

cd /usr/share/nginx/html &>> $LOGOFILE

VERIFY $? "Opening the /usr/share/nginx/html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGOFILE

VERIFY $? "Downloading the application"

unzip /tmp/web.zip &>> $LOGOFILE

VERIFY $? "Unzipping the application"

cp /home/centos/project-scripts/roboshop.conf /usr/nginx/default.d/roboshop.conf &>> $LOGOFILE

VERIFY $? "Creating the roboshop.conf file"

systemctl restart nginx &>> $LOGOFILE

VERIFY $? "Restarting the application nginx"
