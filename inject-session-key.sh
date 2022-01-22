#!/usr/bin/env bash

set -euxo pipefail

PROJECT_ROOT=$(git rev-parse --show-toplevel)

source "$(dirname "$0")"/init-env.sh

cd "$PROJECT_ROOT"

# Avoid committing the secrets
OVERALL_SECRET=${OVERALL_SECRET:-""}

docker \
	run \
	--rm \
	-it \
	-e STAKER_SECRET="$OVERALL_SECRET" \
	--network=host \
	nodledevops/nodle-staking-utils:v0.1 \
	yarn \
	run \
	nstk-upskey \
	--ws "ws://127.0.0.1:9944"
