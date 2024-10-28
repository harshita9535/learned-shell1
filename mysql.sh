source common.sh

Print_Task_Heading "Install Mysql Server"
dnf install mysql-server -y &>>$LOG
Check_Status $?

Print_Task_Heading "Start Mysql client"
systemctl enable mysqld &>>$LOG
systemctl start mysqld &>>$LOG
Check_Status $?

Print_Task_Heading "Load schema"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG
Check_Status $?