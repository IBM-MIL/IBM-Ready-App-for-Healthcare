#!/bin/bash

################################################################################################# 
#
#  Licensed Materials - Property of IBM
#  © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
#
################################################################################################

SCRIPT_DIR=`dirname "$0"`
# Lets setup all our known variables
OPTIND=1
BASE_DIR=${SCRIPT_DIR}/..
declare -a FILES_WTIH_APP_NAME=( ${BASE_DIR}/Android/Physio/app/src/main/res/values/strings.xml ${BASE_DIR}/iOS/Healthcare/en.lproj/Main.storyboard ${BASE_DIR}/docs/index.html ${BASE_DIR}/html/index.html)
APP_NAME=`cat "${SCRIPT_DIR}/appname.txt"`
NEW_APP_NAME="NewName"

###############################################################################
#
#                           Functions Section
#
###############################################################################

################################################################################################
## Standard usage statement. Lets make sure they know how to call the script.
################################################################################################
usage() {
	echo "changeAppName.sh -n <app-name>"
	echo "    -n The new name of the application"
}

################################################################################################
## Standard failure method...lets print a message out then fail with the "appropriate" return
## code
################################################################################################
fail() {
	MESSAGE=${1}
	RC=${2}
	echo ""
	echo "${MESSAGE}"
	echo ""
	usage
	exit ${RC}
}

################################################################################################
## Function will take a file name, a string to search for and a replacement string.  The function
## will loop through the lines in the file and replace any instances of the search string with
## the replacement string.  This can be used to replace any string with any other string in
## any text file.
################################################################################################
updateFile() {
	FILE=$1
	TXT_TO_REPLACE=$2
	REPLACEMENT_TXT=$3
	BACKUP_FILE="${FILE}.bak"
	echo "Changing '${TXT_TO_REPLACE}' to '${REPLACEMENT_TXT}' in file: ${FILE}"
	cp ${FILE} ${BACKUP_FILE}
	output=`sed "s/${TXT_TO_REPLACE}/${REPLACEMENT_TXT}/g" ${BACKUP_FILE} > ${FILE}`
	cmdrc=$?
	rm -f ${BACKUP_FILE}
}

###############################################################################
#
# Lets parse our arguments.
# Basically just saying lets parse args, im aware of h and n, and n requires an argument.
#
###############################################################################
while getopts ":hn:" opt; do
	case "${opt}" in
	h)  usage
		exit 0
		;;
	n)  NEW_APP_NAME=$OPTARG
		;;
	esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift
#echo "name=$APP_NAME, leftovers: '$@'"ß

###############################################################################
#
# Now lets do some real work.
#
###############################################################################


################################################################################################
## Checking to see if the passed in application name is valid...should not be
## the original string nor some empty string
################################################################################################
if [ "${NEW_APP_NAME}" = ""  -o  "${NEW_APP_NAME}" = "NewName" ]; then
	fail "You need to supply a new application name.  The -n parameter cannot be empty." 1
fi

for file in ${FILES_WTIH_APP_NAME[@]} ; do
	updateFile "${file}" "${APP_NAME}" "${NEW_APP_NAME}" 
done

echo ${NEW_APP_NAME}>"${SCRIPT_DIR}/appname.txt"

exit 0
