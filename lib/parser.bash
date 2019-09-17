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
	parse_binexp "+" "${expr}" "${ast}"
    else
	# number expression    
	echo "${expr}" > "${ast}"
    fi
}

parse_binexp() {
    local op="${1:?expected first argument of parse_binop to be an operator}"
    local expr="${2:?expected second argument of parse_binop to be an expression}"
    local ast="${3:?expected third argument of parse_binop to be a path where we write the result}"

    local lhs rhs
    lhs="$(get_lhs "${op}" "${expr}")"
    rhs="$(get_rhs "${op}" "${expr}")"

    if [[ ! -d "${ast}" ]] ; then mkdir "${ast}" ; fi

    parse "${lhs}" "${ast}/LHS"
    parse "${rhs}" "${ast}/RHS"
    echo "${op}" > "${ast}/operator"    
}

get_lhs() {
    local op="${1:?expected first argument of get_lhs to be an operator to split on}"
    local expr="${2:?expected second argument of get_lhs to be an expression to split}"

    echo "${expr/${op}*}" # remove everything from the first op onwards
}

get_rhs() {
    local op="${1:?expected first argument of get_lhs to be an operator to split on}"
    local expr="${2:?expected second argument of get_lhs to be an expression to split}"

    local lhs
    lhs="$(get_lhs "${op}" "${expr}")"

    echo "${expr#${lhs}*${op}}" # remove the lhs and the first occurance of the op
}
