#!/usr/bin/env bash

LOCKFILE="/tmp/task-start-rules.lock"
exec 9>"$LOCKFILE"
flock -n 9 || exit 0

COUNTFILE="/tmp/task-count.txt"
if [ ! -f "$COUNTFILE" ]; then
  echo 0 > "$COUNTFILE"
fi

# Lê o valor atual, soma 1 e sobrescreve o arquivo
VALUE=$(cat "$COUNTFILE")
NEW_VALUE=$((VALUE + 1))
echo "$NEW_VALUE" > "$COUNTFILE"

TASK=(task rc.verbose=nothing rc.color=no rc.confirmation=no)

# Starting a waiting task means it should leave the waiting queue.
"${TASK[@]}" +ACTIVE +WAITING start.after:now-10sec modify wait: >/dev/null 2>&1 || true

# Active tasks older than 60 minutes should cool down, unless already waiting.
"${TASK[@]}" +ACTIVE -WAITING start.before:now-60min modify wait:2h >/dev/null 2>&1 || true

most_recent_started_uuid="$(
  "${TASK[@]}" \
    rc.report.custom.columns=uuid \
    rc.report.custom.sort=start- \
    +ACTIVE -WAITING limit:1 custom 2>/dev/null
)"

if [ -n "$most_recent_started_uuid" ]; then
  "${TASK[@]}" +ACTIVE uuid.not:"$most_recent_started_uuid" stop >/dev/null 2>&1 || true
else
  "${TASK[@]}" +ACTIVE stop >/dev/null 2>&1 || true
fi

exit 0
