In order to easily customize the application for your business the 
changeAppName.(sh|bat) was written so that you can easily change the
name of the application from "Physio" to whatever you like. The batch file is
intended to be run on Windows operating systems while the shell script can be
run on Linux or Macintosh systems.

If you run either script with no parameters you will get a usage statement.

To run the script on Windows to update the application name run the script as
follows:

cd <source-root>/scripts
changeAppName.bat <new-app-name>

When this runs you should see output specifying which files were changed. When
the script completes you should then be able to open the Android project in
Android Studio and run the project to start it in an emulator and see the new
application name when the application starts up.

To run the script on Macintosh or Linux, do the following:

cd <source-root>/scripts
changeAppName.sh -n <new-app-name>

Again you should be able to see the files changed when the script runs. When
the script completes, you should only need to open the iOS project in Xcode
and run it against the Simulator of your choice and when the application comes
up you should be able to see that the application name should be the text
you passed into the script.

