*** Settings ***

Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     RequestsLibrary
Library                                     JSONLibrary

Resource                                    ../../RESOURCE/NETQ/VARIABLES.robot   
Resource                                    ../COMMON/RES_UTIL.robot




*** Keywords ***


#===================================================================================================================================================================
Conectar API NETQ
    [Documentation]                         Keyword responsável por realizar a conecção na API do NETQ, realizando o login via proxy.
    ...                                     \nLê os campos ``Usuario_NETQ`` e ``Senha_NETQ`` para realização do login.

    ${HEADERS}=                             Create Dictionary
    ...                                     Authorization=Basic bW9ja29pOkczJHQ0b20wY2swaQ==
    ...                                     Cache-Control=no-cache
    ...                                     Content-type=application/json
    ...                                     Pragma=no-cache
    ...                                     Proxy-Connection=keep-alive
    ...                                     User-Agent=RobotFramework
    ...                                     Referer=http://mocknetq.local.srv.br/


    ${Usuario_NETQ}=                        Ler Variavel Param Global               $.Logins.NETQ.Usuario                              
    ${Senha_NETQ}=                          Ler Variavel Param Global               $.Logins.NETQ.Senha                                


    ${proxies} =                            Evaluate                                {"http": "http://${Usuario_NETQ}:${Senha_NETQ}@10.21.7.10:82"}
    Create Session                          APINETQ                                 http://mocknetq.local.srv.br/api/       headers=${HEADERS}                      proxies=${proxies}

#===================================================================================================================================================================
Alterar Campo no NETQ
    [Documentation]                         Keyword responsável pela realização de alteração dos valores no NETQ.
    ...                                     \nLê os campos ``Customer_Name`` e ``subscriberId`` da planilha.
    ...                                     \nCaso ``CAMPO`` Campo a ser alterado no NETQ.
    ...                                     \nCaso ``VALOR`` O valor que será alterado no ``CAMPO``.
    ...                                     \nCaso ``RESET_JSON`` Será enviado ``VALOR = OK`` para todos os campos.
    ...                                     \nCaso ``CAMPO = VAZIO`` e ``VALOR = VAZIO`` Valores padrões dos campos. Nenhum campo é alterado.
    
    [Arguments]                             ${CAMPO}=VAZIO
    ...                                     ${VALOR}=VAZIO
    ...                                     ${RESET_JSON}=NAO
    #ATENÇÃO!!!  O RESET NETQ É USADO PARA ENVIAR TUDO OK ANTES DE FAZER A ALTERAÇÃO DO CAMPO, UTILIZE SOMENTE NA PRIMEIRA CHAMADA!!!
    
    # EXEMPLOS DE CHAMADA DA KEYWORD:

    # REALIZAR ALTERACAO DE CAMPO COM TUDO OK
    # Alterar Campo no NETQ                 CAMPO=VULTOATIVO                        VALOR=INVENTORY_18                      RESET_JSON=SIM
    
    # REALIZAR ALTERACAO DE CAMPO SEM TUDO OK
    # Alterar Campo no NETQ                 CAMPO=VULTOATIVO                        VALOR=INVENTORY_18                     
    
    #ENVIAR TUDO OK:
    # Alterar Campo no NETQ                 RESET_JSON=SIM


    Conectar API NETQ
    ${GPON_LINEID}=                         Buscar GPON LINEID


    IF    "${RESET_JSON}" == "SIM"
        Resetar JSON NETQ                   ${GPON_LINEID}
    END

    #SE O CAMPO E O VALOR FOR DIFERENTE DE VAZIO, REALIZA A ALTERAÇÃO DO CAMPO
    IF  "${CAMPO}" != "VAZIO" and "${VALOR}" != "VAZIO"
        ${JSON}=                            GET On Session                          APINETQ                                 /operations/${GPON_LINEID}              expected_status=Anything
        Valida Retorno da API               ${JSON.status_code}                     200                                     Atualizar JSON NETQ

        Log                                 ${JSON.json()}
        ${JSON}=                            Update Value To Json                    ${JSON.json()}                          $.operations[?(@.name=="${CAMPO}")].value                                       ${VALOR}
        Log                                 ${JSON}

        ${RESPONSE}=                        POST On Session                         APINETQ                                 /operations/${GPON_LINEID}              json=${JSON}                            expected_status=Anything
        Valida Retorno da API               ${RESPONSE.status_code}                 200                                     Alterar Campo no NETQ
    END

    Validar Campo Alterado NETQ             ${GPON_LINEID}                          ${CAMPO}                                ${VALOR}    

#==========================================================================================================================================================================================================
Buscar GPON LINEID

    ${Customer_Name}=                       Ler Variavel na Planilha                customerName                            Global
    ${SubscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global

    IF  "${Credencial}" == "Bitstream"
        ${Customer_Name}=                   Set Variable                            TIM
    END  

    ${Concat_Name_Id}=                      Set Variable                            ${Customer_Name}_${SubscriberId}

    ${RESPONSE}=                            GET On Session                          APINETQ                                 /netwin/trg/${Concat_Name_Id}           expected_status=Anything
    Valida Retorno da API                   ${RESPONSE.status_code}                 200                                     Alterar Campo no NETQ

    ${GPON}=                                Get Value From Json                     ${RESPONSE.json()}                      $.gpon
    ${GPON_STRING}                          Convert Json to String                  ${GPON[0]}
    ${GPON_STRING}                          Replace String                          ${GPON_STRING}                          "                                       ${EMPTY}

    ${LINEID}=                              Get Value From Json                     ${RESPONSE.json()}                      $.lineId
    ${LINEID_STRING}                        Convert Json to String                  ${LINEID[0]}
    ${LINEID_STRING}                        Replace String                          ${LINEID_STRING}                        "                                       ${EMPTY}
    [Return]                                ${GPON_STRING}/${LINEID_STRING}

#==========================================================================================================================================================================================================
Resetar JSON NETQ
    [Arguments]                             ${GPON_LINEID}
    ${JSON}=                                GET On Session                          APINETQ                                 /operations/${GPON_LINEID}              expected_status=Anything
    Valida Retorno da API                   ${JSON.status_code}                     200                                     Atualizar JSON NETQ
    ${JSON}=                                Delete Object From Json                 ${JSON.json()}                          $.operations[*].hint  
    ${JSON}=                                Update Value To Json                    ${JSON}                                 $.operations[*].value                   OK
    Log                                     ${JSON}
    ${RESPONSE}=                            POST On Session                         APINETQ                                 /operations/${GPON_LINEID}              json=${JSON}                            expected_status=Anything
    Valida Retorno da API                   ${RESPONSE.status_code}                 200                                     Alterar Campo no NETQ
    
#==========================================================================================================================================================================================================
Validar Campo Alterado NETQ
    [Arguments]                             ${GPON_LINEID}                          
    ...                                     ${CAMPO}=VAZIO
    ...                                     ${VALOR}=VAZIO

    #BUSCA O JSON NO NETQ
    ${JSON}=                                GET On Session                          APINETQ                                 /operations/${GPON_LINEID}              expected_status=Anything
    Valida Retorno da API                   ${JSON.status_code}                     200                                     Atualizar JSON NETQ
    

    #QUANDO O CAMPO E O VALOR NAO FOR TUDO OK VALIDA SOMENTE O QUE FOI ALTERADO!
    IF  "${CAMPO}" != "VAZIO" and "${VALOR}" != "VAZIO"
        ${VALOR_JSON}=                      Get Value From Json                     ${JSON.json()}                          $.operations[?(@.name=="${CAMPO}")].value 
        ${VALOR_STRING}                     Convert Json to String                  ${VALOR_JSON[0]}
        ${VALOR_STRING}                     Replace String                          ${VALOR_STRING}                         "                                       ${EMPTY}
        Log                                 ${JSON.json()}
        IF    "${VALOR_STRING}" != "${VALOR}"
            FATAL ERROR                     \nCampo ${CAMPO} não foi alterado no NETQ!
        END
    
    ELSE
    #QUANDO O CAMPO E O VALOR FOR TUDO OK VALIDA TODOS OS CAMPOS!
        @{VALOR_JSON}=                      Get Value From Json                     ${JSON.json()}                          $..value
        LOG                                 ${VALOR_JSON}
        FOR    ${X}     IN      @{VALOR_JSON}
            IF    "${X}" != "OK"
                FATAL ERROR                 \nAlgum campo apresentou mensagem diferente de OK!
            END
        END
    END
    
#==========================================================================================================================================================================================================
    