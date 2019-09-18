#!/usr/bin/env bash

set -u

[[ -z "${DEBUG:-""}" ]] || set -x

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
	return
    fi

    rm -r "$tmpfile"
}
