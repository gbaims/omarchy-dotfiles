#!/usr/bin/env bash
# ~/.task/hooks/on-exit.task-limiter.sh
# For tasks active for over 1h, add a 3h wait

LIMIT_SECONDS=3600
WAIT_TIME="2h"
LOCKFILE="/tmp/task-limiter.lock"

[ -f "$LOCKFILE" ] && exit 0
touch "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

ACTIVE_IDS=$(task +ACTIVE ids 2>/dev/null)
[ -z "$ACTIVE_IDS" ] && exit 0

NOW=$(date +%s)

for ID in $(echo "$ACTIVE_IDS" | tr ',' ' '); do
  START_RAW=$(task _get "${ID}.start" 2>/dev/null)
  [ -z "$START_RAW" ] && continue

  START_EPOCH=$(date -d "${START_RAW}" +%s 2>/dev/null)
  ELAPSED=$(( NOW - START_EPOCH ))

  if [ "$ELAPSED" -ge "$LIMIT_SECONDS" ]; then
    task rc.confirmation=off "${ID}" stop
    task rc.confirmation=off "${ID}" modify wait:"$WAIT_TIME"
  fi
done

exit 0
