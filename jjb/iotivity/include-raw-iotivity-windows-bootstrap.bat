@echo off
echo "Copying dependencies..."
echo | set /p="boost..."
mklink %WORKSPACE%\extlibs\boost\boost_1_60_0.zip C:\j\e\boost_1_60_0.zip > NUL 2>&1
md %WORKSPACE%\extlibs\boost\boost\
xcopy /q /e C:\j\e\boost\* %WORKSPACE%\extlibs\boost\boost
echo "done"
echo | set /p="sqlite3..."
mklink %WORKSPACE%\extlibs\sqlite3\sqlite-amalgamation-3081101.zip C:\j\e\sqlite-amalgamation-3081101.zip > NUL 2>&1
xcopy /q /e C:\j\e\sqlite3\* %WORKSPACE%\extlibs\sqlite3\
echo "done"
echo | set /p="tinycbor..."
md %WORKSPACE%\extlibs\tinycbor\tinycbor
xcopy /q /e C:\j\e\tinycbor\tinycbor-0.4 %WORKSPACE%\extlibs\tinycbor\tinycbor
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
