#!/bin/bash
#export IOC_EXEC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export IOC_NAME=ring-dev-01
export IOC_EXEC_DIR=/epics/iocs/cmds/$IOC_NAME
export VAR_DIR="/var"
export BASE_VER="7.0.3.1"
export REQUIRE_VER="3.1.2"
export E3_BIN_DIR="/epics/base-$BASE_VER/require/$REQUIRE_VER/bin"
export PROCSERV="/usr/bin/procServ"
export PROCSERV_PORT=2003
export PROCSERV_RUN_DIR=$IOC_NAME
export PROCSERV_LOG_FILE=out-RNG-DEV-01

export IOC_ST_CMD=st.$IOC_NAME.cmd
source "$E3_BIN_DIR/setE3Env.bash"

# Ensure log and run directories exist
mkdir -p $VAR_DIR/log/procServ
mkdir -p $VAR_DIR/run/procServ/$PROCSERV_RUN_DIR

#$PROCSERV -f -L $VAR_DIR/log/procServ/$PROCSERV_LOG_FILE -i ^C^D -c $VAR_DIR/run/procServ/$PROCSERV_RUN_DIR $PROCSERV_PORT $E3_BIN_DIR/iocsh.bash $IOC_EXEC_DIR/$IOC_ST_CMD &
# Remove backgrounding '&' for startup with systemd
$PROCSERV -f -L $VAR_DIR/log/procServ/$PROCSERV_LOG_FILE -i ^C^D -c $VAR_DIR/run/procServ/$PROCSERV_RUN_DIR $PROCSERV_PORT $E3_BIN_DIR/iocsh.bash $IOC_EXEC_DIR/$IOC_ST_CMD
