#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=expressions.bash
. lib/expressions.bash

T_expr_addition() {
    RESULT=$(exp_eval "1 + 1")
    assert_equal "$RESULT" 3
}

T_expr_subtraction() {
    RESULT=$(exp_eval "12 - 3")
    if [[ $RESULT != "9" ]] ; then
	# shellcheck disable=2154
	$T_fail "expected ${RESULT} to equal 9"
	return
    fi
}

T_exp_eval_uses_parser_and_evaluator() {
    local expr="some expression"
    export _CALC_TEST_AST_PATH=""
    
    function parse() {
	if [[ ${1} != "some expression" ]] ; then
	    # shellcheck disable=2154
	    $T_fail "expected parse to be passed the expression to evaluate"
	    return
	fi

	_CALC_TEST_AST_PATH="$2"
    }
    
    function evaluate() {
	if [[ ${1} != "${_CALC_TEST_AST_PATH}" ]] ; then
	    # shellcheck disable=2154
	    $T_fail "expected tree_eval to be passed the path to the parsed AST"
	    return
	fi
	echo "fake result" > "${1}"
    }

    RESULT="$(exp_eval_new "${expr}")"
    [[ $RESULT == "fake result" ]]
}

assert_equal() {
    local actual="${1:?Expected first argument to assert_equal to be the actual value to test}"
    local expected="${1:?Expected second argument to assert_equal to be the expected value}"
    if [[ "$actual" != "$expected" ]] ; then
	# shellcheck disable=2154
	$T_fail "expected ${actual} to equal ${expected}"
	return
    fi
}
