#!/usr/bin/env bash

ALGORITHM=${1:-transgenetic}
if [ -n "$1" ]; then shift 1; fi

if [ "$ALGORITHM" != genetic ] && [ "$ALGORITHM" != transgenetic ] && [ "$ALGORITHM" != memetic ]; then
    echo "invalid algorithm '$ALGORITHM', expected one of ['genetic', 'transgenetic', 'memetic']"
    exit 1
fi

INSTANCE_GROUP=${1:-time}
if [ -n "$1" ]; then shift 1; fi

if [ "$INSTANCE_GROUP" != time ] && [ "$INSTANCE_GROUP" != distance ] && [ "$INSTANCE_GROUP" != all ]; then
    echo "invalid instance group '$INSTANCE_GROUP', expected one of ['time', 'distance', 'all']"
    exit 1
fi

PARAMS=${@:-"500 50 42"}

for f in ../data/*; do
    fname=$(basename "$f")
    num=$(echo "$fname" | grep -o -E '[1-9]+[0-9]*')

    if [ "$INSTANCE_GROUP" != all ]; then
        if [ "$INSTANCE_GROUP" = time ] && ((num % 2 == 0)); then
            continue
        fi

        if [ "$INSTANCE_GROUP" = distance ] && ((num % 2 != 0)); then
            continue
        fi
    fi

    RESULT_DIR=../results/$ALGORITHM/$fname
    mkdir -p "$RESULT_DIR"

    echo ">> Running instance $num"
    ./run.sh "$ALGORITHM" "$num" "$RESULT_DIR"/result.txt $PARAMS >"$RESULT_DIR"/summary.txt

    echo "Summary:"
    cat "$RESULT_DIR"/summary.txt
done
