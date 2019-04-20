#!/bin/bash
# Usage - ./deploy_client.sh NUM_STORAGE_SERVICES
# $1 start/stop $2 - num-clients

USERNAME="cc"
VSERVERS=($(<./$3))

stop() {
  for ((i = 0; i < ${#VSERVERS[@]}; i++)); do
    ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${VSERVERS[i]} '
        kill -9 $(pgrep -f verifier)
    ' 
  done
}

start(){
    for (( i=0; i<$1; i++ )); do
        num=$(( i % ${#VSERVERS[@]} ))
        scp ./config/verifierConfig${i}.yml ${USERNAME}@${VSERVERS[num]}:~/sosp19/verifier/sample/verifierConfig${i}.yml
        echo "Verifer: ${VSERVERS[num]}"
        ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${VSERVERS[num]} "cd ~/sosp19/verifier; node --max-old-space-size=122880 -r ts-node/register src/verifier serve --config ./sample/verifierConfig${i}.yml| tee ../../logs/verifier${i}.logs" &
    done
}



# setup_docker_deps $1
if [ $1 = "start" ]; then
	start $2
fi
if [ $1 = "stop" ]; then
	stop
fi
