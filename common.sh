LOG=/tmp/expense.log
app_dir=${app_dir}
component=${component}

Print_Task_Heading() {
  echo $1
  echo "#################### $1 ########################" &>>$LOG
}

Check_Status() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
  fi
}

App_PreReq() {

  Print_Task_Heading "Clear the old content"
  rm -rf ${app_dir} &>>$LOG
  Check_Status $?

  Print_Task_Heading "Create app directory"
  mkdir ${app_dir} &>>$LOG
  Check_Status $?

  Print_Task_Heading "Download the app content"
  curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/expense-${component}-v2.zip &>>$LOG
  Check_Status $?

  Print_Task_Heading "Extract app content"
  cd ${app_dir} &>>$LOG
  unzip /tmp/${component}.zip &>>$LOG
  Check_Status $?
}