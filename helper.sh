#!/bin/bash
USERNAME=cc
HOSTS=$(<$2)
echo ${HOSTS[@]}

INST_DEPS="chmod u+x /home/cc/deps_commands.sh; /bin/bash /home/cc/deps_commands.sh;"

get_logs(){
	mkdir ./logs
	for HOSTNAME in ${HOSTS} ; do
		scp -i ./disaggregatedblockchain.pem ${USERNAME}@${HOSTNAME}:~/logs/* ./logs/${HOSTNAME}
	done
}

setup(){
	for HOSTNAME in ${HOSTS} ; do single_setup "${HOSTNAME}" & done
}

send_file(){
	for HOSTNAME in ${HOSTS} ; do scp -i  ./disaggregatedblockchain.pem ./rainblock-client ${USERNAME}@${HOSTNAME}:~/sosp19/client/rainblock-client & done
}


if [ $1 = "logs" ]; then
	get_logs
fi
if [ $1 = "sendfile" ]; then
	send_file
fi
