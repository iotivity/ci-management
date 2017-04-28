for %%x in (
  unittests.exe unittest.exe catests.exe provisiontests.exe
  cbortests.exe stacktests.exe randomtests.exe
  malloctests.exe stringtests.exe timetests.exe
  c_common_windows_tests.exe ipcatests.exe
) do (
  tasklist /FI "IMAGENAME eq %%x" 2>NUL | find /I /N "%%x">NUL
  if "%ERRORLEVEL%"=="0" taskkill /F /IM "%%x"
)
