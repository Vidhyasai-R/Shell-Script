#!/bin/bash
LOG_FOLDER=/var/log/Backend-logs
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

dnf module disable nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "Disabling existing default NodeJs"

dnf module enable nodejs:20 -y &>>$LOG_FILE_NAME
VALIDATE $? "Enabling NodeJs:20"

dnf install nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing NodeJS"

useradd expense &>>$LOG_FILE_NAME
VALIDATE $? "Adding expense user"

mkdir /app &>>$LOG_FILE_NAME
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading Backend"

cd /app &>>$LOG_FILE_NAME

unzip /tmp/backend.zip &>>$LOG_FILE_NAME
VALIDATE $? "Unzipping backend"

npm install &>>$LOG_FILE_NAME
VALIDATE $? "Installing Dependencies"

cp /opt/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing MySQL client"

mysql -h mysql.daws-82s.site -u root -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE_NAME
VALIDATE $? "Setting up the transactions schema and tables"

systemctl daemon-reload &>>$LOG_FILE_NAME
VALIDATE $? "Daemon reload"

systemctl start backend &>>$LOG_FILE_NAME
VALIDATE $? "Starting backend"

systemctl enable backend &>>$LOG_FILE_NAME
VALIDATE $? "Enabling backend"

systemctl restart backend &>>$LOG_FILE_NAME
VALIDATE $? "Restarting backend"