#!/bin/sh

# Bitcoind container name
BACKEND=polar-n1-backend

bitcoin_cli() {
    docker exec $BACKEND bitcoin-cli -regtest -rpcuser=polaruser -rpcpassword=polarpass -rpcwallet=default "$@"
}

# List and unload all wallets
echo "Unloading wallets"
echo $(bitcoin_cli listwallets)
docker exec $BACKEND bitcoin-cli -regtest -rpcuser=polaruser -rpcpassword=polarpass unloadwallet "" || true
echo $(bitcoin_cli listwallets)
WALLETS=$(bitcoin_cli listwallets | jq -r '.[] | select(. != "")')
for wallet in $WALLETS; do
    echo "Unloading wallet $wallet"
    bitcoin_cli unloadwallet "$wallet"
done
echo $(bitcoin_cli listwallets)

# Make sure we always have a single wallet named 'default'
echo "Creating and loading default wallet"
bitcoin_cli createwallet default || true
bitcoin_cli loadwallet default || true
echo $(bitcoin_cli listwallets)

# Generate blocks to mature coinbase
echo "Generating blocks to mature coinbase"
bitcoin_cli -generate 100 > /dev/null
