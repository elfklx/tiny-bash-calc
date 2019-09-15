#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

parse() {
    local expr="${1:?expected first argument to parse to be an expression}"
    local ast="${2:?expected second argument to parse to be a path where we write the result}"

    if [[ -f "${ast}" ]] ; then rm "${ast}" ; fi

    if [[ "${expr}" =~ "-" ]] ; then
	# subtract expression
	parse_binexp "-" "${expr}" "${ast}"
    elif [[ "${expr}" =~ "+" ]] ; then
	# add expression
	local lhs="${expr/+*}"
	local rhs="${expr/*+}"
	if [[ ! -d "${ast}" ]] ; then mkdir "${ast}" ; fi
	parse "${lhs}" "${ast}/LHS"
	parse "${rhs}" "${ast}/RHS"
	echo "+" > "${ast}/operator"
    else
	# number expression    
	echo "${expr}" > "${ast}"
    fi
}

parse_binexp() {
    local op="${1:?expected first argument of parse_binop to be an operator}"
    local expr="${2:?expected second argument of parse_binop to be an expression}"
    local ast="${3:?expected third argument of parse_binop to be a path where we write the result}"

    local lhs="${expr/${op}*}"
    local rhs="${expr/*${op}}"
    if [[ ! -d "${ast}" ]] ; then mkdir "${ast}" ; fi
    parse "${lhs}" "${ast}/LHS"
    parse "${rhs}" "${ast}/RHS"
    echo "${op}" > "${ast}/operator"    
}
