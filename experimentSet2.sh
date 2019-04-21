numRuns=5

#TEST scalability of storage node with different pruning

for((s=0; s<9; s++)); do
  for ((i = 0; i < ${numRuns}; i++)); do
      ./storage.sh start snodes ${s};
      ./run_benchClient.sh 1 cnodes 1000000 storageNodeBenchmark/sPrune${s}/1clients/run${i};

      ./storage.sh start snodes ${s};
      ./run_benchClient.sh 2 cnodes 1000000 storageNodeBenchmark/sPrune${s}/2clients/run${i};

      ./storage.sh start snodes ${s};
      ./run_benchClient.sh 4 cnodes 1000000 storageNodeBenchmark/sPrune${s}/4clients/run${i};

      ./storage.sh start snodes ${s};
      ./run_benchClient.sh 8 cnodes 1000000 storageNodeBenchmark/sPrune${s}/8clients/run${i};

      ./storage.sh start snodes ${s};
      ./run_benchClient.sh 16 cnodes 1000000 storageNodeBenchmark/sPrune${s}/16clients/run${i};
  done
done
