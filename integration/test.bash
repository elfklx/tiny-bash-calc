#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

T_calc_evaluates_an_expression() {
    local expr="8 + 3\nq"
    local result
    local i=0

    for line in $(echo -e "$expr" | ./calc) ; do
	result[i]="$line"
	i=$(( i + 1 ))
    done

    if [[ ! "${result[1]}" == "11" ]] ; then
	# shellcheck disable=SC2154
	$T_fail "expected ${result[1]} to be 11"
	return
    fi
}

T_calc_evaluates_multiple_expressions() {
    local expr="8 + 3\n12 - 5\nq"
    local result
    local i=0

    for line in $(echo -e "$expr" | ./calc) ; do
	result[i]="$line"
	i=$(( i + 1 ))
    done

    if [[ ! "${result[1]}" == "11" ]] ; then
	# shellcheck disable=SC2154
	$T_fail "expected ${result[1]} to be 11"
	return
    fi
    if [[ ! "${result[3]}" == "7" ]] ; then
	# shellcheck disable=SC2154
	$T_fail "expected ${result[3]} to be 7"
	return
    fi
}

_calc_can_do_multiplication() {
    local expr="8 * 3\nq"
    local result
    local i=0

    for line in $(echo -e "$expr" | ./calc) ; do
	result[i]="$line"
	i=$(( i + 1 ))
    done

    if [[ ! "${result[1]}" == "24" ]] ; then
	# shellcheck disable=SC2154
	$T_fail "expected ${result[1]} to be 24"
	return
    fi
}
