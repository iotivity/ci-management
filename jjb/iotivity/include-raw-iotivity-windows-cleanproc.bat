for %%x in (
  c_common_windows_tests
  catests
  cbortests
  ipcatests
  malloctests
  provisiontests
  randomtests
  stacktests
  stringtests
  timetests
  unittest
  unittests
) do (
  tasklist /FI "IMAGENAME eq %%x.exe" 2>NUL | find /I /N "%%x.exe">NUL
  if "%ERRORLEVEL%"=="0" taskkill /F /IM "%%x.exe"
)
