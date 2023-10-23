*** Settings ***
Documentation                               Scripts Abertura de Chamado Tecnico.

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Keywords ***
Abertura do chamado tecnico
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST com complemento e com o objetivo retornar 
    ...                                     o troubleTicket_id e SOM_Order_Id.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. |``https://apitrg.vtal.com.br/api/troubleTicket/v1/troubleTicket``.|

    Retornar Token Vtal
    Abrir Chamado Tecnico

Abertura do chamado tecnico sem complemento
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST sem complemento e com o objetivo retornar 
    ...                                     o troubleTicket_id.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. |``https://apitrg.vtal.com.br/api/troubleTicket/v1/troubleTicket``.|

    Retornar Token Vtal
    Abrir Chamado Tecnico sem complemento

#===================================================================================================================================================================
Abrir Chamado Tecnico
    [Arguments]                             ${problem_description}=false

    [Documentation]                         Realização de abertura de troubleTicket
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST com complemento e com o objetivo retornar 
    ...                                     o troubleTicket_id e SOM_Order_Id, armazenar e escrever dados na DAT relativa ao cenário.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. |``https://apitrg.vtal.com.br/api/troubleTicket/v1/troubleTicket``.|

    [Tags]                                  AberturaChamadoTecnico
    
    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${associatedDocument}=                  Get Current Date                        result_format=%m%d%H%M%S
    ${associatedDocument}=                  Set Variable                            ibm${associatedDocument}   
        
    Escrever Variavel na Planilha           ${associatedDocument}                   associatedDocument                      Global

    ${infra_type}=                          Ler Variavel na Planilha                infraType                               Global
    ${type}=                                Ler Variavel na Planilha                Type                                    Global
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 
    ${adress_id}=                           Ler Variavel na Planilha                addressId                               Global
    ${invetory_id}=                         Ler Variavel na Planilha                inventoryId                             Global
    ${TypeComplement}=                      Ler Variavel na Planilha                typeComplement1                         Global
    ${value_logradouro}=                    Ler Variavel na Planilha                value1                                  Global
    ${customer_name}=                       Ler Variavel na Planilha                customerName                            Global
    ${phone_number}=                        Ler Variavel na Planilha                phoneNumber                             Global

    IF    "${problem_description}" == "false"
        ${Response}=                        POST_API                                ${API_BASETROUBLETICKET}                "troubleTicket": {"associatedDocument": "${associatedDocument}","infraType": "${infra_type}","type": "${type}","customer": {"name": "${customer_name}","subscriberId": "${subscriberId}","phoneNumber": {"phoneNumbers": ["${phone_number}"]}},"addresses": {"address": [{"id": "${adress_id}","inventoryId": "${invetory_id}","reference": "Prox a padaria","complement": {"complements": [{"type": "${TypeComplement}","description": "","value": "${value_logradouro}"}]}}]},"problem": {"description": "","origin": "","protocol": ""}}
    ELSE
        ${Response}=                        POST_API                                ${API_BASETROUBLETICKET}                "troubleTicket": {"associatedDocument": "${associatedDocument}","infraType": "${infra_type}","type": "${type}","customer": {"name": "${customer_name}","subscriberId": "${subscriberId}","phoneNumber": {"phoneNumbers": ["${phone_number}"]}},"addresses": {"address": [{"id": "${adress_id}","inventoryId": "${invetory_id}","reference": "Prox a padaria","complement": {"complements": [{"type": "${TypeComplement}","description": "","value": "${value_logradouro}"}]}}]},"problem": {"description": "${problem_description}","origin": "","protocol": ""}}
    END
   
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code
    ${troubleTicket_id}                     Get Value From Json                     ${Response}                             $.troubleTicket.id
    
    Escrever Variavel na Planilha           ${troubleTicket_id[0]}                  troubleTicketId                         Global
    Escrever Variavel na Planilha           ${troubleTicket_id[0]}                  somOrderId                              Global


    IF  "${returnedCode[0]}" != "201"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 201.

    ELSE 
        Log to console    \n Abertura de chamado realizada.
    END
#===================================================================================================================================================================
Abrir Chamado Tecnico sem complemento
    [Arguments]                             ${problem_description}=false            ${problem_type}=false                   ${problem_origin}=false

    [Documentation]                         Realização de abertura de troubleTicket
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST sem complemento e com o objetivo retornar 
    ...                                     o troubleTicket_id, armazenar e escrever dados na DAT relativa ao cenário.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. |``https://apitrg.vtal.com.br/api/troubleTicket/v1/troubleTicket``.|

    [Tags]                                  AberturaChamadoTecnico


    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${associatedDocument}=                  Get Current Date                        result_format=%m%d%H%M%S
    ${associatedDocument}=                  Set Variable                            ibm${associatedDocument}   
        
    Escrever Variavel na Planilha           ${associatedDocument}                   associatedDocument                      Global

    ${infra_type}=                          Ler Variavel na Planilha                infraType                               Global
    ${type}=                                Ler Variavel na Planilha                Type                                    Global
    ${costumer_name}                        Ler Variavel na Planilha                customerName                            Global
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 
    ${adress_id}=                           Ler Variavel na Planilha                addressId                               Global
    ${invetory_id}=                         Ler Variavel na Planilha                inventoryId                             Global


    IF    "${problem_description}" == "false"
        ${Response}=                        POST_API                                ${API_BASETROUBLETICKET}                "troubleTicket": {"associatedDocument": "${associatedDocument}","infraType": "${infra_type}","type": "${type}","customer": {"name": "${costumer_name}","subscriberId": "${subscriberId}","phoneNumber": {"phoneNumbers": ["21999999999"]}},"addresses": {"address": [{"id": "${adress_id}","inventoryId": "${invetory_id}","reference": "Ponto de referencia","complement": {"complements": [{"type": "","description": "","value": ""}]}}]},"problem": {"description": "","origin": "","protocol": ""}}
    ELSE
        IF    "${problem_type}" == "false"
            ${Response}=                    POST_API                                ${API_BASETROUBLETICKET}                "troubleTicket": {"associatedDocument": "${associatedDocument}","infraType": "${infra_type}","type": "${type}","customer": {"name": "${costumer_name}","subscriberId": "${subscriberId}","phoneNumber": {"phoneNumbers": ["21999999999"]}},"addresses": {"address": [{"id": "${adress_id}","inventoryId": "${invetory_id}","reference": "Ponto de referencia"}]},"problem": {"description": "${problem_description}","origin": "${problem_origin}","protocol": ""}}
        ELSE
            ${Response}=                    POST_API                                ${API_BASETROUBLETICKET}                "troubleTicket": {"associatedDocument": "${associatedDocument}","infraType": "${infra_type}","type": "${type}","customer": {"name": "${costumer_name}","subscriberId": "${subscriberId}","phoneNumber": {"phoneNumbers": ["21999999999"]}},"addresses": {"address": [{"id": "${adress_id}","inventoryId": "${invetory_id}","reference": "Prox a padaria"}]},"problem": {"description": "${problem_description}","type": "${problem_type}"}}
        END
    END

    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code
    ${troubleTicket_id}                     Get Value From Json                     ${Response}                             $.troubleTicket.id

    Escrever Variavel na Planilha           ${troubleTicket_id[0]}                  troubleTicketId                         Global

    IF  "${returnedCode[0]}" != "201"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 201.

    ELSE 
        Log to console    \n Abertura de chamado realizada.
    END
