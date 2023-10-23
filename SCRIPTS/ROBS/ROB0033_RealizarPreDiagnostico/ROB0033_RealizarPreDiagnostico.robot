*** Settings ***
Documentation                               Realiza o Pré Diagnóstico

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Variables ***
# ${DAT_CENARIO}                              C:/IBM_VTAL/DATA/dat_teste.xlsx



# *** Test Cases ***
# Teste diag via API
#     Realizando PreDiagnostico


*** Keywords ***
#===================================================================================================================================================================
Realizando PreDiagnostico
    [Documentation]                         Realiza Pré Diagnóstico através de requisição http utilizando método POST.
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/serviceTestManagement/v1/serviceTest``|
    [Tags]                                  RealizaPreDiagnostico

    ${type}=                                Set Variable                            preDiagnostic                        
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 

    ${Response}=                            POST_API                                ${API_BASESERVICETEST}/serviceTest      "serviceTest": {"type": "${type}","customer": {"subscriberId": "${subscriberId}"}}
    
    ${preDiagID}=                           Get Value From Json                     ${Response}                             $.serviceTest.id   
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code 

    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.

    ELSE 
        Log to console    \n Pré Diaganóstico realizado.
    END
    
    Escrever Variavel na Planilha           ${preDiagID[0]}                         preDiagId                               Global
        
#===================================================================================================================================================================