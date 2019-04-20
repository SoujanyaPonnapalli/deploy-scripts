# ./run.sh snodesFile vnodes cnodes vnum vpruneDepth cnum
snodes=$1
vnodes=$2
cnodes=$3
numVerf=$4
vPruneDepth=$5
VSERVERS=($(<./$2))
numClient=$6

for ((i = 0; i < ${#VSERVERS[@]}; i++)); do
	PORT[i]=9000
done

run(){
	/bin/bash storage.sh start snodes &
	sleep 1
	/bin/bash verifier.sh start ${numVerf} vnodes &
	sleep 1
	/bin/bash client.sh start ${numClient} cnodes &
}

makeConfig(){
	rm ./config/*
	rm verf.txt
	echo -e "verifiers:" >> ./config/tmp
	for (( v=0; v < ${numVerf}; v++)); do
		num=$(( v % ${#VSERVERS[@]} ))
		port=${PORT[num]}
		echo -e "\t- ${VSERVERS[num]}:${port}" >> ./config/tmp
		echo "${VSERVERS[num]}:${port}" >> verf.txt
		PORT[${num}]=$(( ${PORT[num]} + 1 ))
	done

	for(( v=0; v < ${numVerf}; v++)); do
		num=$(( v % ${#VSERVERS[@]} ))
		cp verifierConfig.yml ./config/verifierConfig${v}.yml
		line=$(( v+2 ))
		echo "\n" >> ./config/verifierConfig${v}.yml
		sed "${line}d" ./config/tmp >> ./config/verifierConfig${v}.yml
		echo -e "pruneDepth: ${vPruneDepth}" >> ./config/verifierConfig${v}.yml
	done
}


makeConfig
# run