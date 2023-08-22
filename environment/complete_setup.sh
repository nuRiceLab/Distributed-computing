source ~/dune_presetup_202305.sh
dune_setup
kx509
export ROLE=Analysis
voms-proxy-init -rfc -noregen voms=dune:/dune/Role=$ROLE
setup sam_web_client
export SAM_EXPERIMENT=dune
setup dunesw v09_72_01d00 -q e20:prof
setup_fnal_security
setup larsoft v09_72_00 -q debug:e20

source setupMay2023Tutorial.sh
cd $MRB_SOURCE
mrbslp
cd
