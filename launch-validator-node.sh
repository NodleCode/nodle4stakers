#!/usr/bin/env bash

set -euxo pipefail

PROJECT_ROOT=$(git rev-parse --show-toplevel)

source "$(dirname "$0")"/init-env.sh

cd "$PROJECT_ROOT"

DATA_DIR=${DATA_DIR:-"$PWD/nodle-staking-tnet"}

STAKER_NODE_PREFIX=${STAKER_NODE_PREFIX:-"nodle-staking-tnet"}
STAKER_IMAGE=${STAKER_IMAGE:-"us-docker.pkg.dev/staking-testnet/nodle-chain:latest"}
STAKER_PORT=${STAKER_PORT:-"30600"}
STAKER_RPC_PORT=${STAKER_RPC_PORT:-"8600"}
STAKER_WS_PORT=${STAKER_WS_PORT:-"9600"}
STAKER_FIRST_BOOTNODE_ADDR=${STAKER_FIRST_BOOTNODE_ADDR:-"/ip4/127.0.0.1/tcp/30601/p2p/12D3KooWK2UnsrZWbpKvHoEzzmZBMTBJ9bHD7ftYsUTGduABazDW"}
STAKER_SECOND_BOOTNODE_ADDR=${STAKER_SECOND_BOOTNODE_ADDR:-"/ip4/127.0.0.1/tcp/30602/p2p/12D3KooWHVxy2CxrySd2fPNuDd66CUTMjK4xxbA9c3QxGzuvtDWm"}

STAKER_CHAIN_SPEC_CONFIG=${STAKER_CHAIN_SPEC_CONFIG:-"node/res/staking.json"}

initial_container_configurations() {
    local container_name=$1

    mkdir -p $DATA_DIR/$container_name
}

# Init

docker \
	container \
	stop \
	$(docker container ls -aq --filter name="$STAKER_NODE_PREFIX*") \
	&> /dev/null || true

docker \
	container \
	rm \
	$(docker container ls -aq --filter name="$STAKER_NODE_PREFIX*") \
	&> /dev/null || true

mkdir -p $DATA_DIR

# Staker Validators

launch_container() {
    local container_name=$1
    local validator_extra_params=$2

    docker run \
        -d \
        -v $DATA_DIR/$container_name:/data \
        --name=$container_name \
        --network=host \
        --restart=always \
        $STAKER_IMAGE \
        --base-path=/data \
		--rpc-methods=Unsafe \
		--unsafe-ws-external \
		--unsafe-rpc-external \
        --chain=$STAKER_CHAIN_SPEC_CONFIG \
        --name=$container_name \
        $validator_extra_params
}

launch_configured_node() {
    local idx=$1

    local container_name="$STAKER_NODE_PREFIX-$idx"
    local relay_port=$(($STAKER_PORT + $idx))
    local relay_rpc_port=$(($STAKER_RPC_PORT + $idx))
    local relay_ws_port=$(($STAKER_WS_PORT + $idx))
    local relay_port_extra="--port=$relay_port --rpc-port=$relay_rpc_port --ws-port=$relay_ws_port"

    initial_container_configurations "$container_name"

	launch_container \
		"$container_name" \
		"--bootnodes=$STAKER_FIRST_BOOTNODE_ADDR --bootnodes=$STAKER_SECOND_BOOTNODE_ADDR --validator $relay_port_extra"
}

launch_configured_node 0
