#!/bin/bash

##firstly install node, npm, express, mangodb;
##copy them into /usr/local/;

#
#export PATH=$PATH:/usr/local/bin
#

#!!!!!run only with sudo
DB_DATA_PATH=/home/fangli/MF/HaoPi/First_try/data/
rm -rf $DB_DATA_PATH
mkdir $DB_DATA_PATH

npm install 

mongod --dbpath ${DB_DATA_PATH} &

mongo db_test &

npm start 