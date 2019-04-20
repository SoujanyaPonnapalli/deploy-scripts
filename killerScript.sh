#!/bin/bash

./storage.sh stop snodes 8;
./verifier.sh stop 5 vnodes 8;
./client.sh stop 20 cnodes trace1M
