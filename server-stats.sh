#!/bin/bash

echo "---------------This script will display all your system vitals------------------"

total_cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", 100 - $8}')

echo "Total CPU Usage: $total_cpu_usage"

read total used <<< $(free -m | awk '/Mem:/ {print $2, $3}')
memory_usage=$(awk -v u=$used -v t=$total 'BEGIN { printf "%.1f%%", u/t * 100 }')
echo "Memory Usage: $used MB / $total MB ($memory_usage)"

read total used avail percent <<< $(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
echo "Disk Usage: $used / $total ($percent used, $avail available)"

echo "-----------------------------"
echo "Top 5 Processes by CPU Usage"
echo "-----------------------------"

ps -eo pid,comm,%cpu --sort=-%cpu | sed 1d | head -n 5

echo "-------------------------------"
echo "Top 5 Processes by Memory Usage"
echo "-------------------------------"

ps -eo pid,comm,%mem --sort=-%mem | sed 1d | head -n 5
