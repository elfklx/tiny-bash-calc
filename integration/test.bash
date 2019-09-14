#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

T_calc_evaluates_an_expression() {
    EXPR="8 + 3"
    RESULT=$(echo "$EXPR" | ./calc)
    [[ "$RESULT" =~ "11" ]]
}
