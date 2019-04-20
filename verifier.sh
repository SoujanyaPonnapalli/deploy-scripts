#!/bin/bash
# Usage - ./deploy_client.sh NUM_STORAGE_SERVICES
# $1 start/stop $2 - num-clients

USERNAME="cc"
VSERVERS=($(<./$3))
numVerf=$2
vPruneDepth=$4
bList=($(<./beneficiaryList))

for ((i = 0; i < ${#VSERVERS[@]}; i++)); do
	PORT[i]=9000
done


makeConfig(){
	echo -e "verifiers:" >> ./config/tmp
	for (( v=0; v < ${numVerf}; v++)); do
		num=$(( v % ${#VSERVERS[@]} ))
		port=${PORT[num]}
		echo -e "\t- ${VSERVERS[num]}:${port}" >> ./config/tmp
		echo "${VSERVERS[num]}:${port}" >> ./config/verf.txt
		PORT[${num}]=$(( ${PORT[num]} + 1 ))
	done

	for(( v=0; v < ${numVerf}; v++)); do
		num=$(( v % ${#VSERVERS[@]} ))
		cp verifierConfig.yml ./config/verifierConfig${v}.yml
		line=$(( v+2 ))
		echo "\n" >> ./config/verifierConfig${v}.yml
    sed "${line}d" ./config/tmp >> ./config/verifierConfig${v}.yml
    echo -e "pruneDepth: ${vPruneDepth}" >> ./config/verifierConfig${v}.yml
    echo -e "beneficiary: ${bList[${v}]}" >> ./config/verifierConfig${v}.yml
	done
}

stop() {
  for ((i = 0; i < ${#VSERVERS[@]}; i++)); do
    ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${VSERVERS[i]} '
        kill -9 $(pgrep -f verifier)
    ' 
  done
}

start(){
  for (( i=0; i<${numVerf}; i++ )); do
    num=$(( i % ${#VSERVERS[@]} ))
    scp -i ~/disaggregatedblockchain.pem ./config/verifierConfig${i}.yml ${USERNAME}@${VSERVERS[num]}:~/sosp19/verifier/sample/verifierConfig${i}.yml
    echo "Verifer: ${VSERVERS[num]}"
    ssh -i ~/disaggregatedblockchain.pem ${USERNAME}@${VSERVERS[num]} "cd ~/sosp19/verifier; 
    node --max-old-space-size=122880 -r ts-node/register src/verifier serve --wait \
    --config ./sample/verifierConfig${i}.yml &> \
    ../../logs/verifier${i}.logs" &
  done
}

if (($# != 4)); then
  echo "./verifier.sh start/stop numVerifiers verifierIPs pruneDepth"
fi

# setup_docker_deps $1
if [ $1 = "start" ]; then
  makeConfig
	start
fi
if [ $1 = "stop" ]; then
	stop
fi
