#!/bin/bash
USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR::You need to have sudo access to execute"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "Installing $2 Failure"
        exit 1
    else
        echo "Installing $2 Success"
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then
    dnf install mysql -y
    VALIDATE $? "mysql"
else
    echo "MySQL is already installed"
fi

dnf list installed git
if [ $? -ne 0 ]
then
    dnf install git -y
    VALIDATE $? "git"
else
    echo "Git is already installed"
fi