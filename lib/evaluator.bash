#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

evaluate() {
    local ast="${1:?Expected first argument to evaluate to be a path to an AST}"
    if [[ -f "${ast}" ]] ; then
	# already in normal form
	return
    fi

    read -r lhs <"${ast}/LHS"
    read -r rhs <"${ast}/RHS"
    rm "${ast}/LHS"
    rm "${ast}/RHS"
    rm "${ast}/operator"
    rmdir "${ast}"
    echo "$(( lhs + rhs ))" > "${ast}"
}
