#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

T_calc_evaluates_an_expression() {
    EXPR="8 + 3\nq"
    RESULT=$(echo -e "$EXPR" | ./calc)
    [[ "$RESULT" =~ "11" ]]
}
