TASM cmp.asm
TLINK cmp
echo Testing...
echo.>test.res
echo === test1 ===>>test.res
%1 aa < V1TEST1.IN >>test.res
echo === test2 ===>>test.res
%1 aa < V1TEST2.IN >>test.res
echo === test3 ===>>test.res
%1 um < V1TEST3.IN >>test.res
echo === test4 ===>>test.res
%1 seal < V1TEST4.IN >>test.res

fc /b test.res v1test.ok
