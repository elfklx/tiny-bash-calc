#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=parser.bash
. lib/parser.bash
# shellcheck source=evaluator.bash
. lib/evaluator.bash

exp_eval() {
    echo "$(( $1 ))"
}

exp_eval_new() {
    tree="$(parse "${1}")"
    evaluate "${tree}"
}
