# ./run.sh snodesFile vnodes cnodes vnum vpruneDepth cnum
cnodes=$2
CLIENT=($(<./$2))
ALL=($(<./livenodes))
numClient=$1
ops=$3
USERNAME="cc"
logDir=$4
mkdir -p ./logs/${logDir}


# Doesn't handle 2 clients on same machine
run(){
	sleep 200
	for ((j = 0; j < ${numClient}; j++)); do
	   echo  ${ops}
	   ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${CLIENT[j]} "
        cd /home/cc/sosp19/storage; node  --max-old-space-size=122880 -r ts-node/register \
        src/benchClient.ts ${ops} &> ~/logs/client${j}.log
    " &
	done
	wait
}

cleanup(){
	ssh  -i ~/disaggregatedblockchain.pem  ${USERNAME}@${ALL[$1]} 'kill -9 $(pgrep -f server);'
	ssh  -i ~/disaggregatedblockchain.pem  ${USERNAME}@${ALL[$1]} 'kill -9 $(pgrep -f benchClient);'
	scp -i ~/disaggregatedblockchain.pem  ${USERNAME}@${ALL[$1]}:~/logs/* ./logs/${logDir}/ 
	ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${ALL[$1]} "rm -rf ~/logs/*"
}

# summarize(){
# 	cat ./logs/${logDir}/verifier0.log | grep "Assembled" | grep -v "Assembled 0" > tmp.txt
# 	python throughput.py > ./logs/${logDir}/summary.txt
# 	rm tmp.txt
# }

if (($# != 4)); then
  echo "./run.sh numClients clientIPs traceToExecute logDirectory"
fi

run
for ((i = 0; i < ${#ALL[@]}; i++)); do cleanup ${i} & done
wait
# summarize
echo "Clients done...!"
