source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo Input Password is Missing.
  exit 1
fi

Print_Task_Heading "Disable default NodeJs Version module"
dnf module disable nodejs -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Enable NodeJs module for V20"
dnf module enable nodejs:20 -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Install NodeJs"
dnf install nodejs -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Adding application user"
useradd expense &>>/tmp/expense.log
cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Clear the old content"
rm -rf /app &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Create app directory"
mkdir /app &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Download the app content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Extract app content"
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Download NodeJs dependencies"
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Start backend service"
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Install mysql client"
dnf install mysql -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Load schema"
mysql -h 172.31.82.191 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>/tmp/expense.log
Check_Status $?