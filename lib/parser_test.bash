#!/usr/bin/env bash

set -u

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=parser.bash
. lib/parser.bash

setup_tmpfile() {
    local tmpdir
    tmpdir="$(dirname "$(mktemp -u)")"
    mktemp "${tmpdir}/calc.XXXXXXXXXXXX.tmp"
}

cleanup_tmpfile() {
    local tmpfile="${1:?Expected first arument to cleanup_tmpfile to be a tmpfile to clean up}"
    local tmpdir
    tmpdir="$(dirname "$(mktemp -u)")"

    if [[ ! "$tmpfile" =~ ^$tmpdir ]] ; then
	#shellcheck disable=2154
	$T_fail "Can't clean up non-temporary files"
    fi

    rm -r "$tmpfile"
}

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
    fi
    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 2"
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result operator to be +"
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "8" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result RHS to be 8"
    fi

    rm "${result_path}/LHS" "${result_path}/operator" "${result_path}/RHS"
    rmdir "${result_path}"
}

T_parsing_add_expressions_handles_whitespace() {
    result_path="$(setup_tmpfile)"

    parse " 2 + 8 " "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 2"
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result operator to be +"
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "8" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result RHS to be 8"
    fi

    rm "${result_path}/LHS" "${result_path}/operator" "${result_path}/RHS"
    rmdir "${result_path}"
}

_parsing_complex_add_expressions_works() {
    result_path="$(setup_tmpfile)"

    parse "2+8+37" "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 2"
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "+" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result operator to be +"
    fi

    if [[ ! -d "${result_path}/RHS" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result RHS to be a directory"
    fi
    read -r mid <"${result_path}/RHS/LHS"
    if [[ $mid != "8" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result RHS/LHS to be 8"
    fi
    read -r op <"${result_path}/RHS/operator"
    if [[ $op != "+" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result RHS operator to be +"
    fi
    read -r rhs <"${result_path}/RHS/RHS"
    if [[ $rhs != "37" ]] ; then
    	#shellcheck disable=2154
    	$T_fail "expected result RHS/RHS to be 37"
    fi

    rm "${result_path}/LHS" \
       "${result_path}/operator" \
       "${result_path}/RHS/LHS" \
       "${result_path}/RHS/RHS" \
       "${result_path}/RHS/operator"
       
    rmdir "${result_path}/RHS" "${result_path}" 
}

T_parsing_subtraction_writes_a_directory() {
    result_path="$(setup_tmpfile)"

    parse " 26 - 9 " "${result_path}"

    read -r lhs <"${result_path}/LHS"
    if [[ $lhs != "26" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 26"
    fi
    read -r op <"${result_path}/operator"
    if [[ $op != "-" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result operator to be -"
    fi
    read -r rhs <"${result_path}/RHS"
    if [[ $rhs != "9" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result RHS to be 9"
    fi

    rm "${result_path}/LHS" "${result_path}/operator" "${result_path}/RHS"
    rmdir "${result_path}"    
}
