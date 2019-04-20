#!/bin/bash
# Usage - ./deploy_storage.sh

USERNAME="cc"
SSERVERS=($(<./$2))
sPruneDepth=$3

PORT=9100

start() {
  echo "--- Starting storage nodes"
  for ((k = 0; k < 16; k++)); do
    cp storageConfig.yml ./config/newStorageConfig.yml;
		echo "" >> ./config/newStorageConfig.yml
    echo -e "pruneDepth: ${sPruneDepth}" >> ./config/newStorageConfig.yml;
    scp -i ~/disaggregatedblockchain.pem ./config/newStorageConfig.yml \
    ${USERNAME}@${SSERVERS[k]}:~/sosp19/storage/src/test_data/storageConfig.yml

    ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${SSERVERS[k]} "
        cd /home/cc/sosp19/storage; node  --max-old-space-size=122880 -r ts-node/register src/server.ts $k \
        test_data/storageConfig.yml &> ~/logs/storage${k}.log
    " &
  done
}

update_storage_container() {
  for ((k = 0; k < 16; k++)); do
    ssh  -i ~/disaggregatedblockchain.pem ${USERNAME}@${SSERVERS[$k]} "
        cd /home/cc/sosp19/storage; node  --max-old-space-size=122880 \
          -r ts-node/register src/server.ts $k &> ~/logs/storage${k}.log
        cd /home/cc/storage; git stash save; git pull origin master
    " &
  done
}

stop() {
  for ((k = 0; k < 16; k++)); do
    ssh  -i ~/disaggregatedblockchain.pem ${USERNAME}@${SSERVERS[k]} '
        kill -9 $(pgrep -f server)
    ' 
  done
}

if (($# != 3)); then
  echo "./storage.sh start/stop storageIPs pruneDepth"
fi
rm -rf ./config
mkdir config


if [ $1 = "update" ]; then
  update_storage_container
fi
if [ $1 = "setup" ]; then
  setup_deps
fi
if [ $1 = "start" ]; then
  start
fi
if [ $1 = "stop" ]; then
  stop
fi
