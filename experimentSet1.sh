# TEST scalability with verifier-verifier

./storage.sh start snodes 8;
./verifier.sh start 3 vnodes 8;
./run.sh 1 cnodes trace1M scale/1client/run2;

./storage.sh start snodes 8;
./verifier.sh start 3 vnodes 8;
./run.sh 2 cnodes trace1M scale/2client;

./storage.sh start snodes 8;
./verifier.sh start 3 vnodes 8;
./run.sh 4 cnodes trace1M scale/4client;

./storage.sh start snodes 8;
./verifier.sh start 3 vnodes 8;
./run.sh 8 cnodes trace1M scale/8client;

./storage.sh start snodes 8;
./verifier.sh start 3 vnodes 8;
./run.sh 16 cnodes trace1M scale/16client;


#TEST different pruneDepth

./storage.sh start snodes 8;
./verifier.sh start 3 vnodes 8;
./run.sh 8 cnodes trace1M prune/88With8Clients;

./storage.sh start snodes 7;
./verifier.sh start 3 vnodes 7;
./run.sh 8 cnodes trace1M prune/77With8Clients;

./storage.sh start snodes 6;
./verifier.sh start 3 vnodes 6;
./run.sh 8 cnodes trace1M prune/66With8Clients;
