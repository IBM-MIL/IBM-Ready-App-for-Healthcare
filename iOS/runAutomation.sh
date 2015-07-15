#!/bin/bash

# ui_automation_runner.sh
# Created by Sohail Ahmed 
# @idStar
#
# This script provides a nice abstraction over the 'instruments' command line tool, especially when targeting
# the iOS Simulator where device directories and fully qualified app paths are frequently changing.
# The key benefit of using this script is so that by specifying intent (i.e. which simulator, what app),
# you can be abstracted from having to hunt down the appropriate folders and paths themselves to pass to Apple's
# own command line tool (which does not automatically resolve these paths for you).
#
# Of course, you still need to pass information like where the test file you wish to run is located, what simulator (by name)
# you wish to run the test on and where you'd like the test results output to go.
#
# You are not meant to edit this file except in the cases where:
#	
# 1. You'd like to turn on the debug flag ('DEBUG_MODE_ENABLED') to see more of what's happening behind the scenes
# 2. Apple changes the format of the underlying 'instruments' command and/or the location for where simulators go or the 
#	 path to the Automation Instrument template itself.
#
# This script was last edited for use with Xcode 6.0.1. If this script isn't working for you, and history is our guide, it
# could very well be that things have changed since this script was written with where you can find the Automation Instrument
# or the command line parameters that the instruments tool expects. 
#
# Note that at the present time, this script will not build your app nor will it define missing simulators. You need to ensure 
# both of these steps have been taken. The goal of this script is very focused: to run UIAutomation tests from the command line.
#
# Limitations
# * No building of your app
# * Minimal error checking and reporting when something goes wrong
# * No unix return code correcting (not sure if that's still a problem with the instruments command line tool)
#
# Usage:
# 	ui_automation_runner.sh \
#       <SIMULATOR_NAME_OR_DEVICE_UDID> \
#       <TEST_APP_NAME> \
#       <JAVASCRIPT_TEST_FILE> \
#       <JAVASCRIPT_TEST_FILES_DIRECTORY> \
#       <TEST_RESULTS_OUTPUT_PATH>
#
# You are strongly advised to use the companion example script 'run_tests.example.sh' to kick off this script. Place all of 
# your custom app and test settings in that script file, which will then kick-off this script.
#
# Note that the paths specified here must all be absolute; home directory relative paths with a tilda (~) don't work,
# although using $HOME does work.


# ===== CONFIGURABLE OPTIONS =====
# Set this to true if you want debug output
DEBUG_MODE_ENABLED=0 # Set to 1 for true (debugging enabled), or 0 for false (debugging statements suppressed).



# ---------- DO NOT EDIT ANYTHING BELOW THIS LINE, UNLESS YOU KNOW WHAT YOU'RE DOING -----------

# ===== GLOBAL CONSTANTS =====
# This is where Xcode installs simulators. Accurate as at Xcode 6.0.1.
BASE_SIMULATORS_PATH="$HOME/Library/Developer/CoreSimulator/Devices"




# ===== COMMAND LINE ARGUMENTS RETRIEVAL =====

# Check: We have the right number of command line arguments.
if [ "$#" -ne 5 ]; then
    if [ "$#" -ne 6  ]; then
        THIS_SCRIPT_NAME=$(basename $0)
        echo "$THIS_SCRIPT_NAME requires five (5) or six (6) command line arguments. Please review comments in the script file for what to provide."
        echo "You are strongly encouraged to use the companion run_tests.sh file to take care of this for you."
        exit 1 # Return an 'unsuccessful' indicator.
    fi
fi


# Place the command line arguments to this shell script into global variables that other functions will be
# able to make use of. All of these parameters are mandatory, otherwise we'll messs up downstream function calls.
SIMULATOR_NAME_OR_DEVICE_UDID=$1
TEST_APP_NAME=$2
JAVASCRIPT_TEST_FILE_NAME=$3
JAVASCRIPT_TEST_FILES_DIRECTORY=$4
TEST_RESULTS_OUTPUT_PATH=$5
if [ "$#" -eq 6 ]; then
    XCODE_PATH=$6
else
    XCODE_PATH="/Applications/Xcode.app"
fi

# UIAutomation Instruments Template location. Accurate as at Xcode 6.0.1.

INSTRUMENTS_AUTOMATION_TEMPLATE_PATH="${XCODE_PATH}/Contents/Applications/Instruments.app/Contents"\
"/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" # DO NOT CHANGE INDENTATION!
if [ ! -f $INSTRUMENTS_AUTOMATION_TEMPLATE_PATH ]; then
    INSTRUMENTS_AUTOMATION_TEMPLATE_PATH="${XCODE_PATH}/Contents/Applications/Instruments.app/Contents"\
"/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate" # DO NOT CHANGE INDENTATION!
fi

# ===== FUNCTIONS =====

# This is the main entry point of the script. Call this function to get things going.
# We do expect that prior to execution, some global variables have been defined. Typically,
# such are extracted from command line arguments.
#
# This function itself, takes no parametes.
main() {
    _save_and_clear_internal_field_separator

    if [ ${DEBUG_MODE_ENABLED} -eq 1 ]; then
        echo "main(): Launched script" $0
    fi

    # Determine the UDID of the simulator we are to use. With Xcode 6.0.1, you can name the simulators as you wish,
    # and they are all given UDIDs that form part of the file path to get to the .app. We can read the device.plist
    # file instead each simulator directory, to figure out which one is ours.
    local simulator_path=`_find_specific_simulator ${BASE_SIMULATORS_PATH} ${SIMULATOR_NAME_OR_DEVICE_UDID}`

    if [ ${DEBUG_MODE_ENABLED} -eq 1 ]; then
        echo "main(): Just searched for simulator_path and got this result:" ${simulator_path}
    fi

    if [ ${simulator_path} == "Simulator Not Found" ]; then
        echo "main(): Couldn't find a simulator with name '"${SIMULATOR_NAME_OR_DEVICE_UDID}"'. Using this as a device UDID instead"
        simulator_path=${SIMULATOR_NAME_OR_DEVICE_UDID}
    fi

    # We're now calling the function that runs the actual instruments command:
    _run_automation_instrument ${TEST_APP_NAME} \
        ${JAVASCRIPT_TEST_FILES_DIRECTORY} \
        ${JAVASCRIPT_TEST_FILE_NAME} \
        ${simulator_path} \
        ${SIMULATOR_NAME_OR_DEVICE_UDID} \
        ${TEST_RESULTS_OUTPUT_PATH}

    _restore_prior_interal_field_separator
}


# Allow us to use spaces in quoted file names in Bash Shell,
# per http://stackoverflow.com/a/1724065/535054 (See Dennis Williamson's comment):
_save_and_clear_internal_field_separator() {
    saveIFS="$IFS"; IFS='';
}


# Revert to the pre-existing IFS shell variable value so as not to leave shell with unintended side effects.
_restore_prior_interal_field_separator() {
    IFS="$saveIFS"
}


# Finds the file system path for the app you specify on the specific simulator device located at the
# path that you've also provided.
#
# @param $1 The path to the specific simulator in which to search for the app.
# @param $2 The name of the app to find. Leave off the ".app" extension. We add it.
#
# The simulator path should be something like:
#
#   "$HOME/Library/Developer/CoreSimulator/Devices/05BB8391-CCB5-47D8-952E-BA3AF342C891"
#
# It is basically some parent folder under which recursive traversal would eventually find the app sought.
# The app name you specify should include the .app suffix. It should already be built for the simulator,
# in order for us to find it.
#
# Note that if you're running UIAutomation tests on a physical device, you won't even need to retrieve
# the information that this function attempts to find for you.
_find_app_path_navigating_changing_guid() {
    # Retrieve parameters:
    local specific_simulator_path=$1
    local test_app_name=$2

    # Does the app name provided already have a '.app' extension?
    if [[ ${test_app_name} =~ ".app" ]]; then
        # YES. This extension is already present, so nothing more to do.
        if [ ${DEBUG_MODE_ENABLED} -eq 1 ]; then
            echo "_find_app_path_navigating_changing_guid(): App name already contains .app extension"
        fi
    else
        # NO. We need to add it now, so that we only come up with one match when searching next.
        if [ ${DEBUG_MODE_ENABLED} -eq 1 ]; then
            echo "_find_app_path_navigating_changing_guid(): Appending .app extension to App Name"
        fi
        test_app_name="$test_app_name.app"
    fi

    cd ${specific_simulator_path}

    # Find the fully qualified path:
    local full_app_path=`find ${specific_simulator_path} -name ${test_app_name}`

    # Did we not find a path for the app in the specified simulator?
    if [ -z ${full_app_path} ]; then
        # YES. And that means we have an error. Without this path, we cannot continue.
        printf "\n"
        printf "============================ ERROR! ============================\n"
        printf "The app '$test_app_name' could not be found on the simulator '$SIMULATOR_NAME_OR_DEVICE_UDID'.\n"
        printf "Check that you've successfully compiled and installed the app in the desired simulator.\n"
        printf "================================================================\n"
        exit 1
    else
        # NO. We have a path. Return that now by echo'ing it back.
        # Return the answer with echo, to allow for piping commands:
        echo ${full_app_path}
    fi
}


# Finds the full path to the custom named iOS simulator you specify. To do that, it will need the
# base path at which simulators live. This seems to change frequently between Xcode releases, so the expectation
# is that you will pass that in.
#
# @param $1 The path to where all iOS simulators can be found.
# @param $2 The user friendly name of the simulator, as you've set it up in the iOS Simulator app on your Mac.
#
# The base simulators path should be something like:
#
#   "$HOME/Library/Developer/CoreSimulator/Devices"
#
# It is basically some parent folder under which all installed iOS simulators exist.
#
# The simulator name is what you named your simulator in the custom simulators configuration/install,
# within the iOS Simulator app.
_find_specific_simulator() {
    # Reanimate command line parameters into nicely named variables:
    local base_simulators_path=$1  # The path that is the root of the various simulators that could be installed.
    local simulator_name=$2  # The custom simulator a user can give different simulator configurations, since the Xcode 6.0.1 iOS Simulator app

    # Construct the line we'll look for an exact match to in the plist file:
    local simulator_plist_line_to_match="<string>$simulator_name</string>"

    # Loop through all devices to figure out which is a match
    for SIMULATOR_DEVICE_DIRECTORY in ${base_simulators_path}/*; do
        # Retrieve the number of matches to our search string in the 'device.plist' file in the iterated simulator directory:
        local num_matches=$(grep "$simulator_plist_line_to_match" "$SIMULATOR_DEVICE_DIRECTORY"/device.plist | wc -l)

        # Did this directory return one match?
        if [ ${num_matches} -eq 1 ]; then
            # MATCHING_UDID=$(basename ${SIMULATOR_DEVICE_DIRECTORY})
            # Our return value is the full path of the matching simulator:
            local specific_simulator_path_found=${SIMULATOR_DEVICE_DIRECTORY}
            echo "$specific_simulator_path_found"
            return # We got what we came for; this confirms that we're going to use the simulator
        fi
    done

    echo "Simulator Not Found" # Signifies that no matching simulator could be found.
}


# Constructs the actual command line string, primarily from the parameters passed in that our caller has no doubt,
# painstakingly determined for us. We then run the actual instruments command.
#
# @param $1 The name of the app, minus any ".app" extension.
# @param $2 The directory in which the JavaScript test file can be found.
# @param $3 The name of the JavaScript test file, including its ".js" extension.
# @param $4 The path to the specific simulator to use. Just pass in the name of the app again here,
#   if you are instead, wanting to run on the device.
# @param $5 The name of the simulator as defined in the iOS Simulator mac app, such as 'iPad Air'
#   (see http://stackoverflow.com/a/24728406/535054), or the UDID of the physical device you want to run the test on.
# @param $6 The path you want the UIAutomation Instrument to place its verbose logging output.
#
_run_automation_instrument() {
    # Reanimate command line parameters into properly named variables:
    local test_app_name=$1
    local javascript_test_files_directory=${2%/} # Strip out any trailing slash
    local javascript_test_file_name=$3
    local specific_simulator_path=$4
    local simulator_name_or_device_udid=$5
    local test_results_output_path=$6

    if [ ${DEBUG_MODE_ENABLED} -eq 1 ]; then
        echo "-----------------------------------------------------------------------------------------------------------------------"
        echo "_run_automation_instrument(): Received test_app_name:" ${test_app_name}
        echo "_run_automation_instrument(): Received base_automation_test_scripts_path:" ${javascript_test_files_directory}
        echo "_run_automation_instrument(): Received test_script_name:" ${javascript_test_file_name}
        echo "_run_automation_instrument(): Received specific_simulator_path:" ${specific_simulator_path}
        echo "_run_automation_instrument(): Received simulator_name_or_device_udid:" ${simulator_name_or_device_udid}
        echo "_run_automation_instrument(): Received test_results_output_path:" ${test_results_output_path}
        echo "-----------------------------------------------------------------------------------------------------------------------"
    fi

    # Setup a variable that will either hold the path to the app (if running it on the simulator),
    # or simply the name of the app if running on an actual device:
    local fully_qualified_app_path_or_on_device_app_name=""

    # Were we passed the same value for the simulator name and the specific simulators path?
    if [ ${specific_simulator_path} == ${simulator_name_or_device_udid} ]; then
        # YES. That's code for "there is no matchin simulator". Therefore, we'll treat this as a device UDID.
        echo "_run_automation_instrument(): Interpreting '"${simulator_name_or_device_udid}"' as a device UDID to be run on."
        fully_qualified_app_path_or_on_device_app_name=${test_app_name}
    else
        # NO. We received a distinct value for the specific simulator path, which means we should proceed hunting
        # through that path's child folders for the matching app:
        fully_qualified_app_path_or_on_device_app_name=`_find_app_path_navigating_changing_guid ${specific_simulator_path} ${test_app_name}`
    fi

    # Build the full path to the javascript test file we're about to run:
    local automation_test_script_path="$javascript_test_files_directory/$javascript_test_file_name"

    # Switch directory into the output directly, b/c otherwise, occasionally,
    # Instruments will dump a .trace file in the directory from which this script is launched.
    cd ${test_results_output_path}

    if [ ${DEBUG_MODE_ENABLED} -eq 1 ]; then
        echo "-----------------------------------------------------------------------------------------------------------------------"
        echo "_run_automation_instrument(): Using INSTRUMENTS_AUTOMATION_TEMPLATE_PATH:" ${INSTRUMENTS_AUTOMATION_TEMPLATE_PATH}
        echo "_run_automation_instrument(): Using simulator_name_or_device_udid:" ${simulator_name_or_device_udid}
        echo "_run_automation_instrument(): Using fully_qualified_app_path_or_on_device_app_name:" ${fully_qualified_app_path_or_on_device_app_name}
        echo "_run_automation_instrument(): Using automation_test_script_path:" ${automation_test_script_path}
        echo "_run_automation_instrument(): Using test_results_output_path:" ${test_results_output_path}
        echo "-----------------------------------------------------------------------------------------------------------------------"
    fi

    # Build the command line string, with all of the needed parameters and switches:
    local linebreak_formatting=$'\n\t'
    local instruments_command="xcrun instruments "
    instruments_command+="-w '$simulator_name_or_device_udid' \\"${linebreak_formatting}
    instruments_command+="-t '$INSTRUMENTS_AUTOMATION_TEMPLATE_PATH' \\"${linebreak_formatting}
    instruments_command+="'$fully_qualified_app_path_or_on_device_app_name' \\"${linebreak_formatting}
    instruments_command+="-e UIASCRIPT '$automation_test_script_path' \\"${linebreak_formatting}
    instruments_command+="-e UIARESULTSPATH '$test_results_output_path'"

    # Advise callers of what command is going to be invoked for them:
    echo -e "Instruments UIAutomation command invoked:\n\n"${instruments_command}"\n"

    # Invoke the actual instruments command:
    eval ${instruments_command}
    exit $?
}



# Run this script:
main


