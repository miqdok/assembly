@ECHO OFF
cmp %2 %3 cmp.res
if errorlevel 1 goto FAILED
echo Tests PASSED
goto PASSED
:FAILED
echo Test FAILED, see cmp.res diff
:PASSED