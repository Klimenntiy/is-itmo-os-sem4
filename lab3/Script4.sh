#!/bin/bash

echo "#!/bin/bash
while true
do
    echo \$((2 * 2)) > /dev/null
done" > /tmp/multiply_numbers.sh

chmod +x /tmp/multiply_numbers.sh

nice -n 10 /tmp/multiply_numbers.sh &  
PID1=$!

nice -n 10 /tmp/multiply_numbers.sh &  
PID2=$!

nice -n 10 /tmp/multiply_numbers.sh &  
PID3=$!

echo "$PID1" > /tmp/pid1.txt
echo "$PID2" > /tmp/pid2.txt
echo "$PID3" > /tmp/pid3.txt

echo "Процессы запущены: PID1=$PID1, PID2=$PID2, PID3=$PID3"
