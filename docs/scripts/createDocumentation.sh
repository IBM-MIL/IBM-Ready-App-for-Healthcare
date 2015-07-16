#!/bin/bash

#
#  Licensed Materials - Property of IBM
#  © Copyright IBM Corporation 2014. All Rights Reserved.
#  This sample program is provided AS IS and may be used, executed, copied and modified without
#  royalty payment by customer (a) for its own instruction and study, (b) in order to develop
#  applications designed to run with an IBM product, either for customer's own internal use or for
#  redistribution by customer, as part of such an application, in customer's own products.
#
#

# Colors for printing text
RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

################################################################
################################################################
# CHANGE THESE VARIABLES AS NEEDED FOR YOUR PROJECT
################################################################
################################################################
# Relative path from this script to the folder which contains the JavaScript source code
JAVASCRIPT_RELATIVE_BASE_PATH="./../../html/js"

# Relative path from this script to the folder which contains the XCode Project File
SWIFT_RELATIVE_PATH_PROJECT="./../../iOS/"

# Relative path from the XCode Project File back to the docs folder
SWIFT_RELATIVE_PATH_DOCS="./../docs"

# Relative path to the MobileFirst code
MOBILE_FIRST_JS_RELATIVE_BASE_PATH="./../../ReadyAppsMobileFirst"

# Array of JavaScript file paths that we want to create documentation for
# Any paths in this array will be documented by JSDoc
declare -a javaScriptArr=(
	$JAVASCRIPT_RELATIVE_BASE_PATH/src
)

# Array of Javascript file paths for the JS Files in the MobileFirst code
declare -a mobileFirstJSArray=(
    $MOBILE_FIRST_JS_RELATIVE_BASE_PATH/adapters/ReadyAppsAdapter/ReadyAppsAdapter
    $MOBILE_FIRST_JS_RELATIVE_BASE_PATH/resources
)

################################################################
################################################################
# Parse command line arguments
################################################################
################################################################
# Variables
GEN_JAVA=NO
GEN_SWIFT=NO
GEN_JAVASCRIPT=NO
PRINT_HELP=NO
CREATE_ZIP=YES

# If there are no arguments, generate all docs
if [ $# -eq 0 ]; then
    GEN_JAVA=YES
    GEN_SWIFT=YES
    GEN_JAVASCRIPT=YES
fi

# Go through all defined arguments (the argument can be empty)
while [ "${1+defined}" ]; do
    case "$1" in
        -j | --java)
            GEN_JAVA=YES
            shift
            ;;
        -v | --javascript)
            GEN_JAVASCRIPT=YES
            shift
            ;;
        -s | --swift)
            GEN_SWIFT=YES
            shift
            ;;
        -h | --help)
            PRINT_HELP=YES
            CREATE_ZIP=NO
            shift
            ;;
    esac
done

################################################################
################################################################
# Print Help documentation if needed
################################################################
################################################################
if [ $PRINT_HELP == YES ]; then
    echo -e "If just ./createDocumentation with no arguments is run, docs will be generated for Java, JavaScript, and Swift"
    echo -e "Available command line arguments for customization:"
    echo -e "\t -j | --java : Will generate Java docs"
    echo -e "\t -v | --javascript : Will generate JavaScript docs"
    echo -e "\t -s | --swift : Will generate Swift docs"
    echo -e "Example: ./createDocumentation -j --swift will generate ONLY Java and Swift documents"
fi

################################################################
################################################################
# Delete all the Documentation directories and remake to ensure zombie files dont remain
################################################################
################################################################
rm ./../documentation.zip
if [ $GEN_JAVA == YES ]; then
    rm -rf ./../gen/Java
    mkdir ./../gen/Java
    rm -rf ./../MobileFirst/gen/Java
    mkdir ./../MobileFirst/gen/Java


fi

if [ $GEN_JAVASCRIPT == YES ]; then
    rm -rf ./../gen/JavaScript
    rm -rf ./../MobileFirst/gen/Javascript
    mkdir ./../gen/JavaScript
    mkdir ./../MobileFirst/gen/Javascript

fi

if [ $GEN_SWIFT == YES ]; then
    rm -rf ./../gen/Swift
    mkdir ./../gen/Swift
fi

################################################################
################################################################
# Generate Java Docs
################################################################
################################################################
if [ $GEN_JAVA == YES ]; then
    doxygen doxygen_config
    echo -e "${GREEN_COLOR}Successfully generated Java documentation with Doxygen ${NO_COLOR}"

    doxygen doxygen_config_mobileFirst
    echo -e "${GREEN_COLOR}Successfully generated Java documentation for the MobileFirst platform with Doxygen ${NO_COLOR}"

fi

################################################################
################################################################
# Generate JavaScript Docs
################################################################
################################################################
if [ $GEN_JAVASCRIPT == YES ]; then
    for path in "${javaScriptArr[@]}"
    do
        if [ -d "$path" ]; then
            jsdoc $path -r -d ./../gen/JavaScript
            return_code=$?
            if [[ $return_code == 0 ]] ; then
                echo -e "${GREEN_COLOR}Successfully generated JavaScript documentation with JSDoc for path ${path}${NO_COLOR}"
            else
                echo -e "${RED_COLOR}Running JSDoc on path ${path} failed with return value ${return_code}${NO_COLOR}"
            fi
        else
            echo -e "${RED_COLOR}${path} does not exist. No JavaScript documentation generated for this path.${NO_COLOR}"
        fi
    done
fi

################################################################
################################################################
# Generate JavaScript Docs for the MobileFirst code
################################################################
################################################################
if [ $GEN_JAVASCRIPT == YES ]; then
    for path in "${mobileFirstJSArray[@]}"
        do
        if [ -d "$path" ]; then
            jsdoc $path -r -d ./../MobileFirst/gen/JavaScript
            return_code=$?
            if [[ $return_code == 0 ]] ; then
                echo -e "${GREEN_COLOR}Successfully generated MobileFirst JavaScript documentation with JSDoc for path ${path}${NO_COLOR}"
            else
                echo -e "${RED_COLOR}Running JSDoc on path ${path} failed with return value ${return_code}${NO_COLOR}"
            fi
        else
            echo -e "${RED_COLOR}${path} does not exist. No MobileFirst JavaScript documentation generated for this path.${NO_COLOR}"
        fi
    done
fi

################################################################
################################################################
# Generate Swift Docs
################################################################
################################################################
if [ $GEN_SWIFT == YES ]; then
    cd $SWIFT_RELATIVE_PATH_PROJECT
    jazzy -o $SWIFT_RELATIVE_PATH_DOCS/gen/Swift
    cd -
fi

################################################################
################################################################
# Create Zip file of the documentation
################################################################
################################################################
if [ $CREATE_ZIP == YES ]; then
    cd ..
    zip -q -r documentation.zip * -x "./script/*"
fi
	
