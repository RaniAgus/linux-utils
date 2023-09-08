@ECHO OFF

SET MSTEAMS_PROFILE=%~n0
ECHO - Using profile "%MSTEAMS_PROFILE%"
SET "OLD_USERPROFILE=%USERPROFILE%"
SET "USERPROFILE=%LOCALAPPDATA%\Microsoft\Teams\CustomProfiles\%MSTEAMS_PROFILE%"
REM Ensure there is a downloads folder to avoid error described at
REM https://gist.github.com/DanielSmon/cc3fa072857f0272257a5fd451768c3a
mkdir "%LOCALAPPDATA%\Microsoft\Teams\CustomProfiles\%MSTEAMS_PROFILE%\Downloads"
ECHO - Launching MS Teams with profile %MSTEAMS_PROFILE%
cd "%OLD_USERPROFILE%\AppData\Local\Microsoft\Teams"
"%OLD_USERPROFILE%\AppData\Local\Microsoft\Teams\Update.exe" --processStart "Teams.exe"
