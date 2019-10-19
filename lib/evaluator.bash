#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

evaluate() {
    local ast="${1:?Expected first argument to evaluate to be a path to an AST}"
    if [[ -f "${ast}" ]] ; then
	# already in normal form
	return
    fi

    evaluate "${ast}/LHS"
    evaluate "${ast}/RHS"

    local lhs rhs op
    lhs="$(cat "${ast}/LHS")"
    rhs="$(cat "${ast}/RHS")"
    op="$(cat "${ast}/operator")"
    rm "${ast}/LHS"
    rm "${ast}/RHS"
    rm "${ast}/operator"
    rmdir "${ast}"
    if [[ "${op}" == "+" ]] ; then
	echo "$(( lhs + rhs ))" > "${ast}"
    elif [[ "${op}" == "-" ]] ; then
	echo "$(( lhs - rhs ))" > "${ast}"
    else
	echo "$(( lhs * rhs ))" > "${ast}"
    fi
}
