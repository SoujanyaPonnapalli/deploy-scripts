numRuns=5

#TEST different pruneDepth

for ((i = 0; i < ${numRuns}; i++)); do
    ./storage.sh start snodes 8;
    ./verifier.sh start 3 vnodes 8;
    ./run.sh 8 cnodes trace1M prune/88With8Clients/run${i};

    ./storage.sh start snodes 7;
    ./verifier.sh start 3 vnodes 7;
    ./run.sh 8 cnodes trace1M prune/77With8Clients/run${i};

    ./storage.sh start snodes 6;
    ./verifier.sh start 3 vnodes 6;
    ./run.sh 8 cnodes trace1M prune/66With8Clients/run${i};

    ./storage.sh start snodes 5;
    ./verifier.sh start 3 vnodes 5;
    ./run.sh 8 cnodes trace1M prune/55With8Clients/run${i};
done

# TEST scalability with verifier-verifier

for ((i = 0; i < ${numRuns}; i++)); do
  ./storage.sh start snodes 8;
  ./verifier.sh start 3 vnodes 8;
  ./run.sh 1 cnodes trace1M scale/1client/run${i};

  ./storage.sh start snodes 8;
  ./verifier.sh start 3 vnodes 8;
  ./run.sh 2 cnodes trace1M scale/2client/run${i};

  ./storage.sh start snodes 8;
  ./verifier.sh start 3 vnodes 8;
  ./run.sh 4 cnodes trace1M scale/4client/run${i};

  ./storage.sh start snodes 8;
  ./verifier.sh start 3 vnodes 8;
  ./run.sh 8 cnodes trace1M scale/8client/run${i};

  ./storage.sh start snodes 8;
  ./verifier.sh start 3 vnodes 8;
  ./run.sh 16 cnodes trace1M scale/16client/run${i};
done
