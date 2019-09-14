#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

exp_eval() {
    echo "$(( $1 ))"
}

exp_eval_new() {
    tree="$(parse "${1}")"
    tree_eval "${tree}"
}
