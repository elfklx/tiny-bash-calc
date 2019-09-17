#!/usr/bin/env bash

set -u

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=test_helpers.bash
. lib/test_helpers.bash
# shellcheck source=parser.bash
. lib/parser.bash

T_parsing_number_writes_a_single_file() {
    result_file="$(setup_tmpfile)"

    parse "87" "${result_file}"

    read -r result <"${result_file}"
    cleanup_tmpfile "${result_file}"

    [[ $result == "87" ]]
}

T_parsing_a_simple_add_expression_writes_a_directory() {
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
	$T_fail "expected result LHS to be 2"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result operator to be +"
	return
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "8" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result RHS to be 8"
	return
    fi

    cleanup_tmpfile "${result_path}"
}

T_parsing_add_expressions_handles_whitespace() {
    result_path="$(setup_tmpfile)"

    parse " 2 + 8 " "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 2"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result operator to be +"
	return
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "8" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result RHS to be 8"
	return
    fi

    cleanup_tmpfile "${result_path}"
}

T_parsing_complex_add_expressions_works() {
    result_path="$(setup_tmpfile)"

    parse "2+8+37" "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 2"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result operator to be +"
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
    	$T_fail "expected result RHS/LHS to be 8"
	return
    fi
    read -r op <"${result_path}/RHS/operator"
    if [[ $op != "+" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result RHS operator to be +"
	return
    fi
    read -r rhs <"${result_path}/RHS/RHS"
    if [[ $rhs != "37" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result RHS/RHS to be 37"
	return
    fi

    cleanup_tmpfile "${result_path}" 
}

T_parsing_subtraction_writes_a_directory() {
    result_path="$(setup_tmpfile)"

    parse " 26 - 9 " "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "26" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 26"
	return
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "-" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result operator to be -"
	return
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "9" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result RHS to be 9"
	return
    fi

    cleanup_tmpfile "${result_path}"    
}
