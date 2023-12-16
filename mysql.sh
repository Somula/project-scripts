#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started at $TIMESTAMP."

if [ $ID -e 0 ]
then 
    echo -e "$G Succesfully your logged in as a root user.$N"
else
    echo -e "$R Please login as a root user.$N"
fi

VERIFY(){
    if [ $1 -e 0 ]
    then
        echo -e "$2 is $G Success$N."
    else
        echo -e "$2 is $R Failed$N."
    fi
}
dnf module disable mysql -y

VERIFY $? "Disabling mysql"

cp /home/centos/project-scripts/mysql.repo /etc/yum.repos.d/mysql.repo

VERIFY $? "Copying the repository file"

dnf install mysql-community-server -y

VERIFY $? "Installing the mysql"

systemctl enable mysqld

VERIFY $? "Enabling mysql"

systemctl start mysqld

VERIFY $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1

VERIFY $? "Setting the user name and password"

mysql -uroot -pRoboShop@1

VERIFY $? "Login as username and password"
