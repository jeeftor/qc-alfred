#!/bin/bash


# Capture input
INPUT="${*}"

# Setup currency updates
FETCH_TIME_FILE=.last_fetch_time
NOW_TIME=$(date +%s)

# Setup the last fetch time file if it doesnt exist
if [[ ! -f "$FETCH_TIME_FILE" ]]; then
    echo $NOW_TIME > $FETCH_TIME_FILE
fi

LAST_FETCH_TIME=$(cat $FETCH_TIME_FILE)
TIME_DIF_SECONDS="$(($NOW_TIME-$LAST_FETCH_TIME))"
DAY_SECONDS=86400

# If the time difference is less than our threshold - run normal
if [[ $TIME_DIF_SECONDS -lt $DAY_SECONDS ]]; then
    FULL=$(qalc ${INPUT}| tr '"' \')
    TERSE=$(qalc -t ${INPUT}| tr '"' \')
else
    # Update last fetch time
    echo $NOW_TIME > $FETCH_TIME_FILE
    # Run with currency update mode
    FULL=$(qalc -e ${INPUT}| tr '"' \')
    TERSE=$(qalc -e -t ${INPUT} | tr '"' \')

fi

VALUE=$(echo $TERSE | cut -d' ' -f1 | tr '"' \')

CONVERTED_INPUT=$(echo $INPUT | tr '"' \')

# Do some error checking


cat << EOF
{"items": [
 {
   "uid": "result",
   "subtitle": "$CONVERTED_INPUT",
   "title": "$FULL",
   "arg": "$VALUE"
  }
]
}

