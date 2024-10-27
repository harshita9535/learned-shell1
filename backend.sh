mysql_root_password=$1

Print_Task_Heading() {
  echo $1
}
Print_Task_Heading "Disable default NodeJs Version module"
dnf module disable nodejs -y &>>/tmp/expense.log
echo $?

echo Enable NodeJs module for V20
dnf module enable nodejs:20 -y &>>/tmp/expense.log
echo $?

echo Install NodeJs
dnf install nodejs -y &>>/tmp/expense.log
echo $?

echo Adding application user
useradd expense &>>/tmp/expense.log
cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log
echo $?

echo Clear the old content
rm -rf /app &>>/tmp/expense.log
echo $?

echo Create app directory
mkdir /app &>>/tmp/expense.log
echo $?

echo Download the app content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
echo $?

echo Extract app content
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
echo $?

echo Download NodeJs dependencies
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
echo $?

echo Start backend service
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
echo $?

echo Install mysql client
dnf install mysql -y &>>/tmp/expense.log
echo $?

echo Load schema
mysql -h 172.31.82.191 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>/tmp/expense.log
echo $?