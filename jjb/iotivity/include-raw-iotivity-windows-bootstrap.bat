@echo off
echo "Copying dependencies..."
xcopy /q /e C:\j\e\boost\* %WORKSPACE%\extlibs\boost\
xcopy /q /e C:\j\e\tinycbor %WORKSPACE%\extlibs\tinycbor\
