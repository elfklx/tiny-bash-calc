#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

_calc_reads_an_expression() {
    EXPR="8 + 3"
    RESULT=$(echo "$EXPR" | ./calc)
    [[ "$RESULT" =~ "11" ]]
}
