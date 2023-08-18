#!/bin/sh

VARFILE=/dune/app/users/${USER}/nuana_vars.sh # Source all the variables
source ${VARFILE}

# __--== SUBMISSION ==--__

jobsub_submit -G dune --mail-on-error -N=${NJOBS} --memory=${MEMORY} --disk=2GB --expected-lifetime=${LIFETIME} --cpu=1 --tar_file_name=dropbox://${TARBALL} -f dropbox://${VARFILE} --singularity-image /cvmfs/singularity.opensciencegrid.org/fermilab/fnal-wn-sl7:latest --append_condor_requirements='(TARGET.HAS_Singularity==true&&TARGET.HAS_CVMFS_dune_opensciencegrid_org==true&&TARGET.HAS_CVMFS_larsoft_opensciencegrid_org==true&&TARGET.CVMFS_dune_opensciencegrid_org_REVISION>=1105&&TARGET.HAS_CVMFS_fifeuser1_opensciencegrid_org==true&&TARGET.HAS_CVMFS_fifeuser2_opensciencegrid_org==true&&TARGET.HAS_CVMFS_fifeuser3_opensciencegrid_org==true&&TARGET.HAS_CVMFS_fifeuser4_opensciencegrid_org==true)' -e GFAL_PLUGIN_DIR=/usr/lib64/gfal2-plugins -e GFAL_CONFIG_DIR=/etc/gfal2.d file://${JOBSCRIPT}
