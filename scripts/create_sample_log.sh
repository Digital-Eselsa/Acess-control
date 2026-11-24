#!/usr/bin/env bash
# Optional helper: creates the activity's sample log using cat and echo.
# Run this script as forensic01, from /home/forensic01/logs.

set -euo pipefail

mkdir -p /home/forensic01/logs
cd /home/forensic01/logs

cat > sys_events.log <<'EOF'
2026-11-24 08:00:01 INFO system boot completed
2026-11-24 08:02:14 INFO user01 logged in from 192.168.1.20
2026-11-24 08:05:33 WARNING failed login attempt for user01
2026-11-24 08:07:10 ERROR authentication service timeout
2026-11-24 08:10:45 INFO root started scheduled maintenance
2026-11-24 08:12:02 ERROR disk read operation failed
2026-11-24 08:15:19 INFO network interface eth0 is up
2026-11-24 08:18:44 WARNING high memory usage detected
2026-11-24 08:20:01 INFO user01 accessed /var/log
2026-11-24 08:22:17 ERROR permission denied for user01
2026-11-24 08:25:30 INFO root updated system package list
2026-11-24 08:27:48 WARNING multiple failed authentication attempts
2026-11-24 08:30:05 INFO backup process started
2026-11-24 08:33:12 ERROR backup process could not access source
2026-11-24 08:36:29 INFO user01 logged out
2026-11-24 08:40:00 INFO root checked system status
2026-11-24 08:43:16 WARNING unusual network traffic observed
2026-11-24 08:46:51 ERROR service restart failed
2026-11-24 08:50:22 INFO firewall rules loaded
2026-11-24 08:55:09 INFO system monitoring active
2026-11-24 09:00:31 ERROR authentication log write failed
2026-11-24 09:05:47 WARNING storage space below threshold
EOF

echo "2026-11-24 09:10:00 INFO user01 completed the practice session" >> sys_events.log
echo "Created $(wc -l < sys_events.log) log entries in $(pwd)/sys_events.log"
