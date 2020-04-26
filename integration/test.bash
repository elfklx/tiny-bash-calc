#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

T_calc_evaluates_an_expression() {
    local expr="8 + 3\nq" result i=0

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
    local expr="8 + 3\n12 - 5\nq" result i=0

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

T_calc_can_do_multiplication() {
    local expr="8 * 3\nq" result i=0

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

cal_can_do_division() {
    local expr="9 / 3\nq" result i=0

    for line in $(echo -e "$expr" | ./calc) ; do
	result[i]="$line"
	i=$(( i + 1 ))
    done

    if [[ ! "${result[1]}" == "3" ]] ; then
	# shellcheck disable=SC2154
	$T_fail "expected ${result[1]} to be 3"
	return
    fi
}

T_calc_can_do_complex_expressions() {
    local expr="2 + 3 * 4\nq" result i=0

    for line in $(echo -e "$expr" | ./calc) ; do
	result[i]="$line"
	i=$(( i + 1))
    done

    if [[ ! "${result[1]}" == "14" ]] ; then
	# shellcheck disable=SC2154
	$T_fail "expected ${result[1]} to be 14"
	return
    fi
}
