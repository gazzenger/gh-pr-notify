#!/bin/bash
#PAGER=""

# Check for internet connection
if [[ $(curl -s -D - http://www.gstatic.com/generate_204 2>/dev/null | head -1 | cut -d' ' -f 2) != "204" ]]; then
    exit 1
fi

#LOG_FILE=./output.log
LAST_VALUE_FILE=./last-value

# grab last minute
latest_minute=$(date +"%Y-%m-%dT%H:%M:00%:z")

# grab any previous value from file
if [ -e $LAST_VALUE_FILE ]; then
    prev_value=$(< $LAST_VALUE_FILE )
else
    # generate the previous minute
    prev_value=$(date +"%Y-%m-%dT%H:%M:00%:z" --date '-1 month')    
fi


# Output latest_minute value to file for reading next run
echo $latest_minute > $LAST_VALUE_FILE

# standard filters
STATE_FILTER=open
DRAFT_FILTER=false

#printf 'Checking from %s to %s\n' $prev_value $latest_minute >> $LOG_FILE

# PRs with change_request
change_request_urls=$(gh search prs --state=$STATE_FILTER --draft=$DRAFT_FILTER --author=@me --review changes_requested --updated="$prev_value..$latest_minute" --json url --jq ".[].url")

# PRs with approval
approved_urls=$(gh search prs --state=$STATE_FILTER --draft=$DRAFT_FILTER --author=@me --review approved --updated="$prev_value..$latest_minute" --json url --jq ".[].url")

# PRs you've been assigned to
assigned_urls=$(gh search prs --state=$STATE_FILTER --draft=$DRAFT_FILTER --review-requested=@me --updated="$prev_value..$latest_minute" --json url --jq ".[].url")


for item in ${change_request_urls//\\n/ } ; do
    notify-send "PR has been requested to have changes made" "$item" -u critical --icon=edit-undo
done

for item in ${approved_urls//\\n/ } ; do
    notify-send "PR has been approved" "$item" -u critical --icon=emblem-default
done

for item in ${assigned_urls//\\n/ } ; do
    notify-send "PR has been assigned to you for review" "$item" -u critical --icon=task-due
done

