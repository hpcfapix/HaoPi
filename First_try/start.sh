#!/bin/bash

BASE_DIR=`pwd`
TMP_DIR=${BASE_DIR}/tmp
DIST_DIR=${BASE_DIR}/dist
DB_DATA_PATH=${BASE_DIR}/mongodb_data

rm -rf ${TMP_DIR}
rm -rf ${DB_DATA_PATH}
mkdir ${TMP_DIR}
mkdir ${DB_DATA_PATH}

# check if mongodb is installed and start mongod with specified data path
echo "Checking ..."
echo "> mongodb"
MONGODB_BIN=${DIST_DIR}/mongodb/bin/mongod
command -v ${MONGODB_BIN} --dbpath ${DB_DATA_PATH} >/dev/null 2>&1 || { echo " mongodb : Not installed. Aborting." >&2; exit 1; }

RESULT=$(netstat -lnt | awk '$6 == "LISTEN" && $4 ~ ":27017"')
if [[ -z "${RESULT// }" ]]
then
    nohup ${MONGODB_BIN} --dbpath ${DB_DATA_PATH} >/dev/null 2>&1 &
    echo $! > ${TMP_DIR}/mongod.pid
else
    echo "> port 27017 already bound by another process. We assume that mongodb is already running."
fi

sleep 10

# check if mongod is successfully started 
HTTP_STATUS=$(curl -s -w %{http_code} localhost:27017)
if [[ ${HTTP_STATUS} != *"200"* ]]
then
    echo "> mongodb is unreachable. Aborting."
    exit 1;
fi
echo "Done. mongodb started successfully on port 27017."

# check if npm and node are installed
echo "Starting the monitoring server ..."
NODE_DIR=${DIST_DIR}/nodejs/bin
NODE_BIN=${NODE_DIR}/node
NPM_BIN=${DIST_DIR}/nodejs/bin/npm
export PATH=${NODE_DIR}:${PATH}

command -v ${NODE_BIN} >/dev/null 2>&1 || { echo " node  : Not installed. Aborting." >&2; exit 1; }
command -v ${NPM_BIN} >/dev/null 2>&1 || { echo " npm  : Not installed. Aborting." >&2; exit 1; }

# install npm dependencies
${NPM_BIN} install

#start the server
nohup ./bin/www >/dev/null 2>&1 &
echo $! > ${TMP_DIR}/node.pid
echo "Done. Server is listening on port 3000."
echo
