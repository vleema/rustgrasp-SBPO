#!/usr/bin/env bash

sed_src() {
    SED_STR="s|\(graph_from_csv!(\"\)[^\"]*\(\")\)|\1$1/data.csv\2|"
    sed -i "$SED_STR" "$2"
}

ALGORITHMS=${@:-"transgenetic memetic genetic heuristics"}

cd ..

for algo in $ALGORITHMS; do
    mkdir -p bins/"$algo"

    for f in data/*; do
        fname=$(basename "$f")
        num=$(echo "$fname" | grep -o -E '[1-9]+[0-9]*')
        sed_src "$f" src/bin/"$algo".rs
        cargo br --bin "$algo"
        cp target/release/"$algo" bins/"$algo"/"$num"
    done
done
