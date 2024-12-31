#!/bin/bash
userid=$(id -u)
if [ $userid -ne 0]
then
    echo "ERROR:: You must have sudo access to this script"
    exit 1
fi

dnf list installed mysql
if [ $? -ne 0]
then
    dnf install mysql -y
    if [ $? -ne 0 ]
    then
        echo "Installing MySQL ...Failure"
        exit 1
    else
        echo "Installing MySQL ...Success"
    fi
else
    echo "MySQL is already installed"
fi

dnf list installed git
if [ $? -ne 0]
then
    dnf install git -y
    if [ $? -ne 0 ]
    then
        echo "Installing Git ...Failure"
        exit 1
    else
        echo "Installing Git ...Success"
    fi
else
    echo "Git is already installed"
fi

