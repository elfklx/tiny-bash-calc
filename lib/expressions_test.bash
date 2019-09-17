#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=expressions.bash
. lib/expressions.bash

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

    RESULT="$(exp_eval "${expr}")"
    if [[ $RESULT != "fake result" ]] ; then
	$T_fail "Expected '${RESULT}' to equal 'fake result'"
	return
    fi
}

