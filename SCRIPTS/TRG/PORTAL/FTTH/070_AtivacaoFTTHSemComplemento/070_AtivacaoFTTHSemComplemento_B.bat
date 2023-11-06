@ECHO OFF
set PATH_ROB=C:/IBM_VTAL/SCRIPTS/TRG/PORTAL/FTTH/070_AtivacaoFTTHSemComplemento
set /p loop=Quantas execucoes serao realizadas? 
set /A linha = %loop%+1
for /l %%i in (2, 1, %linha%) do (
    call :Func %%i
)
goto :eof
:Func [%1 - param]
    set dt=%DATE:~6,4%_%DATE:~3,2%_%DATE:~0,2%_%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%
    set dt=%dt: =0%
    set PATH_RESULTS=%PATH_ROB%/RESULTS/results_%dt%
    call py -m robot -d %PATH_RESULTS% -v PATH_RESULTS:%PATH_RESULTS% -v NumLinha:%%1    -i SCRIPT_B       ./070_AtivacaoFTTHSemComplemento.robot
    TIMEOUT 2
    goto :eof
:End
TIMEOUT 20
EXIT