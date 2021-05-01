#!/usr/bin/env bash
set -euo pipefail

cp ./week1/percolation/Percolation.java ./Percolation.java
cp ./week1/percolation/PercolationStats.java ./PercolationStats.java

sed -i '' '/package /d' ./Percolation.java
sed -i '' '/package /d' ./PercolationStats.java

zip percolation.zip ./Percolation.java ./PercolationStats.java
