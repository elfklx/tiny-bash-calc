#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=expressions.bash
. lib/expressions.bash

T_expr_addition() {
    RESULT=$(exp_eval "1 + 1")
    [[ $RESULT == "2" ]]
}

T_expr_subtraction() {
    RESULT=$(exp_eval "12 - 3")
    [[ $RESULT == "9" ]]
}
