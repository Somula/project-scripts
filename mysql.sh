#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started at $TIMESTAMP."

if [ $ID -ne 0 ] &>> $LOGFILE
then 
    echo -e "$R Please login as a root user.$N"
    exit 1
else
    echo -e "$G Succesfully your logged in as a root user.$N"
fi

VERIFY(){
    if [ $1 -ne 0 ]  &>> $LOGFILE
    then
        echo -e "$2 is $R Failed$N."
        exit 1
    else
        echo -e "$2 is $G Success$N."
    fi
}
dnf module disable mysql -y &>> $LOGFILE

VERIFY $? "Disabling mysql"

cp /home/centos/project-scripts/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VERIFY $? "Copying the repository file"

dnf install mysql-community-server -y &>> $LOGFILE

VERIFY $? "Installing the mysql"

systemctl enable mysqld &>> $LOGFILE

VERIFY $? "Enabling mysql"

systemctl start mysqld &>> $LOGFILE

VERIFY $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VERIFY $? "Setting the user name and password"


