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

T_exp_eval_uses_parser_and_evaluator() {
    expr="some expression"
    
    function parse() {
	if [[ ${1} != "some expression" ]] ; then
	    # shellcheck disable=2154
	    $T_fail "expected parse to be passed the expression to evaluate"
	    return
	fi
	echo "path to tree"
    }
    
    function evaluate() {
	if [[ ${1} != "path to tree" ]] ; then
	    # shellcheck disable=2154
	    $T_fail "expected tree_eval to be passed the result of parse"
	    return
	fi
	echo "fake result"
    }

    RESULT="$(exp_eval_new "${expr}")"
    [[ $RESULT == "fake result" ]]
}
