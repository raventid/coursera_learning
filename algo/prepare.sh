#!/usr/bin/env bash
set -euo pipefail

sed -i '' '/package /d' ./week1/percolation/Percolation.java
sed -i '' '/package /d' ./week1/percolation/PercolationStats.java
