#!/bin/bash

#Check if CPU load is above 2
cpuuse=$(cat /proc/loadavg | awk '{print $1}'|cut -f 1 -d ".")
if [ "$cpuuse" -ge 2 ]; then

SUBJECT="ATTENTION: CPU load is high on sportshare server $(hostname) at $(date)"
MESSAGE="/tmp/Mail.out"
MAIL_SCRIPT="/root/sendmail.py"
  echo "$SUBJECT" > $MESSAGE 
  echo "" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "CPU current usage is: $(cat /proc/loadavg | awk '{print $1}')%" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "Top processes which consuming high CPU" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "$(top -cbn1 | head -30)" >> $MESSAGE
  echo "" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "Top Processes which consuming high CPU using the ps command" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -20)" >> $MESSAGE
  echo "" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "Details of processes which consuming high CPU" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "$(ps -eo pcpu,pid | sort -k 1 -r | head -20 | awk '{print $2}' | tail -n +2 | 
        while read -r pid  
            do lsof -p $pid 
            echo -e  "===================\n===================\n" 
            done)" >> $MESSAGE
  echo "" >> $MESSAGE            
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "All TCP/UDP Connections Established" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "$(netstat -anp |grep 'tcp\|udp' | grep ESTABLISHED)" >> $MESSAGE
  echo "" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  echo "List of IPs Connected to port 443" >> $MESSAGE
  echo "$(netstat -plan  | grep  :443 | awk {'print $5'} | cut -d: -f1 |sort |uniq -c|sort -n)" >> $MESSAGE
  echo "" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE
  
  /usr/bin/python3 $MAIL_SCRIPT $(echo "$SUBJECT")

#   rm $MESSAGE
else
  echo "Server CPU usage is in under threshold"
fi