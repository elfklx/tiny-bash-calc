#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

# shellcheck source=parser.bash
. lib/parser.bash
# shellcheck source=evaluator.bash
. lib/evaluator.bash

exp_eval() {
    local tmpdir
    tmpdir="$(dirname "$(mktemp -u)")"
    local ast_path
    ast_path="$(mktemp "${tmpdir}/calc.XXXXXXXXXXXX.tmp")"

    parse "${1}" "${ast_path}"
    evaluate "${ast_path}"

    cat "${ast_path}"
    rm "${ast_path}"
}
