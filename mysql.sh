source common.sh
mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo Input Password is Missing.
  exit 1
fi

Print_Task_Heading "Install Mysql Server"
dnf install mysql-server -y &>>$LOG
Check_Status $?

Print_Task_Heading "Start Mysql client"
systemctl enable mysqld &>>$LOG
systemctl start mysqld &>>$LOG
Check_Status $?

Print_Task_Heading "Load schema"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOG
Check_Status $?