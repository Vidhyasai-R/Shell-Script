#!/bin/bash
LOG_FOLDER=/var/log/DB-logs
LOG_FILE=$(echo "$0" | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE-$TIME_STAMP.log"

CHECKROOT(){
    USERID=$(id -u)
    if [ $USERID -ne 0 ]
    then
        echo "ERROR::You need to have sudo access to execute"
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 ... FAILURE"
        exit 1
    else
        echo "$2 ... SUCCESS"
    fi
}

echo "Script started executing at :: $TIMESTAMP" &>>$LOG_FILE_NAME
CHECKROOT

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing...MySQL"
systemctl enable mysqld
VALIDATE $? "Enabling...MySQL"
systemctl start mysqld
VALIDATE $? "Starting...MySQL"

mysql -h mysql.daws-82s.site -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME
if [ $? -ne 0 ]
then
    echo "MySQL root password not setup" &>>$LOG_FILE_NAME
else
    echo "MySQL root password already setup ... SKIPPING"
fi

VALIDATE $? "Setting root password"