#!/bin/bash
# Usage - ./deploy_client.sh NUM_STORAGE_SERVICES
# $1 start/stop $2 - num-clients

USERNAME="cc"
CLIENTS=($(<./$3))
clientToSpawn=$2
txnfile=$4

stop() {
  for ((i = 0; i < ${#CLIENTS[@]}; i++)); do
    ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${CLIENTS[i]} '
        kill -9 $(pgrep -f rainblock-client)
    ' 
  done
}

start(){
  num=$(( ${clientToSpawn} % ${#CLIENTS[@]} ))
  echo "~/sosp19/txTraces/${txnfile}_${clientToSpawn}.bin";
  scp -i ~/disaggregatedblockchain.pem ./verf.txt ${USERNAME}@${CLIENTS[num]}:~/sosp19/client/verf.txt
  ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${CLIENTS[num]} "cd ~/sosp19/client; 
  ./rainblock-client --txnfile ~/sosp19/txTraces/${txnfile}_${clientToSpawn}.bin \
  --shardfile ./shards.txt \
  --verffile ./verf.txt &> ~/logs/client${clientToSpawn}.log";
  echo "DONE CLIENT INSTANCE"
}

if (($# != 4)); then
  echo "./client.sh start/stop clientToSpawn clientIps traceToExecute"
fi

# setup_docker_deps $1
if [ $1 = "start" ]; then
	start
fi
if [ $1 = "stop" ]; then
	stop
fi
