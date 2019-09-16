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

T_evaluating_a_simple_addition_leaves_the_result() {
    tmpdir="$(dirname "$(mktemp -u)")"
    ast="$(mktemp "${tmpdir}/calc.XXXXXXXXXXXX.tmp")"
    rm "${ast}"
    cp -r "fixtures/TwelvePlusThree" "${ast}"

    evaluate "${ast}"

    read -r result <"${ast}"
    rm "${ast}"
    [[ $result == "15" ]]
}
