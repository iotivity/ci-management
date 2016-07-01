@echo off
echo "Copying dependencies..."
mklink %WORKSPACE%\extlibs\boost\boost_1_60_0.zip C:\j\e\boost_1_60_0.zip
md %WORKSPACE%\extlibs\boost\boost\
xcopy /q /e C:\j\e\boost\* %WORKSPACE%\extlibs\boost\boost
xcopy /q /e C:\j\e\tinycbor %WORKSPACE%\extlibs\tinycbor\
