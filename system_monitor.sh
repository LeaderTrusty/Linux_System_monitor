#!/bin/bash

# Default threshold values (in percentage)
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Function to send an alert
send_alert() {
  echo "$(tput setaf 1)ALERT: $1 usage exceeded threshold! Current value: $2%$(tput sgr0)"
}

# Main monitoring loop
while true; do
  # Monitor CPU usage
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  cpu_usage=${cpu_usage%.*}
  if ((cpu_usage >= CPU_THRESHOLD)); then
    send_alert "CPU" "$cpu_usage"
  fi

  # Monitor memory usage
  memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')
  memory_usage=${memory_usage%.*}
  if ((memory_usage >= MEMORY_THRESHOLD)); then
    send_alert "Memory" "$memory_usage"
  fi

  # Monitor disk usage
  disk_usage=$(df -h / | awk '/\// {print $(NF-1)}')
  disk_usage=${disk_usage%?}
  if ((disk_usage >= DISK_THRESHOLD)); then
    send_alert "Disk" "$disk_usage"
  fi

  # Display current resource usage
  clear
  echo "Resource Usage:"
  echo "CPU: $cpu_usage%"
  echo "Memory: $memory_usage%"
  echo "Disk: $disk_usage%"

  # TODO: Add logging functionality here
  # Use the current date and time, along with CPU, memory, and disk usage values.
  # Save this information to a file named 'resource_usage.log'.
  # After calculating resource usage values, add the following code:

  # Log resource usage to a file
  log_entry="$(date '+%Y-%m-%d %H:%M:%S') CPU: $cpu_usage% Memory: $memory_usage% Disk: $disk_usage%"
  echo "$log_entry" >> /home/labex/project/resource_usage.log
  
  sleep 2
done
