#!/bin/bash

list_modules() {
    >&2 echo
    >&2 echo "available modules:"
    for tb in src/tb/*_tb.v; do
        bn="$(basename "$tb")"
        echo "    - ${bn/_tb.v/}"
    done
}

if [ "$#" -eq 0 ]; then
    >&2 echo "usage: $0 all"
    >&2 echo "       $0 <module_1> [module_2...]"
    list_modules
    exit 1
fi

trap "rm -f tmp.vvp" EXIT

modules="$1"
if [ "$modules" == "all" ]; then
    # all modules
    for tb in src/tb/*_tb.v; do
        iverilog -o tmp.vvp src/*.v "$tb" && vvp tmp.vvp
    done
else
    # input modules
    for module in "${modules[@]}"; do
        fname="src/tb/${module}_tb.v"

        if ! [ -e "$fname" ]; then
            >&2 echo "error: module not found: $module"
            list_modules
            exit 1
        fi

        iverilog -o tmp.vvp src/*.v "$fname" && vvp tmp.vvp
    done
fi
