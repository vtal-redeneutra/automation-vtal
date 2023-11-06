@ECHO OFF

::###### Parametros de configuracao ##########################################################
set PATH_ROB=C:/IBM_VTAL/SCRIPTS/TRG/FTTH/187_AbrirTroubleTicketSemDiagnosticoBitstream


for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%" & set "MS=%dt:~15,3%"
set "dt=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"

set PATH_RESULTS=%PATH_ROB%/RESULTS/results_%dt%
::############################################################################################

call py -m robot -d ./RESULTS/results_%dt%  -v PATH_RESULTS:%PATH_RESULTS%          ./187_AbrirTroubleTicketSemDiagnosticoBitstream.robot
cd ./RESULTS/results_%dt% & robotmetrics
TIMEOUT 20
EXIT