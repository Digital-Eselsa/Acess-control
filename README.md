# Linux Task 03 — User Management, Log Analysis & Permissions

A GitHub-ready workflow for completing the Linux Task 03 practical exercise.

## Activity objectives

This exercise covers four parts:

1. **New user setup:** create `forensic01` with a home directory and `/bin/bash`, add the account to `sudo`, set a password, and log in as that user.
2. **Log filtering and analysis:** create `sys_events.log` with at least 20 mock log entries, use `grep`, pipes, redirection, `head`, `tail`, and `cat`.
3. **Permissions and ownership:** create `confidential.txt`, set owner-only read/write permissions, change its owner to `root`, and observe access as `forensic01`.
4. **User management:** create `guest1` and `guest2`, add `guest1` to `sudo`, and remove `guest2` with its home directory.

> Run account-management commands from an existing administrator account with `sudo` privileges. Use a Linux VM or other authorized practice system. Do not use these commands on a production machine.

## Repository structure

```text
Linux_Task_03_GitHub_Workflow/
├── README.md
├── commands_used.txt
├── .gitignore
├── screenshots/
│   └── README.md
├── evidence/
│   ├── README.md
│   ├── log-analysis/
│   ├── permissions/
│   └── user-management/
├── reports/
│   ├── activity-reflection.md
│   └── command-explanations.md
└── scripts/
    └── create_sample_log.sh
```

## Before you begin

- Use a Debian/Ubuntu/Kali-based Linux system for the examples below.
- Open a terminal using an account that can run `sudo`.
- Record the commands you actually execute in `commands_used.txt`.
- Capture your own terminal screenshots and place them in the matching `screenshots/` or `evidence/` folders. Do not submit fabricated screenshots.

Check your current account and system:

```bash
whoami
id
hostname
date
```

## Part 1 — New user setup

### 1. Create `forensic01`

```bash
sudo useradd -m -s /bin/bash forensic01
sudo usermod -aG sudo forensic01
sudo passwd forensic01
```

`passwd` will prompt you to enter and confirm a password. Do not put the password in this repository or in a screenshot.

Verify the account:

```bash
getent passwd forensic01
id forensic01
ls -ld /home/forensic01
```

The account entry should show `/home/forensic01` as its home directory and `/bin/bash` as its login shell. The `id` output should show membership in the `sudo` group.

### 2. Switch to `forensic01`

```bash
su - forensic01
whoami
pwd
```

Expected checks: `whoami` returns `forensic01`; `pwd` returns `/home/forensic01`.

### 3. Create the log directory and sample log

As `forensic01`:

```bash
mkdir -p /home/forensic01/logs
cd /home/forensic01/logs
```

Create the log with `cat` and a here-document:

```bash
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
```

The exercise asks for `cat` and `echo`; here is an additional `echo` append:

```bash
echo "2026-11-24 09:10:00 INFO user01 completed the practice session" >> sys_events.log
```

Verify there are at least 20 lines:

```bash
wc -l sys_events.log
cat sys_events.log
```

## Part 2 — Log filtering and analysis

Run these commands from `/home/forensic01/logs`.

### 1. Search with `grep`

Show every line containing `ERROR`:

```bash
grep "ERROR" sys_events.log
```

Show lines mentioning either `root` or `user01`:

```bash
grep -E "root|user01" sys_events.log
```

### 2. Piping and redirection

Pipe the ERROR results to `less` for paging:

```bash
grep "ERROR" sys_events.log | less
```

Press `q` to exit `less`.

Save the ERROR results to `error_report.txt`:

```bash
grep "ERROR" sys_events.log > error_report.txt
cat error_report.txt
```

Confirm the report exists and inspect it:

```bash
ls -l error_report.txt
wc -l error_report.txt
```

### 3. Use `head` and `tail`

```bash
head -n 5 sys_events.log
tail -n 5 sys_events.log
```

### 4. View the entire log

```bash
cat sys_events.log
```

## Part 3 — Permissions and ownership control

Continue as `forensic01` in the logs directory.

### 1. Create and restrict `confidential.txt`

```bash
echo "This file contains confidential practice data." > confidential.txt
chmod 600 confidential.txt
ls -l confidential.txt
```

Mode `600` means the file owner has read/write access and group/others have no permissions.

### 2. Change ownership to root

```bash
sudo chown root:root confidential.txt
ls -l confidential.txt
```

### 3. Test access as `forensic01`

```bash
cat confidential.txt
echo "Attempted modification" >> confidential.txt
```

Because the file is now owned by `root` and has mode `600`, `forensic01` should receive a permission-denied error when trying to read or modify it. This is the expected demonstration. Do not change the permissions merely to force a successful read.

For an administrator-side verification, run:

```bash
sudo cat /home/forensic01/logs/confidential.txt
```

## Part 4 — User management commands

You may open a second terminal or return to your original administrator account. If you are still in the `forensic01` shell, leave it with:

```bash
exit
```

Create the two temporary users:

```bash
sudo useradd -m -s /bin/bash guest1
sudo useradd -m -s /bin/bash guest2
```

Add `guest1` to the `sudo` group:

```bash
sudo usermod -aG sudo guest1
```

Verify:

```bash
id guest1
getent passwd guest2
```

Remove `guest2`, including its home directory:

```bash
sudo userdel -r guest2
```

Verify removal:

```bash
getent passwd guest2
ls -ld /home/guest2
```

A no-result response from `getent` and a “No such file or directory” response for `/home/guest2` indicate that the account and home directory were removed.

## Submission checklist

- [ ] `commands_used.txt` contains the commands actually run, in execution order.
- [ ] Screenshots show user creation and verification.
- [ ] Screenshots show the log file and its line count.
- [ ] Screenshots show `grep`, `less` (optional), redirection/report, `head`, `tail`, and `cat` results.
- [ ] Screenshots show `confidential.txt` permissions before/after `chown` and the access-denied test.
- [ ] Screenshots show `guest1` group membership and `guest2` removal.
- [ ] `reports/command-explanations.md` is completed.
- [ ] `reports/activity-reflection.md` is completed.
- [ ] No passwords, private data, or fabricated evidence are committed.

## Suggested Git workflow

From the repository directory:

```bash
git init
git add .
git status
git commit -m "Document Linux Task 03 practical activity"
```

Create an empty GitHub repository, connect it using the repository URL GitHub provides, then:

```bash
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY_URL
git push -u origin main
```

Replace `YOUR_GITHUB_REPOSITORY_URL` with your own repository URL. Do not include credentials or tokens in the remote URL.
