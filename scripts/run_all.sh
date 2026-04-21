#!/usr/bin/env bash

ALGORITHM=${1:-transgenetic}
if [ -n "$1" ]; then shift 1; fi

PARAMS=${@:-"500 50 42"}

for f in ../data/*; do
    fname=$(basename "$f")
    num=$(echo "$fname" | grep -o -E '[1-9]+[0-9]*')

    RESULT_DIR=../results/$ALGORITHM/$fname
    mkdir -p "$RESULT_DIR"

    echo ">> Running instance $num"
    ./run.sh "$ALGORITHM" "$num" "$RESULT_DIR"/result.txt $PARAMS >"$RESULT_DIR"/summary.txt

    echo "Summary:"
    cat "$RESULT_DIR"/summary.txt
done
