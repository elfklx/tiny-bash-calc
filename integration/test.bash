#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

T_calc_reads_an_expression() {
    EXPR="test expr"
    RESULT=$(echo "$EXPR" | ./calc)
    [[ "$RESULT" =~ "you asked about $EXPR" ]]
}
