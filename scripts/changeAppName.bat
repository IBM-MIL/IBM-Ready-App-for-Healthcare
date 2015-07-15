REM @echo off
REM
REM ################################################################################################
REM 
REM  Licensed Materials - Property of IBM
REM  © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
REM  
REM ################################################################################################
REM 

REM ################################################################################################
REM ################################################################################################
REM                      Setting up our local variables used by the script.
REM ################################################################################################
REM ################################################################################################

set SCRIPT_DIR=%~dp0
set /p ORIG_NAME=<"%SCRIPT_DIR%\appname.txt"
set NEW_NAME=%~1
set "FILES_WTIH_APP_NAME=%SCRIPT_DIR%..\Android\Physio\app\src\main\res\values\strings.xml %SCRIPT_DIR%..\docs\index.html %SCRIPT_DIR%..\html\index.html"

REM ################################################################################################
REM ################################################################################################
REM ################################################################################################
REM                                Logic Section
REM ################################################################################################
REM ################################################################################################
REM ################################################################################################

if "%NEW_NAME%" == "" ( call:fail "You need to supply a new application name. " 3||exit /b 3 )
if "%NEW_NAME%" == "\"\"" ( call:fail "You need to supply a new application name. " 3||exit /b 3  )
if "%NEW_NAME%" == "''" ( call:fail "You need to supply a new application name. " 3||exit /b 3  )
if "%NEW_NAME%" == "%ORIG_NAME%" ( call:fail "The new name should not be the same as the existing application name (%ORIG_NAME%). " 4 ||exit /b 4 )

for %%f in (%FILES_WTIH_APP_NAME%) do (
	call:updateTextInFile "%%f" "%ORIG_NAME%" "%NEW_NAME%"
)

echo.%NEW_NAME%>"%SCRIPT_DIR%\appname.txt"

exit /b 0


REM ################################################################################################
REM ################################################################################################
REM ################################################################################################
REM                                Functions Section
REM ################################################################################################
REM ################################################################################################
REM ################################################################################################

REM ################################################################################################
REM Method will take an ASCII file as input as well as a string to replace and a replacement string, and loop
REM over each line in the file and replace any instances of the replace string with the replacement string.
REM This can be used to replace any string with any other string in any text file.
REM ################################################################################################
:updateTextInFile
	set FILE=%~1
	set OS=%~2
	set NS=%~3
	set NEWFILE=%FILE%.orig
	echo.Changing ^"%OS%^" to ^"%NS%^" in file: ^"%FILE%^"

	REM ################################################################################################
	REM if our temporary file exists for some reason, lets delete it
	REM ################################################################################################
	if exist %NEWFILE% ( 
		del %NEWFILE%
	)

	REM ################################################################################################
	REM copy the original file to the new file name and delete the original file, so we can regenerate it with the
	REM new strings.
	REM ################################################################################################
	copy /y %FILE% %NEWFILE%
	del %FILE%

	REM ################################################################################################
	REM Basically just looping over each line in the file and checking to see if the line contains the string 
	REM we want to replace. If the line contains the string, we replace it and echo the new line to the file, 
	REM other wise we just echo the line to the new file and continue processing lines.
	REM ################################################################################################
	REM for /F "tokens=* delims=\n\r" %%L in (%CD%\%NEWFILE%) do (	
	for /F "tokens=* delims=\n\r" %%L in (%NEWFILE%) do (	
		set "line=%%L"

		setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
		if "!line:%OS%=!" NEQ "%%L" ( 
			echo !line:%OS%=%NS%! >> %FILE%
		) else (
			echo !line! >> %FILE%
		)
		endlocal
	)
	REM ################################################################################################
	REM Lets clean up our temporary file
	REM ################################################################################################
	del %NEWFILE%
GOTO:EOF

REM ################################################################################################
REM  Standard usage statement
REM ################################################################################################
:usage
	echo.changeAppName.bat ^<app-name^>
	echo.    ^<app-name^> The new name of the application
GOTO:EOF

REM ################################################################################################
REM Fail message
REM ################################################################################################
:fail
	set MSG=%~1
	set RETURN_CODE=%~2
	echo. 
	echo.%MSG%
	echo.
	call:usage
	echo. 
	exit /b %RETURN_CODE%
GOTO:EOF
