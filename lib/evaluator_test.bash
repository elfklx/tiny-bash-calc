#!/usr/bin/env bash

set -u

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=evaluator.bash
. lib/evaluator.bash

T_evaluating_a_number_is_a_no_op() {
    tmpdir="$(dirname "$(mktemp -u)")"
    ast="$(mktemp "${tmpdir}/calc.XXXXXXXXXXXX.tmp")"
    echo "32" > "${ast}"

    evaluate "${ast}"

    read -r result <"${ast}"
    rm "${ast}"
    [[ $result == "32" ]]
}
