#!/bin/bash

echo "Running on $(hostname) at ${GLIDEIN_Site}. GLIDEIN_DUNESite = ${GLIDEIN_DUNESite}"

OUTPUT=nuana_${CLUSTER}_${PROCESS}
OUTDIR=/pnfs/dune/scratch/users/${GRID_USER}/nu_analysis/${OUTPUT}

if [ -e ${INPUT_TAR_DIR_LOCAL}/setup_grid.sh ]; then
    . ${INPUT_TAR_DIR_LOCAL}/setup_grid.sh
else
    echo "Error: Setup script not found. Exiting."
    exit 1
fi

cd ${_CONDOR_JOB_IWD}

# __--== ENV VARIABLES FOR XROOTD/IFDH ==--__
export IFDH_CP_MAXRETRIES=2
export XRD_CONNECTIONRETRY=32
export XRD_REQUESTTIMEOUT=14400
export XRD_REDIRECTLIMIT=255
export XRD_LOADBALANCERTTL=7200
export XRD_STREAMTIMEOUT=14400

. ${CONDOR_DIR_INPUT}/nuana_vars.sh # Source all the variables

CONFIGFCL=${INPUT_TAR_DIR_LOCAL}/ana.fcl

DSETLEN=$(samweb list-files "defname: ${DATASET}" | wc -l)
FILES_PER_JOB=$(((${DSETLEN} + ${NJOBS} - 1)/${NJOBS}))
SUBSET="${GRID_USER}-nuanaw22-${PROCESS}"
samweb create-definition ${SUBSET} "defname:${DATASET}" with limit ${FILES_PER_JOB} offset $((${PROCESS}*${FILES_PER_JOB}))
FILES=$(samweb list-files "defname:${SUBSET}")

for f in ${FILES}; do
    lar ${NEVTS} -c ${CONFIGFCL} -s $(samweb2xrootd ${f})
    LAR_RESULT=$?
    if [ ${LAR_RESULT} -ne 0 ]; then
        echo "Error during lar submission. See output logs."
	exit ${LAR_RESULT}
    fi
done

samweb list-files "defname:${SUBSET}" >> listroots.txt
ifdh cp -D listroots.txt ${OUTDIR}
IFDH_RESULT=$?
if [ ${IFDH_RESULT} -ne 0 ]; then
   echo "Error during copyback of root list. See output logs."
   exit ${IFDH_RESULT}
fi

ifdh cp -D event* ${OUTDIR}
IFDH_RESULT=$?
if [ ${IFDH_RESULT} -ne 0 ]; then
    echo "Error during copyback of info/image. See output logs."
    exit ${IFDH_RESULT}
fi

if [ -f *hist.root ]; then
    mv *hist.root ${OUTPUT}_hist.root
    ifdh cp -D *hist.root ${OUTDIR}
    IFDH_RESULT=$?
    if [ $IFDH_RESULT -ne 0 ]; then
        echo "Error during copyback of histogram. See output logs."
        exit $IFDH_RESULT
    fi
fi

echo "Completed successfully."
exit 0
