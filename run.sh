# ./run.sh snodesFile vnodes cnodes vnum vpruneDepth cnum
cnodes=$2
CLIENT=($(<./$2))
ALL=($(<./livenodes))
numClient=$1
txnTrace=$3
USERNAME="cc"

run(){
	sleep 100
	for ((j = 0; j < ${numClient}; j++)); do
	   echo  ${txnTrace}
	   echo "./client.sh start ${j} ${cnodes} ${txnTrace}";
	  ./client.sh start ${j} ${cnodes} ${txnTrace} &
	done
	wait
	echo "Everything stopped"
	for ((j = 0; j < ${#ALL[@]}; j++)); do
		ssh  -i ~/disaggregatedblockchain.pem  ${USERNAME}@${ALL[j]} 'kill -9 $(pgrep -f verifier); 
		kill -9 $(pgrep -f server); 
		kill -9 $(pgrep -f rainblock-client)' &
	done
	# PULL and DELETE LOGS HERE?
}

if (($# != 3)); then
  echo "./run.sh numClients clientIPs traceToExecute"
fi

run