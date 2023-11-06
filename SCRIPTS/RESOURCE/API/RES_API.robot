*** Settings ***
Documentation                               Resource geral para as APIS

Library                                     RequestsLibrary
Library                                     Collections
Library                                     DateTime


Resource                                    ../COMMON/RES_EXCEL.robot
Library                                     ../../RESOURCE/COMMON/LIB/lib_geral.py


*** Variable ***
${URL_API}
${USUARIO}
${SENHA}
${TOKEN}
${CONTENT_TYPE}                             application/json;charset=UTF-8          # API v1 -> charset=iso-8859-1          API v2 -> charset=UTF-8
${AUTH}                                     /auth/oauth/v2/token?grant_type=client_credentials&scope=fttx
${DAT}                                      C:/IBM_VTAL/DATA/Param_Global.xlsx
${Counter_API}


*** Keywords ***
GET_API
    [Documentation]                         Função usada para mandar um GET request para a API.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``REQUEST_URL`` | A URL requisitada para a requisição. exemplo: ``/api/foo``. |
    ...                                     A resposta é um retorno JSON que contem: 
    ...                                     - ``type`` <int> Tipo da resposta do Retorno. Exemplo: S(Sucesso) e E(ERRO).
    ...                                     - ``code`` <int> Codigo da reposta do retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     - ``message`` <str> Descrição do código de retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | ${RESPONSE}=                          GET_API                                 ${API_BASEGEOGRAPHICADDRES}/addressComplements/195371
    [Arguments]                             ${REQUEST_URL}

    Create Session                          StartAPI                                ${URL_API}                              verify=true
    ${HEADERS}=                             Create Dictionary 
    ...                                     Content-Type=${CONTENT_TYPE}
    ...                                     User-Agent=RobotFramework
    ...                                     Accept=*/*
    ...                                     Authorization=Bearer ${TOKEN}
    ${RESPONSE}=                            GET On Session                          StartAPI                                ${REQUEST_URL}                          headers=${HEADERS}                          expected_status=Anything    
    Set Global Variable                     ${RESPONSE}
    
    [Return]                                ${RESPONSE}


#===================================================================================================================================================================
POST_API
    [Documentation]                         Função usada para mandar um POST request para a API.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``REQUEST_URL`` | A URL requisitada para a requisição. exemplo: ``/api/foo``. |
    ...                                     | ``REQUEST_DATA`` | A informação que será enviada pela requisição. |
    ...                                     A resposta é um retorno JSON que contem: 
    ...                                     - ``type`` <int> Tipo da resposta do Retorno. Exemplo: S(Sucesso) e E(ERRO).
    ...                                     - ``code`` <int> Codigo da reposta do retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     - ``message`` <str> Descrição do código de retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | ${RESPONSE}=                          POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck                                    "address":{"id": "${ADDRESS_ID}"}
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]
    [Arguments]                             ${REQUEST_URL}                          ${REQUEST_DATA}

    Create Session                          StartAPI                                ${URL_API}                              verify=true
    ${HEADERS}=                             Create Dictionary 
    ...                                     Content-Type=${CONTENT_TYPE}
    ...                                     User-Agent=RobotFramework
    ...                                     Accept=*/*
    ...                                     Authorization=Bearer ${TOKEN}
    ${RESPONSE}=                            POST On Session                         StartAPI                                ${REQUEST_URL}                          data={${REQUEST_DATA}}                          headers=${HEADERS}                          expected_status=Anything                     
    Set Global Variable                     ${RESPONSE}

    [Return]                                ${RESPONSE.json()}

#===================================================================================================================================================================
DELETE_API
     [Documentation]                         Função usada para mandar um DELETE request para a API, apagando a informação desejada.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``REQUEST_URL`` | A URL requisitada para a requisição. exemplo: ``/api/foo``. |
    ...                                     A resposta é um retorno JSON que contem: 
    ...                                     - ``type`` <int> Tipo da resposta do Retorno. Exemplo: S(Sucesso) e E(ERRO).
    ...                                     - ``code`` <int> Codigo da reposta do retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     - ``message`` <str> Descrição do código de retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | ${Response}=                            DELETE_API                              ${API_BASEAPPOINTMENT}/appointment/${work_OrderId}?appointmentReason=${appointmentReason}&appointmentComments=${appointmentComments}
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#DELETE%20On%20Session|RequestsLibrary >>]
    [Arguments]                             ${REQUEST_URL}
    
    Create Session                          StartAPI                                ${URL_API}                              verify=true
    ${HEADERS}=                             Create Dictionary 
    ...                                     Content-Type=${CONTENT_TYPE}
    ...                                     User-Agent=RobotFramework
    ...                                     Accept=*/*
    ...                                     Authorization=Bearer ${TOKEN}
                                
    ${RESPONSE}                             DELETE On Session                       StartAPI                                ${REQUEST_URL}                          headers=${HEADERS}                          expected_status=Anything 
    Set Global Variable                     ${RESPONSE}

    [Return]                                ${RESPONSE.json()}

#===================================================================================================================================================================
PATCH_API
    [Documentation]                         Função usada para mandar um PATCH request para a API, atualizando uma informação.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``REQUEST_URL`` | A URL requisitada para a requisição. exemplo: ``/api/foo``. |
    ...                                     | ``REQUEST_DATA`` | A informação que será enviada pela requisição. |
    ...                                     A resposta é um retorno JSON que contem: 
    ...                                     - ``type`` <int> Tipo da resposta do Retorno. Exemplo: S(Sucesso) e E(ERRO).
    ...                                     - ``code`` <int> Codigo da reposta do retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     - ``message`` <str> Descrição do código de retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | ${Response}=                            PATCH_API                               ${API_BASEAPPOINTMENT}/appointment/${WorkOrder_ID}                              "appointment":{"associatedDocument":"${associatedDocument}","associatedDocumentDate":"${associatedDocumentDate}","activityType":"${activityType}","appointmentStart":"${appointmentStart}","appointmentFinish":"${appointmentFinish}","normativeIndicatorDate":"${appointmentFinish}","promiseDate":"${appointmentStart}","appointmentComments":"${appointmentComments}","appointmentReason":""},"address":{"id": "${Address_ID}"}
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#PATCH|RequestsLibrary >>]
    [Arguments]                             ${REQUEST_URL}                          ${REQUEST_DATA}
    
    Create Session                          StartAPI                                ${URL_API}                              verify=true
    ${HEADERS}=                             Create Dictionary 
    ...                                     Content-Type=${CONTENT_TYPE}
    ...                                     User-Agent=RobotFramework
    ...                                     Accept=*/*
    ...                                     Authorization=Bearer ${TOKEN}
    ${RESPONSE}                             PATCH On Session                        StartAPI                                ${REQUEST_URL}                          data={${REQUEST_DATA}}                          headers=${HEADERS}                          expected_status=Anything                        
    Set Global Variable                     ${RESPONSE}

    [Return]                                ${RESPONSE.json()}

#===================================================================================================================================================================
Retornar Token Vtal
    [Documentation]                         Função que usa o usuario e senha para autenticar e receber o valor do Token para fazer as próximas requisições.
    ...                                     | ``HEADERS_TOKEN`` | Informações necessárias para o token, como qual ferramenta está executando. Exemplo:  User-Agent=RobotFramework. |
    ...                                     | ``USUARIO`` | Usuario cadastrado para fazer a autenticação. |
    ...                                     | ``SENHA`` | Senha cadastrado para fazer a autenticação. |
    ...                                     | ``validade_token`` | Variavel com o tempo que expira a validade do token, salva na planilha. |
    ...                                     A resposta é um retorno XML que contem: 
    ...                                     - ``access_token`` <str> Cadeia de caracteres que serve de autenticação para requisições.
    ...                                     - ``token_type`` <str> Descrição do tipo de token, pode ser uma cadeia de str ou de int.
    ...                                     - ``expires_in`` <int> Valor em segundos que esse token será valido.
    ...                                     - ``scope`` <str> Escopo do token.
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Retornar Token Vtal
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]


    IF         "${Credencial}" == "Whitelabel"
        Log To Console                      \nAtenção --> Credenciais Whitelabel foram utilizadas para o cenário.
        ${Authorization}=   Set Variable    Basic ZDhhODhmZGEtZGI1Ni00MTQzLWFjM2YtZTY3OTZhYTMwMTg2OjgwMmQyYWE5LTg0MjItNGEyMi1hMTQ0LTNhZGZjZjA2MWY2Mw==              
    ELSE IF    "${Credencial}" == "FTTP"
        Log To Console                      \nAtenção --> Credenciais FTTP foram utilizadas para o cenário.
        ${Authorization}=   Set Variable    Basic MzNkNTc3Y2QtYzZmMS00YzMxLTllYzgtMjRiY2IyZWYyMmI3OjQyNWZkYzUyLTIzMmMtNDQ2YS1iOTViLWQyNmFkZGZmYjBkYw==
    ELSE IF    "${Credencial}" == "Bitstream"
        Log To Console                      \nAtenção --> Credenciais Bitstream foram utilizadas para o cenário.
        ${Authorization}=   Set Variable    Basic NDQ0MzdlMjAtMmFjNi00YzY3LTk2NzMtYTMyMDI2N2ZjNmE3OjE1M2ZkYmU4LTcxMzUtNDJiNC05MDQ5LTI4MDM2NmI4MDU2YQ==
    ELSE IF    "${Credencial}" == "Voip"
        Log To Console                      \nAtenção --> Credenciais Voip foram utilizadas para o cenário.
        ${Authorization}=   Set Variable    Basic Yzg2MzhhNTUtYTdmNC00OTBlLWIyNGItNWZhNjQxMDUwZDQyOmNjZjUyYzc3LTliN2UtNGM2NC04M2NkLTIwZmY3YWQzZjFkZQ==
    END


    ${HeaderToken}=                         Create Dictionary
    ...                                     Content-Type=application/x-www-form-urlencoded
    ...                                     User-Agent=RobotFramework
    ...                                     Accept=*/*
    ...                                     Authorization=${Authorization}
    
    ${UrlApi}=                              Ler Variavel Param Global               $.Urls.TOKEN                            
    ${Usuario}=                             Ler Variavel Param Global               $.Tokens.${Credencial}.Usuario             
    ${Senha}=                               Ler Variavel Param Global               $.Tokens.${Credencial}.Senha 

    Create Session                          StartAPI                                ${UrlApi}                               verify=true
    ${Response}                             POST On Session                         StartAPI                                ${AUTH}                                 data={"username":"${Usuario}","password":"${Senha}"}   headers=${HeaderToken}
    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Token Vtal

    ${Token}=                               Get From Dictionary                     ${Response.json()}                      access_token
    Escrever Variavel Param Global          $.Tokens.${Credencial}.Token            ${Token}
    Set Global Variable                     ${Token}
      
#===================================================================================================================================================================
Valida Retorno da API
    [Documentation]                         Função usada para mandar validar o retorno da API, caso um retorno 500 seja dado muitas vezes ou  um retorno diferente do esperado ele cria um documento de defect.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``STATUS_RECEBIDO`` | Recebe o status de Retorno da API. exemplo: ``404(Not Found)``. |
    ...                                     | ``STATUS_ESPERADO`` | Recebe o status Esperado da API. exemplo: ``200(Ok)``. |
    ...                                     | ``FUNCAO_API`` | Recebe o nome da função para que ela execute novamente caso seja diferente o resultado: exemplo: ``Retornar Address Id``. |
    ...                                     A resposta é um retorno JSON que contem: 
    ...                                     - ``type`` <int> Tipo da resposta do Retorno. Exemplo: S(Sucesso) e E(ERRO).
    ...                                     - ``code`` <int> Codigo da reposta do retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     - ``message`` <str> Descrição do código de retorno. Exemplo: 200(Ok) 404(Not Found).
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Address Id
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#PATCH|RequestsLibrary >>]
    [Arguments]                             ${status_recebido}                      ${status_esperado}                      ${Funcao_API}

    
    IF    '${status_recebido}' == '500'
        

        #Contador para validar até no máximo 3 vezes 
        ${Counter_API}=                     Evaluate                                ${Counter_API} + 1
        Set Global Variable                 ${Counter_API}
        

        Log To Console                      \nErro ${status_recebido} recebido, tentando novamente!

        Sleep                               1s

        #Se acontecer 3 vezes ele salva o arquivo e dá um erro
        IF  "${Counter_API}" == "3"
            Fatal Error                     \nApós 3 execuções a API continua retornando erro ${status_esperado}
        END

        #Executa a Função novamente
        Run Keyword                         ${Funcao_API} 
        
    ELSE IF    '${status_recebido}' != '${status_esperado}'
        Fatal Error                         \n Retorno da API diferente do esperado ${status_recebido} != ${status_esperado}
    END


#===================================================================================================================================================================
Configuracao Remota 
    [Arguments]                             ${TYPE}                                 ${PARAMETERS}=false
    
    
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global

    IF    "${PARAMETERS}" != "false"       
        @{data}=                            Split String                            ${PARAMETERS}                           ,
        ${param}=                           Create Dictionary                        
        Set Global Variable                 ${param}
        ${length}=                          Get Length                              ${data}

        FOR    ${x}     IN RANGE    ${length}
            ${aux}=                         Ler Variavel na Planilha                ${data[${x}]}                                    Global
            Set To Dictionary               ${param}                                ${data[${x}]}=${aux}
        END                           

        ${param}=                           Convert Json To String                  ${param}                   
        ${Response}=                        POST_API                                ${API_BASECONFIGURATION}/configuration                                          "configuration": {"action": {"type": "${TYPE}","parameters": ${param}},"customer": {"subscriberId": "${subscriberId}"}}
        Set Global Variable                 ${Response}
    ELSE
        ${Response}=                        POST_API                                ${API_BASECONFIGURATION}/configuration                                          "configuration": {"action": {"type": "${TYPE}"},"customer": {"subscriberId": "${subscriberId}"}}
        Set Global Variable                 ${Response}
    END
    
    ${configId}=                            Get Value From Json                     ${Response}                             $.configuration.id

    Escrever Variavel na Planilha           ${configId[0]}                          configurationId                         Global

    Log to console                          Configuração remota realizada.

#===================================================================================================================================================================
Realizar PreDiagnostico ou Diagnostico
    [Arguments]                             ${preDiagnostic_OU_diagnostic}
    
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 

    ${Response}=                            POST_API                                ${API_BASESERVICETEST}/serviceTest      "serviceTest": {"type": "${preDiagnostic_OU_diagnostic}","customer": {"subscriberId": "${subscriberId}"}}
    
    ${returnedID}=                          Get Value From Json                     ${Response}                             $.serviceTest.id   
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code 

    IF  "${returnedCode[0]}" != "200"
        Fatal Error    Código retornado não é igual a 200.
    END
    
    IF  "${preDiagnostic_OU_diagnostic}" == "preDiagnostic"
        Escrever Variavel na Planilha       ${returnedID[0]}                        preDiagId                               Global
    ELSE
        Escrever Variavel na Planilha       ${returnedID[0]}                        diagId                                  Global
    END

                        
#===================================================================================================================================================================
Realizar troca SSID      
    [Documentation]                         Realizar troca SSID   
    [Tags]                                  RealizarTrocaSSID   

    Retornar Token Vtal

    ${type}=                                Set Variable                            HGW_WIFI_CONFIGURATION
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 
    ${frequencyBand}=                       Ler Variavel na Planilha                frequencyBand                           Global
    ${wifiIndex}=                           Ler Variavel na Planilha                wifiIndex                               Global
    ${adminStatus}=                         Set Variable                            1

    ${Response}=                            POST_API                                ${API_BASECONFIGURATION}/configuration                                          "configuration": {"action": {"type": "${type}","parameters": {"frequencyBand": "${frequencyBand}","wifiIndex": ${wifiIndex},"adminStatus": ${adminStatus}}},"customer": {"subscriberId": "${subscriberId}"}}
    
    ${habilitacaoID}=                       Get Value From Json                     ${Response}                             $.configuration.id
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code 

    IF  "${returnedCode[0]}" != "200"
        Fatal Error    Código retornado não é igual a 200.
    ELSE 
        Escrever Variavel na Planilha       ${habilitacaoID[0]}                     Habilitacao_Id                          Global
    END
#===================================================================================================================================================================
