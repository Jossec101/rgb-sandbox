# Setup bitcoind environment
setup-bitcoind:
    bash setup-bitcoind.sh
#Run command within bitcoind container
bitcoin-cli *cmd:
    docker exec --user bitcoin polar-n1-backend bitcoin-cli -regtest {{cmd}}

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