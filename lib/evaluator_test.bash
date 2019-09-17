#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=test_helpers.bash
. lib/test_helpers.bash
# shellcheck source=evaluator.bash
. lib/evaluator.bash

T_evaluating_a_number_is_a_no_op() {
    ast="$(setup_tmpfile)"
    echo "32" > "${ast}"

    evaluate "${ast}"

    read -r result <"${ast}"
    cleanup_tmpfile "${ast}"
    if [[ $result != "32" ]] ; then
	$T_fail "expected ${result} to equal 32"
	return
    fi
}

T_evaluating_a_simple_addition_leaves_the_result() {
    ast="$(setup_tmpfile)"
    rm "${ast}"
    cp -r "fixtures/TwelvePlusThree" "${ast}"

    evaluate "${ast}"

    read -r result <"${ast}"
    cleanup_tmpfile "${ast}"
    [[ $result == "15" ]]
}

T_evaluating_a_simple_subtraction_leaves_the_result() {
    ast="$(setup_tmpfile)"
    rm "${ast}"
    cp -r "fixtures/TwelveMinusThree" "${ast}"

    evaluate "${ast}"

    read -r result <"${ast}"
    cleanup_tmpfile "${ast}"
    [[ $result == "9" ]]    
}
