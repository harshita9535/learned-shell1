simple if
x=$1
if [ $x -gt 100 ]; then
  echo "$x is greater than 100"
else
  echo "$x is less than 100"
fi


x=$1

if [ -z "$x" ]; then
  echo Input Missing
  exit
fi

if [ $x -gt 100 ]; then
  echo "$x is greater than 100"
else
  echo "$x is less than 100"
fi