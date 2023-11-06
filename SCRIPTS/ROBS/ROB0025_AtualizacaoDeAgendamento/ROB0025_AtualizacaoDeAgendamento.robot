*** Settings ***
Documentation                               Realiza reagendamento do pedido.
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot


  

*** Variables ***
#${DAT_CENARIO}                             C:/IBM_VTAL/DATA/DAT0019_InstalaçãoFTTHComAgendamentoEncerramentoComSucessoViaOPM.xlsx

${WorkOrder_ID}
${associatedDocument}
${associatedDocumentDate}
${activityType}
${appointmentStart}
${appointmentFinish}
${appointmentComments}
${appointmentReason}
${Address_ID}


#*** Test Cases ***
#Reagendando por API
    #Reagendamento OPM


*** Keywords ***

Reagendamento API Data Escolhida
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via PATCH com o objetivo de reagendar para Data Escolhida
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1/appointment``. |                                 

    [Tags]                                  ReagendamentoViaAPI

    Retornar Token Vtal
    Reagendar Pedido Data Escolhida

####################################################################################################################################################################
Reagendamento OPM
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via PATCH com o objetivo de reagendar para 
    ...                                     o mesmo dia utilizando o App OPM.

    [Tags]                                  ReagendamentoViaApiOPM

    Retornar Token Vtal
    Reagendar Pedido OPM

####################################################################################################################################################################
Reagendar Pedido Data Escolhida
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via PATCH com o objetivo de reagendar para ``Data Escolhida``
    ...                                     gerando a mudança no WorkOrder_ID
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1/appointment``. |                                 


    [Tags]                                  Reagenda o Pedido
    

    ${WorkOrder_ID}=                        Ler Variavel na Planilha                workOrderId                             Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    ${associatedDocumentDate}=              Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${activityType}=                        Set Variable                            4927
    ${appointmentStart}=                    Ler Variavel na Planilha                appointmentStart                        Global
    ${appointmentFinish}=                   Ler Variavel na Planilha                appointmentFinish                       Global
    ${appointmentComments}=                 Ler Variavel na Planilha                appointmentComments                     Global
    ${appointmentReason}=                   Ler Variavel na Planilha                appointmentReason                       Global
    ${Address_ID}=                          Ler Variavel na Planilha                addressId                               Global                           

    
    ${Response}=                            PATCH_API                               ${API_BASEAPPOINTMENT}/appointment/${WorkOrder_ID}                              "appointment":{"associatedDocument":"${associatedDocument}","associatedDocumentDate":"${associatedDocumentDate}","activityType":"${activityType}","appointmentStart":"${appointmentStart}","appointmentFinish":"${appointmentFinish}","normativeIndicatorDate":"${appointmentFinish}","promiseDate":"${appointmentStart}","appointmentComments":"${appointmentComments}","appointmentReason":"${appointmentReason}"},"address":{"id": "${Address_ID}"}         

####################################################################################################################################################################
Reagendar Pedido Retirada Data Escolhida 
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via PATCH com o objetivo de reagendar o pedido de retirada para ``data escolhida``
    ...                                     gerando a mudança no Work Order ID.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1/appointment``. |    


    [Tags]                                  Reagenda o Pedido Retirada
    

    ${WorkOrder_ID}=                        Ler Variavel na Planilha                workOrderId                             Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    ${associatedDocumentDate}=              Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${activityType}=                        Set Variable                            407
    ${appointmentStart}=                    Ler Variavel na Planilha                appointmentStart                        Global
    ${appointmentFinish}=                   Ler Variavel na Planilha                appointmentFinish                       Global
    ${appointmentComments}=                 Ler Variavel na Planilha                appointmentComments                     Global
    ${appointmentReason}=                   Ler Variavel na Planilha                appointmentReason                       Global
    ${Address_ID}=                          Ler Variavel na Planilha                addressId                               Global                           

    
    ${Response}=                            PATCH_API                               ${API_BASEAPPOINTMENT}/appointment/${WorkOrder_ID}                              "appointment":{"associatedDocument":"${associatedDocument}","associatedDocumentDate":"${associatedDocumentDate}","activityType":"${activityType}","appointmentStart":"${appointmentStart}","appointmentFinish":"${appointmentFinish}","normativeIndicatorDate":"${appointmentFinish}","promiseDate":"${appointmentStart}","appointmentComments":"${appointmentComments}","appointmentReason":"${appointmentReason}"},"address":{"id": "${Address_ID}"}         

####################################################################################################################################################################
Reagendar Pedido OPM e FSL
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via PATCH com o objetivo de reagendar o pedido para 
    ...                                     ``o mesmo dia e para o primeiro horário disponível`` utilizando o OPM ou FSL gerando novo Work Order ID.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1/appointment``. |         

    [Arguments]                             ${activityType}=4927
    [Tags]                                  Reagenda o Pedido OPM


    ${dia_atual_API}=                       Get Current Date                        exclude_millis=yes                      result_format=%Y-%m-%d
    ${WorkOrder_ID}=                        Ler Variavel na Planilha                workOrderId                             Global                       
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global               
    ${associatedDocumentDate}=              Ler Variavel na Planilha                associatedDocumentDate                  Global    
    #Atribui para o dia atual e para o primeiro horário disponivel que é: das 08 as 12 hrs, permitindo fechar a qualquer momento
    ${appointmentStart}=                    Set Variable                            ${dia_atual_API}T08:00:00
    ${appointmentFinish}=                   Set Variable                            ${dia_atual_API}T12:00:00
    ${appointmentComments}=                 Set Variable                            Reagendamento VTAL   
    ${appointmentReason}=                   Set Variable                            Reagendamento VTAL
    ${Address_ID}=                          Ler Variavel na Planilha                addressId                               Global

    ${Response}=                            PATCH_API                               ${API_BASEAPPOINTMENT}/appointment/${WorkOrder_ID}                              "appointment":{"associatedDocument":"${associatedDocument}","associatedDocumentDate":"${associatedDocumentDate}","activityType":"${activityType}","appointmentStart":"${appointmentStart}","appointmentFinish":"${appointmentFinish}","normativeIndicatorDate":"${appointmentFinish}","promiseDate":"${appointmentStart}","appointmentComments":"${appointmentComments}","appointmentReason":"${appointmentReason}"},"address":{"id": "${Address_ID}"}

    ${code}=                                Get Value From Json    ${Response}      $.control.code
    ${message}=                             Get Value From Json    ${Response}      $.control.message
    ${returnedOrderID}=                     Get Value From Json    ${Response}      $.workOrderID

    Set Global Variable                     ${code}
    Set Global Variable                     ${message}
    Set Global Variable                     ${returnedOrderID}

    Valida Retorno da API                   ${code[0]}                              200                                     Reagendar Pedido OPM e FSL

    Should Be Equal As Strings              ${code[0]}                              200
    Should Be Equal As Strings              ${message[0]}                           Ok
    Should Be Equal As Strings              ${returnedOrderID[0]}                   ${WorkOrder_ID}                         Work Order ID retornado está diferente do anterior.

    Escrever Variavel na Planilha           ${dia_atual_API}T08:00:00               appointmentStart                        Global
    Escrever Variavel na Planilha           ${dia_atual_API}T12:00:00               appointmentFinish                       Global

####################################################################################################################################################################
Reagendar Pedido OPM e FSL Retirada
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via PATCH com o objetivo de reagendar o pedido para 
    ...                                     o mesmo dia e para o primeiro horário disponivel utilizando o OPM ou FSL gerando novo Work Order ID.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1/appointment``. |


    [Tags]                                  Reagenda o Pedido OPM
    [Arguments]                             ${CodactivityType}=407


    ${dia_atual_API}=                       Get Current Date                        exclude_millis=yes                      result_format=%Y-%m-%d
    ${WorkOrder_ID}=                        Ler Variavel na Planilha                workOrderId                             Global                       
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global               
    ${associatedDocumentDate}=              Ler Variavel na Planilha                associatedDocumentDate                  Global    
    ${activityType}=                        Set Variable                            ${CodactivityType}
    #Atribui para o dia atual e para o primeiro horário disponivel que é: das 08 as 12 hrs, permitindo fechar a qualquer momento
    ${appointmentStart}=                    Set Variable                            ${dia_atual_API}T08:00:00
    ${appointmentFinish}=                   Set Variable                            ${dia_atual_API}T12:00:00
    ${appointmentComments}=                 Set Variable                            Retirada FTTH 991   
    ${appointmentReason}=                   Set Variable                            Reagendamento VTAL
    ${Address_ID}=                          Ler Variavel na Planilha                addressId                               Global

    ${Response}=                            PATCH_API                               ${API_BASEAPPOINTMENT}/appointment/${WorkOrder_ID}                              "appointment":{"associatedDocument":"${associatedDocument}","associatedDocumentDate":"${associatedDocumentDate}","activityType":"${activityType}","appointmentStart":"${appointmentStart}","appointmentFinish":"${appointmentFinish}","normativeIndicatorDate":"${appointmentFinish}","promiseDate":"${appointmentStart}","appointmentComments":"${appointmentComments}","appointmentReason":""},"address":{"id": "${Address_ID}"}

    ${code}=                                Get Value From Json    ${Response}      $.control.code
    ${message}=                             Get Value From Json    ${Response}      $.control.message
    ${returnedOrderID}=                     Get Value From Json    ${Response}      $.workOrderID

    Set Global Variable                     ${code}
    Set Global Variable                     ${message}
    Set Global Variable                     ${returnedOrderID}

    Valida Retorno da API                   ${code[0]}                              200                                     Reagendar Pedido OPM e FSL

    Should Be Equal As Strings              ${code[0]}                              200
    Should Be Equal As Strings              ${message[0]}                           Ok
    Should Be Equal As Strings              ${returnedOrderID[0]}                   ${WorkOrder_ID}                         Work Order ID retornado está diferente do anterior.

    Escrever Variavel na Planilha           ${dia_atual_API}T08:00:00               appointmentStart                        Global
    Escrever Variavel na Planilha           ${dia_atual_API}T12:00:00               appointmentFinish                       Global

#===================================================================================================================================================================