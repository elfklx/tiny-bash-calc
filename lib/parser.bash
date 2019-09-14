#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

parse() {
    echo "parse called with <$1> and <$2>" >> /tmp/gdslog
    local expr="${1:?expected first argument to parse to be an expression}"
    local ast="${2:?expected second argument to parse to be a path where we write the result}"

    if [[ -f "${ast}" ]] ; then rm "${ast}" ; fi

	# shelcheck disable=2076
    if [[ "${expr}" =~ "+" ]] ; then
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
