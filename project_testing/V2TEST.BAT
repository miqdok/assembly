@ECHO OFF
TASM cmp.asm
TLINK cmp
echo Testing...
echo.>test.res
echo === test1 ===>>test.res
%1 aa < V2TEST1.IN >>test.res

fc /b test.res v2test.ok
