Num=$1
if [ $Num -gt 100 ]
then
    echo "$Num is greater than 100"
    exit 1
else
    echo "Given number is less than or equal to 100"
    exit 1
fi