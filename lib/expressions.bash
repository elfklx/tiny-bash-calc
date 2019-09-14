#!/usr/bin/env bash

set -euo pipefail

[[ -z "${DEBUG:-""}" ]] || set -x

exp_eval() {
    echo "$(( $1 ))"
}