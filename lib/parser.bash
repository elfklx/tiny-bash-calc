#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

parse() {
    expr="${1:?expected first argument to parse to be an expression}"
    ast="${2:?expected second argument to parse to be a path where we write the result}"

    echo "${expr}" > "${ast}"
}
