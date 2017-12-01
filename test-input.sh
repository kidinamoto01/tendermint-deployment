#!/bin/bash
# Scriptname:
echo -e "What's the name? \c"
read chainname
echo -e "How many nodes are there? \c"
read nodes
for i in $(seq 1 $nodes)
do
  name=node$i 
  mkdir ./keys/$name 
  #tendermint pubkey generate
  tendermint gen_validator > ./keys/$name/priv_validator.json
  echo "genderate keys for "$name
  echo -e "How numch stake does this  node has? \c"
  read weight
  if [ $i -lt $nodes ]  
      then 
           cat ./keys/$name/priv_validator.json |jq ".pub_key as \$k | {pub_key: \$k, amount: $weight, name: \"$name\"} " >> ./keys/new_pub_validator.json
       echo "," >> ./keys/new_pub_validator.json
  else
          cat ./keys/$name/priv_validator.json |jq ".pub_key as \$k | {pub_key: \$k, amount: $weight, name: \"$name\"}" >> ./keys/new_pub_validator.json
  fi 
done
echo "{\"genesis_time\":\"0001-01-01T00:00:00Z\",\"chain_id\":\"$chainname\",\"validators\": [ ">> genesis-template.json
cat ./keys/new_pub_validator.json >>genesis-template.json
echo "],\"app_hash\": \"\"}">>genesis-template.json
rm ./keys/new_pub_validator.json
