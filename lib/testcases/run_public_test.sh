#!/bin/bash

./truffleChange.sh

cd files 
rpcport=$(cat rpcport)
ip=$(cat ip)

#JSON RPC call to fetch the coinbase account
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":83}' ${ip}:${rpcport} > resultAccts.json
cat resultAccts.json | jq '.result' > output.txt
sed '1d;$d' output.txt > output1.txt
sed 's/ //g' output1.txt > output2.txt
address=$(cat output2.txt)

#JSON RPC call to unlock account
curl -X POST --data '{"jsonrpc":"2.0","method":"personal_unlockAccount","params":['"$address"', "", 0],"id":1}' ${ip}:${rpcport} > unlock.json


cd /home/testcases/propertiesTemplates
cp public_deploy_contracts_template 2_deploy_contracts_data.js
cp 2_deploy_contracts_data.js ../smart-contracts/migrations/.

cd /home/testcases/smart-contracts
npm install colors
truffle migrate --reset 
printf "\e[38;5;185mPublic contracts deployed successfully!\033[0m\n"
truffle test
printf "\e[38;5;203mTruffle tests executed successfully!\033[0m\n"
