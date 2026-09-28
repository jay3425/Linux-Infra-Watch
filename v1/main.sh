#!/bin/bash 
 
# 1. Create Variable for store log path 
LOG_FILE="$HOME/history.log" 
 
#Creating function for time and date store in log file 
log_message(){ 
    echo "[$(date +'%d-%m-%Y %H:%M')] $1" >> "$LOG_FILE" 
    echo "[$(date +'%d-%m-%Y %H:%M')] $1" 
} 
 
# 2. Checking nginx is active or not 
systemctl is-active --quiet nginx 
if [ $? -ne 0 ]; then 
    log_message "CRITICAL: NGINX IS DEAD RESTART" 
    exit 1 
fi 
 
# 3.Cpu usage check ("%.0f) is to for floating number 
CPU_USAGE=$(top -bn 1 | grep "Cpu(s)" | awk '{printf "%.0f", $2}') 
if [ "$CPU_USAGE" -gt 85 ]; then 
        log_message "CRITICAL: CPU USAGE IS TOO HIGH ${CPU_USAGE}%" 
        exit 1 
fi 
 
# 4.Ram usage check (NR==2) use for row number 
RAM_USAGE=$(free | awk 'NR==2 {printf "%.0f", ($3/$2)*100}') 
if [ "$RAM_USAGE" -gt 85 ]; then 
        log_message "CRITICAL: RAM USAGE IS TOO HIGH ${RAM_USAGE}%" 
        exit 1 
fi           
# 4.Disk usage check (sed s/%//) 
DISK_USAGE=$(df -h | awk 'NR==2 {printf "%.0f", $5}' | sed 's/%//') 
if [ "$DISK_USAGE" -gt 85 ]; then 
        log_message "CRITICAL: DISK USAGE IS TOO HIGH ${DISK_USAGE}%" 
        exit 1 
fi 
 
# 5.Log error hunting 
if grep -i -q "error" "$LOG_FILE"; then 
        log_message "CRITICAL: ERROR FOUND IN LOG MESSAGE" 
        exit 1 
fi 
 
 
# 6.Final message print 
log_message "STATUS OKAY" 
        exit 0 