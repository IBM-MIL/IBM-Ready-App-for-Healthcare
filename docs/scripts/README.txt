Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.s

###############################################################
###############################################################
Creating Documentation Overview
###############################################################
###############################################################
The createDocumentation script generates documentation for:
	- Java files using Doxygen
	- JavaScript files using JSDoc
	- Swift files using Jazzy

The script then creates a zip file of the docs folder.

###############################################################
###############################################################
Command line options
###############################################################
###############################################################
If just ./createDocumentation with no arguments is run, docs will be generated for Java, JavaScript, and Swift.
Available command line arguments for customization:
	-j | --java : Will generate Java docs"
	-v | --javascript : Will generate JavaScript docs"
	-s | --swift : Will generate Swift docs"
	-h | —help : Will print out this message about the command line options

Example: ./createDocumentation -j --swift will generate ONLY Java and Swift documents"

###############################################################
###############################################################
Installation
###############################################################
###############################################################
To setup your machine to run this script, Jazzy, JSDoc, and Doxygen must be installed.

Jazzy (https://github.com/realm/jazzy):
  Run ‘[sudo] gem install jazzy’

JSDoc: 
  Run ‘sudo npm install -g jsdoc’

Doxygen (http://www.stack.nl/~dimitri/doxygen/download.html):
  - Go to the above website, and Download the Doxygen-1.8.8.dmg file and install on your machine
  - Then run the following command from the command line to allow use of the command line version of Doxygen:
   sudo ln -s /Applications/Doxygen.app/Contents/Resources/doxygen /usr/local/bin/
  

###############################################################
###############################################################
Folder Structure
###############################################################
###############################################################
The folder structure for the documentation should be as follows:

-docs/
  |
  index.html
      - The intro page to the Documentation Website.
  css/
      - *.css files here
  html/
      - Manually created html files (tutorials, FAQs, etc)
  img/
      - any images used: logos, diagrams, etc
  script/
      - holds the createDocumentation.sh file, and any config files
  gen/ (where the doc generators output the results)
      |
      Java/
      JavaScript/
      Swift/

###############################################################
###############################################################
Customizing the documentation script
###############################################################
###############################################################
To change the input directories for JavaScript and Swift, open the createDocumentation script file and change the variables at the top of the page.

JAVASCRIPT_RELATIVE_BASE_PATH
  - This is the relative path from the createDocumentation.sh script to the encompassing JavaScript folder.

javaScriptArr
  - Array of paths to any folders in which there are JavaScript files to document. Add more paths to this array as needed

SWIFT_RELATIVE_PATH_PROJECT
  - Relative path from the createDocumentation.sh script to the folder which contains the Xcode project file.  Jazzy builds that project to generate the Swift documentation

SWIFT_RELATIVE_PATH_DOCS
  - Relative path from the Xcode project file back to the ‘docs’ folder so that Jazzy knows where to output the documentation

To change the input directories for Java, open the doxygen_config file and change the INPUT parameter to be the relative path to the Java source files in the project.

