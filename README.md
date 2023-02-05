# GH-PR-NOTIFY

This repository is for notifying a user when their Github PRs change status from reviewers, as well as the user being assigned any PRs.

Notification is via the notify-send command, as well email?

## Prerequisites
* libnotify (https://wiki.archlinux.org/title/Desktop_notifications)
* github-cli (https://github.com/cli/cli)
* postfix (for emailing)

Setup the script to run in cron
i.e.
```bash
# Note: "1000" would be your user id, the output of... "id -u <username>"
* * * * * cd ~/gh-pr-notify && DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus ./run.sh
```


