source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo Input Password is Missing.
  exit 1
fi

Print_Task_Heading "Disable default NodeJs Version module"
dnf module disable nodejs -y &>>$LOG
Check_Status $?

Print_Task_Heading "Enable NodeJs module for V20"
dnf module enable nodejs:20 -y &>>$LOG
Check_Status $?

Print_Task_Heading "Install NodeJs"
dnf install nodejs -y &>>$LOG
Check_Status $?

Print_Task_Heading "Adding application user"
id expense
if [ $? -ne 0 ]; then
  useradd expense &>>$LOG
fi
cp backend.service /etc/systemd/system/backend.service &>>$LOG
Check_Status $?

Print_Task_Heading "Clear the old content"
rm -rf /app &>>$LOG
Check_Status $?

Print_Task_Heading "Create app directory"
mkdir /app &>>$LOG
Check_Status $?

Print_Task_Heading "Download the app content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>$LOG
Check_Status $?

Print_Task_Heading "Extract app content"
cd /app &>>$LOG
unzip /tmp/backend.zip &>>$LOG
Check_Status $?

Print_Task_Heading "Download NodeJs dependencies"
cd /app &>>$LOG
npm install &>>$LOG
Check_Status $?

Print_Task_Heading "Start backend service"
systemctl daemon-reload &>>$LOG
systemctl enable backend &>>$LOG
systemctl start backend &>>$LOG
Check_Status $?

Print_Task_Heading "Install mysql client"
dnf install mysql -y &>>$LOG
Check_Status $?

Print_Task_Heading "Load schema"
mysql -h 172.31.82.191 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOG
Check_Status $?