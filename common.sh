Print_Task_Heading() {
  echo $1
  echo "#################### $1 ########################" &>>/tmp/expense.log
}

Check_Status() {
  if [ $? -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi
}