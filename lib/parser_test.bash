#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=parser.bash
. lib/parser.bash

T_parsing_number_writes_a_single_file() {
    tmpdir="$(dirname "$(mktemp -u)")"
    result_file="$(mktemp "${tmpdir}/calc.XXXXXXXXXXXX.tmp")"

    parse "87" "${result_file}"

    read -r result <"${result_file}"
    rm "${result_file}"
    [[ $result == "87" ]]
}

_parsing_a_simple_add_expression_writes_a_directory() {
    tmpdir="$(dirname "$(mktemp -u)")"
    result_path="$(mktemp "${tmpdir}/calc.XXXXXXXXXXXX.tmp")"

    parse "2+8" "${result_path}"

    if [[ ! -d ${result_path} ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result path to be a directory"
    fi
    read -r lhs <"${result_file}/LHS"
    if [[ $lhs != "2" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result LHS to be 2"
    fi
    read -r op <"${result_file}/operator"
    if [[ $op != "+" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result operator to be +"
    fi
    read -r rhs <"${result_file}/RHS"
    if [[ $rhs != "8" ]] ; then
	#shellcheck disable=2154
	$T_fail "expected result RHS to be 8"
    fi

    rm "${result_file}/LHS" "${result_file}/operator" "${result_file}/RHS"
    rmdir "${result_file}"
}
