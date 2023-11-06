*** Settings ***
Documentation                               Realiza o Diagnóstico

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot



# *** Variables ***
# ${DAT_CENARIO}                              C:/IBM_VTAL/DATA/dat_teste.xlsx



# *** Test Cases ***
# Teste diag via API
#     Realizando Diagnostico


*** Keywords ***
#===================================================================================================================================================================
Realizando Diagnostico
    [Documentation]                         Realiza Diagnóstico através de requisição http utilizando método POST.
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/serviceTestManagement/v1/serviceTest``|
    [Tags]                                  RealizaDiagnostico

    ${type}=                                Set Variable                            diagnostic
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 

    ${Response}=                            POST_API                                ${API_BASESERVICETEST}/serviceTest      "serviceTest": {"type": "${type}","customer": {"subscriberId": "${subscriberId}"}}
    
    ${diagID}=                              Get Value From Json                     ${Response}                             $.serviceTest.id   
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code 

    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.

    ELSE 
        Log to console    \n Diaganóstico realizado.
    END
    
    Escrever Variavel na Planilha           ${diagID[0]}                            diagId                                  Global
        
#===================================================================================================================================================================