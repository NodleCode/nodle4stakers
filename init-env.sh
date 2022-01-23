#!/usr/bin/env bash

# Update the secret seed for the Validator address
# used by `inject-session-key.sh` for session key injection to the node.
export OVERALL_SECRET=""

# Update the chain data store base path
export DATA_DIR="$PWD/nodle-staking-db"

export STAKER_NODE_PREFIX="nodle-staking-validator"
export STAKER_IMAGE="nodledevops/nodle-chain-staking:v0.2"
export STAKER_PORT="30600"
export STAKER_RPC_PORT="8600"
export STAKER_WS_PORT="9944"

export STAKER_FIRST_BOOTNODE_ADDR="/dns4/node-6890912030976569344-0.p2p.onfinality.io/tcp/27644/p2p/12D3KooWQnC8PbXeY31Ej8Rbpm6NEgvTmZ84TePuQEx1VPSxsKgZ"
export STAKER_SECOND_BOOTNODE_ADDR="/dns4/node-6890912733019144192-0.p2p.onfinality.io/tcp/18572/p2p/12D3KooWPhvsxaB6rTSS1Yq3FCwcbhCcPrhaM9JxFqn6XtTX9K1k"

# Update the chain spec, by default uses `staking` std chain spec
export STAKER_CHAIN_SPEC_CONFIG="staking"
