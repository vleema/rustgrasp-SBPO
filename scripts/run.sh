#!/bin/sh

DURATION=60
END_TIME=$(($(date +%s) + $DURATION))
TEMP_DIR=/tmp/grasp

ALGORITHM=${1:-transgenetic}
if [ -n "$1" ]; then shift 1; fi

INSTANCE=${1:-1}
if [ -n "$1" ]; then shift 1; fi

RESULT=${1:-result.txt}
if [ -n "$1" ]; then shift 1; fi

PARAMS=${@:-"500 50 42"}

rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

for i in $(seq "$(nproc)"); do
    TEMP_RESULT=$TEMP_DIR/result_$i.txt
    while [ "$(date +%s)" -lt "$END_TIME" ]; do
        ../bins/"$ALGORITHM"/"$INSTANCE" "$PARAMS" >>"$TEMP_RESULT"
    done &
done

wait

cat $TEMP_DIR/result_*.txt >"$RESULT"
./parse_result.py "$RESULT"
