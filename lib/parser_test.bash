#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=test_helpers.bash
. lib/test_helpers.bash
# shellcheck source=parser.bash
. lib/parser.bash

T_parsing_number_writes_a_single_file() {
    local result_file result
    result_file="$(setup_tmpfile)"

    parse "87" "${result_file}"

    read -r result <"${result_file}"
    cleanup_tmpfile "${result_file}"

    if [[ $result != "87" ]] ; then
	$T_fail "expected $result to equal 87"
	return
    fi
}

T_parsing_a_simple_add_expression_writes_a_directory() {
    local result_path lhs op rhs

    result_path="$(setup_tmpfile)"

    parse "2+8" "${result_path}"

    if [[ ! -d ${result_path} ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result path to be a directory"
	return
    fi
    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $lhs to be 2"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $op to be +"
	return
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "8" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $rhs to be 8"
	return
    fi

    cleanup_tmpfile "${result_path}"
}

T_parsing_add_expressions_handles_whitespace() {
    local result_path lhs op rhs

    result_path="$(setup_tmpfile)"

    parse " 2 + 8 " "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $lhs to be 2"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $op operator to be +"
	return
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "8" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $rhs to be 8"
	return
    fi

    cleanup_tmpfile "${result_path}"
}

T_parsing_complex_add_expressions_works() {
    local result_path lhs op mid rhs

    result_path="$(setup_tmpfile)"

    parse "2+8+37" "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $lhs to be 2"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected $op to be +"
	return
    fi

    if [[ ! -d "${result_path}/RHS" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result RHS to be a directory"
	return
    fi
    read -r mid <"${result_path}/RHS/LHS"
    if [[ $mid != "8" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected $mid to be 8"
	return
    fi
    read -r op <"${result_path}/RHS/operator"
    if [[ $op != "+" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected $op to be +"
	return
    fi
    read -r rhs <"${result_path}/RHS/RHS"
    if [[ $rhs != "37" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected $rhs to be 37"
	return
    fi

    cleanup_tmpfile "${result_path}" 
}

T_parsing_subtraction_writes_a_directory() {
    test_parsing_simple_expression " 26 - 9 " "26" "-" "9"
}

T_parsing_multiplication_writes_a_directory() {
    test_parsing_simple_expression " 3 * 84 " "3" "\*" "84"
}

test_parsing_simple_expression() {
    local expr="${1:?first argument to test_parsing_simple_expression should be an expression}"
    local exp_lhs="${2:?second argument to test_parsing_simple_expression should be expected lhs}"
    local exp_op="${3:?third argument to test_parsing_simple_expression should be expected operator}"
    local exp_rhs="${4:?fourth argument to test_parsing_simple_expression should be expected rhs}"

    local result_path lhs op rhs
    
    result_path="$(setup_tmpfile)"

    parse "${expr}" "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "${exp_lhs}" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $lhs to be ${exp_lhs}"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "${exp_op}" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $op to be ${exp_op}"
	return
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "${exp_rhs}" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected $rhs to be ${exp_rhs}"
	return
    fi

    cleanup_tmpfile "${result_path}"    
}
