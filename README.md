# 🔍 InfraWatch - Linux Infrastructure Monitoring System

InfraWatch is an automated Linux infrastructure monitoring and self-healing system built using **Bash Shell Scripting, Linux, Cron, and AWS EC2**.

The project monitors CPU, RAM, disk space, inode usage, Nginx service health, and website availability. It also generates system health reports, maintains logs, automatically restarts failed Nginx services, and uses Linux `logrotate` for log management.

The project was developed progressively through **three versions (V1 → V2 → V3)**.

---

## 🚀 Project Evolution

### V1 - Basic Infrastructure Monitoring

The first version focused on monitoring essential Linux system resources.

**Features**
- Nginx service monitoring
- CPU usage monitoring
- RAM usage monitoring
- Disk usage monitoring
- Log error detection
- Timestamped monitoring logs
- Cron-based automation

### V2 - Self-Healing & Health Monitoring

V2 extended InfraWatch from monitoring to automated recovery.

**New Features**
- Automatic Nginx restart
- Website health check
- Inode usage monitoring
- Improved failure detection

Example:

```text
CRITICAL: NGINX IS DOWN - ATTEMPTING RESTART
INFO: NGINX RESTARTED SUCCESSFULLY
INFO: WEBSITE IS UP
STATUS OKAY
```

### V3 - Reporting, Alerts & Log Management

V3 introduced system reporting, warning thresholds, and log rotation.

**New Features**
- System performance reports
- `report.log`
- CPU/RAM/Disk/Inode statistics
- Hostname and timestamp information
- Nginx status reporting
- Website status reporting
- INFO / WARNING / CRITICAL alert levels
- Linux logrotate integration
- Compressed historical logs

### Alert Levels

| Resource Usage | Status |
|---|---|
| < 70% | Normal |
| 70% - 85% | WARNING |
| > 85% | CRITICAL |

---

# 🛠️ Technology Stack

- **Linux**
- **Bash Shell Scripting**
- **Cron**
- **systemd**
- **Nginx**
- **AWK**
- **grep**
- **sed**
- **curl**
- **df**
- **free**
- **top**
- **logrotate**
- **AWS EC2**

---

# 📊 Monitoring Capabilities

| Component | Monitoring |
|---|---|
| Nginx | Service health |
| CPU | Usage percentage |
| RAM | Usage percentage |
| Disk | Filesystem usage |
| Inodes | Inode usage |
| Website | HTTP availability |
| Logs | Error detection |
| System | Performance reports |

---

# 📁 Project Structure

```text
Linux-Infra-Watch/
│
├── v1/
│   └── main.sh
│
├── v2/
│   └── main2.sh
│
├── v3/
│   └── main3.sh
│
└── README.md
```

### Script Versions

```text
main.sh
   ↓
V1 - Basic Monitoring

main2.sh
   ↓
V2 - Self-Healing + Health Checks

main3.sh
   ↓
V3 - Reporting + Alerts + Log Management
```

> Runtime files such as `history.log` and `report.log` should generally be excluded from Git tracking.

---

# ⏰ Cron Automation

InfraWatch can be scheduled using Linux Cron.

Edit the Cron table:

```bash
crontab -e
```

Example:

```cron
* * * * * /home/ec2-user/main3.sh
```

This executes InfraWatch every minute.

Monitoring results are stored in:

```text
history.log
```

System reports are stored in:

```text
report.log
```

---

# 🧹 Log Rotation

InfraWatch uses Linux `logrotate` to prevent `history.log` from growing indefinitely.

Configuration:

```text
/etc/logrotate.d/infrawatch
```

Example:

```text
/home/ec2-user/history.log {
    weekly
    rotate 4
    compress
    missingok
    notifempty
    copytruncate
}
```

This provides:

- Weekly log rotation
- Four historical log files
- Compression of old logs
- Safe handling of missing/empty logs
- Continuous writing without stopping the monitoring process

Example:

```text
history.log
history.log.1.gz
history.log.2.gz
history.log.3.gz
history.log.4.gz
```

---

# ☁️ AWS EC2 Deployment

InfraWatch was deployed and tested on an **AWS EC2 Linux instance**.

Deployment flow:

```text
AWS EC2
   │
   ↓
Linux Environment
   │
   ↓
Install Nginx
   │
   ↓
Deploy InfraWatch
   │
   ↓
Configure Cron
   │
   ↓
Monitor Server
```

The project was tested with real Nginx service failures, including stopping Nginx and verifying that InfraWatch automatically restarted it.

---

# 🧪 Testing

## Nginx Failure Test

Stop Nginx:

```bash
sudo systemctl stop nginx
```

Run InfraWatch:

```bash
./main3.sh
```

Expected:

```text
CRITICAL: NGINX IS DOWN - ATTEMPTING RESTART
INFO: NGINX RESTARTED SUCCESSFULLY
INFO: WEBSITE IS UP
STATUS OKAY
```

Verify:

```bash
systemctl status nginx
```

Expected:

```text
Active: active (running)
```

---

## Inode Monitoring Test

Check inode usage:

```bash
df -i /
```

InfraWatch automatically checks the configured inode threshold.

---

## Website Health Test

Check the local web server:

```bash
curl -I http://localhost
```

A successful HTTP response is detected by InfraWatch.

---

## Log Rotation Test

Force log rotation:

```bash
sudo logrotate -f /etc/logrotate.d/infrawatch
```

Check rotated logs:

```bash
ls -lh ~/history.log*
```

---

# 📄 Example System Report

InfraWatch generates a report similar to:

```text
========== INFRAWATCH SYSTEM REPORT ==========
DATE        : 28-09-2026 08:52:37
HOSTNAME    : ip-172-31-6-165.ap-southeast-1.compute.internal
CPU USAGE   : 3%
RAM USAGE   : 5%
DISK USAGE  : 9%
INODE USAGE : 1%
NGINX STATUS: active
WEBSITE STATUS: UP
==============================================
```

---

# 🎯 Project Objectives

- Automate Linux server health monitoring
- Detect infrastructure failures
- Reduce manual server checks
- Automatically recover from Nginx failures
- Track system resource utilization
- Generate historical performance reports
- Implement automated log management
- Practice Linux administration and shell scripting
- Demonstrate DevOps monitoring and automation concepts

---

# 📚 DevOps Concepts Demonstrated

- Linux system administration
- Bash scripting
- Shell automation
- Process and service management
- systemd
- Nginx
- Cron jobs
- Resource monitoring
- Log management
- Log rotation
- Error detection
- Self-healing infrastructure
- AWS EC2
- Basic production monitoring concepts

---

# 🔮 Future Improvements

Possible future enhancements:

- Email alerts
- Slack/Discord notifications
- Web-based monitoring dashboard
- Prometheus integration
- Grafana dashboards
- Docker deployment
- GitHub Actions CI/CD
- Infrastructure deployment using Terraform
- Centralized log management
- Monitoring multiple EC2 instances

---

# 👨‍💻 Author

**Jay Dengle**

Computer Science & Engineering

Interested in:

- DevOps
- Cloud Computing
- Linux
- AWS
- Automation
- Infrastructure Monitoring

---

## ⭐ Project Summary

**InfraWatch** started as a simple Bash-based Linux monitoring script and evolved into an automated infrastructure monitoring system with **self-healing, health checks, performance reporting, alert levels, Cron automation, and log rotation**.

> **Monitor → Detect → Recover → Report → Automate**
