#!/bin/bash
export IOC_EXEC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#export VAR_DIR="/opt/nonvolatile/var"
export VAR_DIR="/tmp
export BASE_VER="7.0.1.1"
export REQUIRE_VER="3.0.4"
export E3_BIN_DIR="/epics/base-$BASE_VER/require/$REQUIRE_VER/bin"
export PROCSERV="/usr/bin/procServ"
export PROCSERV_PORT=2005
export PROCSERV_IOC_DIR=hzb-v20-evr1
export IOC_ST_CMD=st.hzb-v20-evr1.cmd
source "$E3_BIN_DIR/setE3Env.bash"
$E3_BIN_DIR/iocsh.bash $IOC_EXEC_DIR/$IOC_ST_CMD &
