#!/bin/bash

# 1. Create Variable for store log path
LOG_FILE="$HOME/history.log"

# Creating function for time and date store in log file
log_message(){
    echo "[$(date +'%d-%m-%Y %H:%M')] $1" >> "$LOG_FILE"
    echo "[$(date +'%d-%m-%Y %H:%M')] $1"
}

# 2. Checking nginx is active or not
if ! systemctl is-active --quiet nginx; then
    log_message "CRITICAL: NGINX IS DOWN - ATTEMPTING RESTART"

    sudo systemctl restart nginx

    if systemctl is-active --quiet nginx; then
        log_message "INFO: NGINX RESTARTED SUCCESSFULLY"
    else
        log_message "CRITICAL: NGINX RESTART FAILED"
        exit 1
    fi
fi

# 3. CPU usage check
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.0f", $2}')

if [ "$CPU_USAGE" -gt 85 ]; then
    log_message "CRITICAL: CPU USAGE IS TOO HIGH ${CPU_USAGE}%"
    exit 1
fi

# 4. RAM usage check
RAM_USAGE=$(free | awk 'NR==2 {printf "%.0f", ($3/$2)*100}')

if [ "$RAM_USAGE" -gt 85 ]; then
    log_message "CRITICAL: RAM USAGE IS TOO HIGH ${RAM_USAGE}%"
    exit 1
fi

# 5. Disk usage check
DISK_USAGE=$(df -h / | awk 'NR==2 {printf "%.0f", $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 85 ]; then
    log_message "CRITICAL: DISK USAGE IS TOO HIGH ${DISK_USAGE}%"
    exit 1
fi

# 6. Inode usage check
INODE_USAGE=$(df -i / | awk 'NR==2 {printf "%.0f", $5}' | sed 's/%//')

if [ "$INODE_USAGE" -gt 85 ]; then
    log_message "CRITICAL: INODE USAGE IS TOO HIGH ${INODE_USAGE}%"
    exit 1
fi

# 7. Website health check
if curl -s --head http://localhost | grep -q "200 OK"; then
    log_message "INFO: WEBSITE IS UP"
else
    log_message "CRITICAL: WEBSITE IS DOWN"
    exit 1
fi

# 8. Log error hunting
if grep -i -q "error" "$LOG_FILE"; then
    log_message "CRITICAL: ERROR FOUND IN LOG MESSAGE"
    exit 1
fi

# 9. Final message print
log_message "STATUS OKAY"
exit 0