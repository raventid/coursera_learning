#!/usr/bin/env bash
set -euo pipefail

cp ./week2/queues/Deque.java ./Deque.java
cp ./week2/queues/RandomizedQueue.java ./RandomizedQueue.java
cp ./week2/queues/Permutation.java ./Permutation.java

sed -i '' '/package /d' ./Deque.java
sed -i '' '/package /d' ./RandomizedQueue.java
sed -i '' '/package /d' ./Permutation.java

zip queues.zip ./Deque.java ./RandomizedQueue.java ./Permutation.java

rm ./Deque.java
rm ./RandomizedQueue.java
rm ./Permutation.java
