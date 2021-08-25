@echo off
chcp 65001 > NUL
color 02
If NOT exist "%CD%\node.exe" (
	echo Installing Node.js...
	curl -o "%CD%\node.exe" https://nodejs.org/dist/latest/win-x64/node.exe
	echo Node.js is installed!
) else (
	echo Node.js is already installed!
)
set "psCmd="add-type -As System.Web.Extensions;$JSON = new-object Web.Script.Serialization.JavaScriptSerializer;$JSON.DeserializeObject((Invoke-WebRequest https://registry.npmjs.org/npm/latest).content).dist.tarball""
for /f %%I in ('powershell -noprofile %psCmd%') do set "npmdownloadurl=%%I"
set npmnotexist=false
If NOT exist "%CD%\node_modules" set npmnotexist=true
If NOT exist "%CD%\node_modules\npm" set npmnotexist=true
If NOT exist "%CD%\npm.cmd" set npmnotexist=true
If NOT exist "%CD%\npm" set npmnotexist=true
If "%npmnotexist%" == "true" (
	echo Installing npm...
	If NOT exist "%CD%\node_modules" mkdir "%CD%\node_modules"
	If NOT exist "%CD%\node_modules\npm" (
		curl -o "%CD%\npm.tgz" "%npmdownloadurl%"
		tar -xzf "%CD%\npm.tgz" -C "%CD%\node_modules"
		ren "%CD%\node_modules\package" "npm"
	)
	If NOT exist "%CD%\npm.cmd" copy "%CD%\node_modules\npm\bin\npm.cmd" "%CD%"
	If NOT exist "%CD%\npm" copy "%CD%\node_modules\npm\bin\npm" "%CD%"
	If exist "%CD%\npm.tgz" del /f "%CD%\npm.tgz"
	echo npm is installed!
) else (
	echo npm is already installed!
)
echo Node.js and npm are installed!
