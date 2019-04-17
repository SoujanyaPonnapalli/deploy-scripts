#!/bin/bash
# Usage - ./deploy_storage.sh

USERNAME="cc"
SSERVERS=($(<./$2))

PORT=9100

start() {
  echo "--- Starting storage nodes"
  for ((k = 0; k < 16; k++)); do     
    ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${SSERVERS[k]} "
        cd /home/cc/sosp19/storage; node -r ts-node/register src/server.ts $k | tee ../../logs/storage${k}.log 
    " &
  done
}

update_storage_container() {
  for ((k = 0; k < 16; k++)); do
    ssh  -i ~/disaggregatedblockchain.pem ${USERNAME}@${SSERVERS[$k]} "
        cd /home/cc/sosp19/storage; node -r ts-node/register src/server.ts $k | tee ../../logs/storage${k}.log 
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
