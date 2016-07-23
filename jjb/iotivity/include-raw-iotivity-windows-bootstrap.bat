@echo off
echo "Copying dependencies..."
mklink %WORKSPACE%\extlibs\gtest\gtest-1.7.0.zip C:\j\e\gtest-1.7.0.zip
mklink %WORKSPACE%\extlibs\boost\boost_1_60_0.zip C:\j\e\boost_1_60_0.zip
md %WORKSPACE%\extlibs\boost\boost\
xcopy /q /e C:\j\e\boost\* %WORKSPACE%\extlibs\boost\boost
md %WORKSPACE%\extlibs\tinycbor\tinycbor
xcopy /q /e C:\j\e\tinycbor\tinycbor-0.2.1 %WORKSPACE%\extlibs\tinycbor\tinycbor
