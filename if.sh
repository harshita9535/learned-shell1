simple if

a=$1
if [ $1 -gt 100 ]; then
  echo "$a is greater than 100"
else
  echo "$a is less than 100"
fi

x=$1
if [ -z "$x" ]; then
  echo Input missing
  exit
fi

a=$1
if [ $1 -gt 100 ]; then
  echo "$a is greater than 100"
else
  echo "$a is less than 100"
fi