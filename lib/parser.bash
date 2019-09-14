#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

parse() {
    expr="${1:?expected first argument to parse to be an expression}"
    ast="${2:?expected second argument to parse to be a path where we write the result}"

    # shelcheck disable=2076
    if [[ "${expr}" =~ "+" ]] ; then
	# add expression
	lhs="${expr/+*}"
	rhs="${expr/*+}"
	if [[ -f "${ast}" ]] ; then rm "${ast}" ; fi
	if [[ ! -d "${ast}" ]] ; then mkdir "${ast}" ; fi
	echo "${lhs}" > "${ast}/LHS"
	echo "${rhs}" > "${ast}/RHS"
	echo "+" > "${ast}/operator"
    else
	# number expression    
	echo "${expr}" > "${ast}"
    fi
}
