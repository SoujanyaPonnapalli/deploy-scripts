# ./run.sh snodesFile vnodes cnodes vnum vpruneDepth cnum
cnodes=$2
CLIENT=($(<./$2))
ALL=($(<./livenodes))
numClient=$1
txnTrace=$3
USERNAME="cc"
logDir=$4
mkdir -p ./logs/${logDir}

run(){
	sleep 100
	for ((j = 0; j < ${numClient}; j++)); do
	   echo  ${txnTrace}
	   echo "./client.sh start ${j} ${cnodes} ${txnTrace}";
	  ./client.sh start ${j} ${cnodes} ${txnTrace} &
	done
	wait
}

cleanup(){
	ssh  -i ~/disaggregatedblockchain.pem  ${USERNAME}@${ALL[$1]} '
	kill -9 $(pgrep -f verifier);
	kill -9 $(pgrep -f server);
	kill -9 $(pgrep -f rainblock-client)'
	scp -i ~/disaggregatedblockchain.pem  ${USERNAME}@${ALL[$1]}:~/logs/* ./logs/${logDir}/ 
	ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${ALL[$1]} "rm -rf ~/logs/*"
}

summarize(){
	cat ./logs/${logDir}/verifier0.log | grep "Assembled" | grep -v "Assembled 0" > tmp.txt
	python throughput.py > ./logs/${logDir}/summary.txt
	rm tmp.txt
}

if (($# != 4)); then
  echo "./run.sh numClients clientIPs traceToExecute logDirectory"
fi

run
echo "Clients done preexecuting...!"

for ((j = 0; j < ${#ALL[@]}; j++)); do cleanup ${j} & done
wait

summarize
