DIRECTORY=may2023tutorial
USERNAME=`whoami`

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
export WORKDIR=/dune/app/users/${USERNAME}
if [ ! -d "$WORKDIR" ]; then
  export WORKDIR=`echo ~`
fi

cd $WORKDIR/$DIRECTORY
source localProducts*/setup
cd work
setup dunesw v09_72_01d00 -q e20:prof
mrbslp
