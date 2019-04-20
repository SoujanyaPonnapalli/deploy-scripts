#!/bin/bash
# Usage - ./deploy_client.sh NUM_STORAGE_SERVICES
# $1 start/stop $2 - num-clients

USERNAME="cc"
CLIENTS=($(<./$3))

stop() {
  for ((i = 0; i < ${#CLIENTS[@]}; i++)); do
    ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${CLIENTS[i]} '
        kill -9 $(pgrep -f rainblock-client)
    ' 
  done
}

start(){

        num=$(( $1 % ${#CLIENTS[@]} ))
        scp verf.txt ${USERNAME}@${CLIENTS[num]}:~/sosp19/client/verf.txt
        ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${CLIENTS[num]} "cd ~/sosp19/client; ./rainblock-client --txnfile ../txTraces/trace1M_${num}.bin --shardfile ./shards.txt --verffile ./verf.txt "

}



# setup_docker_deps $1
if [ $1 = "start" ]; then
	start $2
fi
if [ $1 = "stop" ]; then
	stop
fi
