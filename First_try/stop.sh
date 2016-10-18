#!/bin/bash

#
# GLOBAL VARIABLES
#
BASE_DIR=`pwd`
TMP_DIR=${BASE_DIR}/tmp

#
# SETUP
#
cd ${TMP_DIR}

#
# STOPPING SERVICES
#
echo "Stopping services ..."
echo "> mongod"
if [ -f "mongod.pid" ]
then
    PID=$(cat mongod.pid)
    kill ${PID}
    rm -f mongod.pid
else
    echo "Couldn't find PID associated with mongod process."
    echo "Please kill the service manually."
fi

echo "> node"
if [ -f "node.pid" ]
then
    PID=$(cat node.pid)
    kill ${PID}
    rm -f node.pid
else
    echo "Couldn't find PID associated with node process."
    echo "Please kill the service manually."
fi
echo "Done."
echo

cd ${BASE_DIR}
rm -rf ${TMP_DIR}