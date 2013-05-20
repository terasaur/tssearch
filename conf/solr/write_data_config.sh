#!/bin/sh

SCRIPT_DIR=`dirname "$(cd ${0%/*} && echo $PWD/${0##*/})"`

if [ -f ../../../terasaur/conf/terasaur-config-local.groovy ]; then
    TERASAUR_CONFIG="../../../terasaur/conf/terasaur-config-local.groovy"
else
    if [ -f /etc/terasaur/terasaur-config-local.groovy ]; then
        TERASAUR_CONFIG="/etc/terasaur/terasaur-config-local.groovy"
    else
        echo "Could not find terasaur config file terasaur-config-local.groovy"
        exit 1
    fi
fi

SOURCE_FILE="${SCRIPT_DIR}/data-config.xml-dist"
DEST_FILE="${SCRIPT_DIR}/data-config.xml"
if [ ! -f $SOURCE_FILE ]; then
    echo "Could not find data-config.xml-dist"
    exit 1
fi

# Extract database connection information from grails app config file
TERASAUR_DB_HOST=`grep 'url = "jdbc:postgresql' ${TERASAUR_CONFIG} |tail -n 1 | sed -e "s/.*:\/\/\(.*\):\(.*\)\/.*/\1/"`
TERASAUR_DB_PORT=`grep 'url = "jdbc:postgresql' ${TERASAUR_CONFIG} |tail -n 1 | sed -e "s/.*:\/\/\(.*\):\(.*\)\/.*/\2/"`
TERASAUR_DB_NAME=`grep 'url = "jdbc:postgresql' ${TERASAUR_CONFIG} |tail -n 1 | sed -e "s/.*:\/\/.*\/\(.*\)\"/\1/"`
TERASAUR_DB_USER=`grep 'username = ".*' ${TERASAUR_CONFIG} |tail -n 1 |sed -e "s/.*username = \"\(.*\)\"/\1/"`
TERASAUR_DB_PASS=`grep 'password = ".*' ${TERASAUR_CONFIG} |tail -n 1 |sed -e "s/.*password = \"\(.*\)\"/\1/"`

# Write data-config.xml file with injected database credentials
cat $SOURCE_FILE \
    | sed -e "s/TERASAUR_DB_HOST/${TERASAUR_DB_HOST}/
        s/TERASAUR_DB_PORT/${TERASAUR_DB_PORT}/
        s/TERASAUR_DB_NAME/${TERASAUR_DB_NAME}/
        s/TERASAUR_DB_USER/${TERASAUR_DB_USER}/
        s/TERASAUR_DB_PASS/${TERASAUR_DB_PASS}/" \
    > $DEST_FILE

