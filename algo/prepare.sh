#!/usr/bin/env bash
set -euo pipefail

sed -i '' '/package /d' ./week1/percolation/Percolation.java
sed -i '' '/package /d' ./week1/percolation/PercolationStats.java

zip percolation.zip ./week1/percolation/Percolation.java ./week1/percolation/PercolationStats.java
