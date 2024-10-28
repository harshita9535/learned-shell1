source common.sh
mysql_root_password=$1
app_dir=/app
component=backend


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
id expense &>>$LOG
if [ $? -ne 0 ]; then
  useradd expense &>>$LOG
fi
Check_Status $?

Print_Task_Heading "Copy Backend Service file"
cp backend.service /etc/systemd/system/backend.service &>>$LOG
Check_Status $?

App_PreReq

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