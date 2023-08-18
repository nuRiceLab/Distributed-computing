#!/bin/sh

# __--== SUB-SPECIFIC ==--__
export MEMORY=1400MB
export LIFETIME=4h
export TARBALL=/path/to/nuball.tar.gz
export JOBSCRIPT=/path/to/run_nuana.sh

# __--== RUN-SPECIFIC ==--__
export DATASET=user-dataset
export NEVTS="-n 1" # If unassigned, run all; else enter "-n <nevts>"

# __--== COMMON ++--__
export NJOBS=50 # Edit as necessary
