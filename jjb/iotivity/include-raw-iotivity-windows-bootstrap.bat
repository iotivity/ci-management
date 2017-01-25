@echo off
echo "Copying dependencies..."
echo | set /p="gtest..."
mklink %WORKSPACE%\extlibs\gtest\gtest-1.7.0.zip C:\j\e\gtest-1.7.0.zip > NUL 2>&1
echo "done"
echo | set /p="gtest-release..."
mklink %WORKSPACE%\extlibs\gtest\release-1.7.0.zip C:\j\e\googletest-release-1.7.0.zip > NUL 2>&1
echo "done"
echo | set /p="boost..."
mklink %WORKSPACE%\extlibs\boost\boost_1_60_0.zip C:\j\e\boost_1_60_0.zip > NUL 2>&1
md %WORKSPACE%\extlibs\boost\boost\
xcopy /q /e C:\j\e\boost\* %WORKSPACE%\extlibs\boost\boost
echo "done"
echo | set /p="tinycbor..."
md %WORKSPACE%\extlibs\tinycbor\tinycbor
xcopy /q /e C:\j\e\tinycbor\tinycbor-0.3.2 %WORKSPACE%\extlibs\tinycbor\tinycbor
echo "done"
echo | set /p="mbedtls..."
md %WORKSPACE%\extlibs\mbedtls\mbedtls
xcopy /q /e /h C:\j\e\mbedtls\mbedtls %WORKSPACE%\extlibs\mbedtls\mbedtls
echo "done"
echo | set /p="libcoap..."
md %WORKSPACE%\extlibs\libcoap\libcoap
xcopy /q /e /h C:\j\e\libcoap\libcoap %WORKSPACE%\extlibs\libcoap\libcoap
echo "done"
echo "Dependencies copied."
