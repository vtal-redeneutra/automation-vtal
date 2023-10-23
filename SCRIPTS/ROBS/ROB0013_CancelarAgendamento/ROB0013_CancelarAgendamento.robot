*** Settings ***
Documentation                               Cancelar Agendamento
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Variables ***
#${DAT_CENARIO}                              C:/IBM_VTAL/DATA/DAT0005_CancelarAgendamentoExistente.xlsx
${work_OrderId}
${appointmentReason}
${appointmentComments}


#*** Test Cases ***
#Cancelar Agendamento via API
    #Cancelar o Agendamento


*** Keywords ***
Cancelar o Agendamento
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via DELETE com o objetivo de retornar a 
    ...                                     consulta de cancelamento através do Work_Order_Id.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1/appointment``. |

    [Tags]                                  CancelarAgendamento

    Retornar Token Vtal
    Cancelar Agendamento

#===================================================================================================================================================================
Cancelar Agendamento
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via DELETE com o objetivo de retornar a 
    ...                                     consulta de cancelamento do agendamento realizado através do Work_Order_Id.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1/appointment``. |

    
    [Tags]                                  CancelaAgendamento

    ${work_OrderId}=                        Ler Variavel na Planilha                workOrderId                             Global
    ${appointmentReason}=                   Ler Variavel na Planilha                cancelAppointmentReason                 Global
    ${appointmentComments}=                 Ler Variavel na Planilha                cancelAppointmentComments               Global

    ${Response}=                            DELETE_API                              ${API_BASEAPPOINTMENT}/appointment/${work_OrderId}?appointmentReason=${appointmentReason}&appointmentComments=${appointmentComments}
    
    ${returnedMessage}=                     Get Value From Json                     ${Response}                             $.control.message
    ${returnedType}=                        Get Value From Json                     ${Response}                             $.control.type
    
    IF    "${returnedMessage[0]}" != "Ok"
        Log To Console                      Cancelamento não aceito.
        Log To Console                      ${returnedMessage[0]}
        
    ELSE
        
        Log To Console                      Cancelamento realizado.
    END
    

    Escrever Variavel na Planilha           ${returnedMessage[0]}                   returnedMessage                         Global

    
#===================================================================================================================================================================
Cancelar Agendamento Bitstream
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo de retornar a 
    ...                                     consulta de cancelamento do agendamento realizado através do Subscriber_Id e do Associated_Document.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/productOrdering/v2``. |

    [Tags]                                  CancelaAgendamentoBitstream

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${Subscriber_Id}=                       Ler Variavel na Planilha                subscriberId                            Global
    ${SOM_Order_Id}=                        Ler Variavel na Planilha                somOrderId                              Global


    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/cancelProductOrder/${SOM_Order_Id}        "order": {"associatedDocument": "${Associated_Document}","customer": {"subscriberId": "${Subscriber_Id}"}}


    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Erro no cancelamento do Agendamento Bitstream

#===================================================================================================================================================================
Recusar Cancelamento Agendamento Bitstream
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo de retornar a 
    ...                                     consulta de recusa de cancelamento do agendamento realizado através do Subscriber_Id e do Associated_Document.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/productOrdering/v2``. |

    [Tags]                                  CancelaAgendamentoBitstream

    Retornar Token Vtal

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${Subscriber_Id}=                       Ler Variavel na Planilha                subscriberId                            Global
    ${SOM_Order_Id}=                        Ler Variavel na Planilha                somOrderId                              Global


    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/cancelProductOrder/${SOM_Order_Id}        "order": {"associatedDocument": "${Associated_Document}","customer": {"subscriberId": "${Subscriber_Id}"}}


    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      406                                     Cancelamento com retorno diferente do esperado!
