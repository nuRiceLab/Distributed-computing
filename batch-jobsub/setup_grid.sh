#!/bin/bash

DIRECTORY=may2023tutorial
USERNAME=${GRID_USER}    
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
export WORKDIR=${_CONDOR_JOB_IWD}
if [ ! -d "$WORKDIR" ]; then
  export WORKDIR=`echo .`
fi

source ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/localProducts*/setup-grid

mrbslp