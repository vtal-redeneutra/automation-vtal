@ECHO OFF

:: GERAR ARQUIVOS JSON PARA DOCUMENTAÇÃO
for /r "C:\IBM_VTAL\SCRIPTS\ROBS" %%a in (*.robot) do (
    call libdoc %%a JSON/%%~na.json
)

call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/API/RES_API.ROBOT                          JSON/RES_API.json

call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/COMMON/RES_EXCEL.ROBOT                     JSON/RES_EXCEL.json
call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/COMMON/RES_LOG.ROBOT                       JSON/RES_LOG.json
call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/COMMON/RES_UTIL.ROBOT                      JSON/RES_UTIL.json

call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/FSL/UTILS.ROBOT                            JSON/FSL_UTILS.json

call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/FW/UTILS.ROBOT                             JSON/FW_UTILS.json

call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/NETQ/UTILS.ROBOT                           JSON/NETQ_UTILS.json

call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/OPM/UTILS.ROBOT                            JSON/OPM_UTILS.json

call libdoc C:/IBM_VTAL/SCRIPTS/RESOURCE/SOM/UTILS.ROBOT                            JSON/SOM_UTILS.json






::###### Parametros de configuracao ##########################################################
set PATH_ROB=C:/IBM_VTAL/DOCUMENTATION

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%" & set "MS=%dt:~15,3%"
set "dt=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"

set PATH_RESULTS=%PATH_ROB%/RESULTS/results_%dt%
::############################################################################################

call py -m robot -d ./RESULTS/results_%dt%  -v PATH_RESULTS:%PATH_RESULTS%          ./Gerar_Documentacao.robot

EXIT