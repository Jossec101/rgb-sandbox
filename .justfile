# Environment variables
export CLOSING_METHOD := "opret1st"
export CONSIGNMENT := "consignment.rgb"
export PSBT := "tx.psbt"
export SCHEMATA_DIR := "rgb-schemas/schemata"
export WALLET_PATH := "wallets"
export KEYCHAIN := "<0;1;9>"

# Setup bitcoind environment
setup-bitcoind:
    bash setup-bitcoind.sh

# Run command within bitcoind container
bitcoin-cli *cmd:
    docker exec --user bitcoin polar-n1-backend bitcoin-cli -regtest {{cmd}}


# BP wallet commands
bp *args:
    ./bp-wallet/bin/bp {{args}}

bphot *args:
    ./bp-wallet/bin/bp-hot {{args}}

# RGB commands
rgb0 *args:
    ./rgb-cmd/bin/rgb -n regtest --electrum=localhost:50001 -d data0 -w issuer {{args}}

rgb1 *args:
    ./rgb-cmd/bin/rgb -n regtest --electrum=localhost:50001 -d data1 -w rcpt1 {{args}}

# Send to address with fee rate
sendtoaddress address amount:
   just bitcoin-cli -named sendtoaddress address={{address}} amount={{amount}} fee_rate=25

# Generate blocks for bitcoin
generate blocks:
    just bitcoin-cli -generate {{blocks}}

generateemptyblock:
    #!/bin/bash
    address=$(just bitcoin-cli getnewaddress)
    just bitcoin-cli generateblock $address "[]"