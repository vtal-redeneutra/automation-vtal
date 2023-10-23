*** Settings ***
Documentation                               ConsultarSlot 
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot

*** Variables ***
${ADDRESS_ID}
${AppointmentStart}
${AppointmentFinish}

*** Keywords ***
Consulta Slot Agendamento
    [Tags]                                  ConsultaSlotAgendamento
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nConsulta Slot Agendamento no intervalo de no maximo 14 dias

    Retornar Slot Agendamento

#===================================================================================================================================================================
Retornar Slot Agendamento
    [Tags]                                  RetornarSlotAgendamento
    [Documentation]                         Consome API searchTimeSlot e consulta slot agendamento no intervalo de no maximo 14 dias
    ...                                     \nEscreve o slot de agendamento na planilha
    
    ${DataAgendamento}=                     Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT08:00:00-03:00
    ${DataAgendamentoFim}=                  Get Current Date                        increment=14 days                       result_format=%Y-%m-%dT12:00:00-03:00



    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                               Global
    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global

    ${StartDate}                            Set Variable                            ${DataAgendamento}
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}
    ${AssociatedDocumentDate}               Set Variable                            ${DataAgendamento}
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamentoFim}
    ${ActivityType}                         Set Variable                            4927
    
    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}

    

    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Slot Agendamento

    ${AppointmentStart}                     Get Value From Json                     ${Response.json()}                      $.slots[0].appointmentStart
    ${AppointmentStart}                     Convert Json to String                  ${AppointmentStart[0]}
    ${AppointmentStart}                     Replace String                          ${AppointmentStart}         "       ${EMPTY}

    ${AppointmentFinish}                    Get Value From Json                     ${Response.json()}          $.slots[0].appointmentFinish
    ${AppointmentFinish}                    Convert Json to String                  ${AppointmentFinish[0]}
    ${AppointmentFinish}                    Replace String                          ${AppointmentFinish}         "       ${EMPTY}

    Set Global Variable                     ${AppointmentStart}
    Set Global Variable                     ${AppointmentFinish}


    Escrever Variavel na Planilha           ${DataAgendamento}                      associatedDocumentDate                  Global
    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                        Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                       Global

    Escrever Variavel na Planilha           ${DataAgendamento}                      associatedDocumentDate                 Global
    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                       Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                      Global


#===================================================================================================================================================================
Retornar Slot Agendamento Vazio   
    [Tags]                                  RetornarSlotAgendamentoVazio
    [Documentation]                         Retorna slot de agendamento expirado
    ...                                     \nConsome API searchTimeSlot e consulta slot agendamento no intervalo de daqui 15 dias e no máximo 16 dias
    ...                                     \nEscreve o slot de agendamento na planilha     
    ...                                     \nColocar a data como DOMINGO no dia da execução (entre 18 e 24h)

    ${diaHoje}                              Get Current Date                        result_format=%w                        # Retorna o dia da semana de hoje como numeral (Segunda=1, ..., Domingo=7)
    ${proximoDomingo}                       Evaluate                                7 - ${diaHoje}
    ${dataLimite}                           Evaluate                                ${proximoDomingo} + 1


    ${DataAgendamento}                      Get Current Date                        increment= ${proximoDomingo} days       result_format=%Y-%m-%dT21:00:00-03:00
    ${DataAgendamentoFim}                   Get Current Date                        increment= ${dataLimite} days           result_format=%Y-%m-%dT02:59:00-03:00

    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global    
    ${StartDate}                            Set Variable                            ${DataAgendamento}    
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}    
    ${AssociatedDocumentDate}               Get Current Date                        result_format=%Y-%m-%dT%H:%M:%S-03:00 
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}    
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamentoFim}    
    ${ActivityType}                         Set Variable                            4927

    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}
   
    Valida Retorno da API                   ${Response.status_code}                 404                                     Retornar Slot Agendamento Vazio
   
    Escrever Variavel na Planilha           ${DataAgendamento}                      associatedDocumentDate                 Global    
    Escrever Variavel na Planilha           ${DataAgendamento}                      appointmentStart                       Global    
    Escrever Variavel na Planilha           ${DataAgendamentoFim}                   appointmentFinish                      Global
#===================================================================================================================================================================
Retornar Slot Agendamento Retirada
    [Tags]                                  RetornarSlotAgendamentoRetirada
    [Documentation]                         Retorna slot agendamento de retirada
    ...                                     \nConsome API searchTimeSlot e consulta slot agendamento no intervalo de daqui 16 dias e no máximo 20 dias
    ...                                     \nEscreve o slot de agendamento na planilha
    [Arguments]                             ${CodActivityType}=407

    ${DataAgendamento}=                     Get Current Date                        increment=16 days                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${DataAgendamentoFim}=                  Get Current Date                        increment=20 days                       result_format=%Y-%m-%dT%H:%M:%S-03:00

    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${StartDate}                            Set Variable                            ${DataAgendamento}
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}
    ${AssociatedDocumentDate}               Get Current Date                        result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamento}
    ${ActivityType}                         Set Variable                            ${CodActivityType}
    
    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}

    

    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Slot Agendamento Retirada

    ${AppointmentStart}                     Get Value From Json                     ${Response.json()}                      $.slots[0].appointmentStart
    ${AppointmentStart}                     Convert Json to String                  ${AppointmentStart[0]}
    ${AppointmentStart}                     Replace String                          ${AppointmentStart}         "       ${EMPTY}

    ${AppointmentFinish}                    Get Value From Json                     ${Response.json()}          $.slots[0].appointmentFinish
    ${AppointmentFinish}                    Convert Json to String                  ${AppointmentFinish[0]}
    ${AppointmentFinish}                    Replace String                          ${AppointmentFinish}         "       ${EMPTY}

    Escrever Variavel na Planilha           ${AssociatedDocumentDate}               associatedDocumentDate                 Global
    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                       Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                      Global


#===================================================================================================================================================================
Retornar Slot Agendamento Vazio Retirada
    [Tags]                                  RetornarSlotAgendamentoVazio
    [Documentation]                         Retorna slot agendamento de retirada expirado
    ...                                     \nConsome API searchTimeSlot e consulta slot agendamento no intervalo de no maximo 14 dias
    ...                                     \nEscreve o slot de agendamento na planilha
    ...                                     \nColocar a data como DOMINGO (depois de 15 dias) no dia da execução (entre 18 e 24h)


    ${diaHoje}                              Get Current Date                        result_format=%w                        # Retorna o dia da semana de hoje como numeral (Segunda=1, ..., Domingo=7)
    ${proximoDomingo}                       Evaluate                                7 - ${diaHoje}
    ${dataInicio}                           Evaluate                                14 + ${proximoDomingo}
    ${dataLimite}                           Evaluate                                15 + ${proximoDomingo}

    ${DataAgendamento}                      Get Current Date                        increment= ${dataInicio} days           result_format=%Y-%m-%dT21:00:00-03:00   
    ${DataAgendamentoFim}=                  Get Current Date                        increment= ${dataLimite} days           result_format=%Y-%m-%dT02:59:00-03:00

    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global    
    ${StartDate}                            Set Variable                            ${DataAgendamento}    
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}    
    ${AssociatedDocumentDate}               Set Variable                            ${DataAgendamento}    
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}    
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamentoFim}    
    ${ActivityType}                         Set Variable                            407

    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}
   
    Valida Retorno da API                   ${Response.status_code}                 404                                     Retornar Slot Agendamento Vazio Retirada
   
    Escrever Variavel na Planilha           ${DataAgendamento}                      associatedDocumentDate                 Global    
    Escrever Variavel na Planilha           ${DataAgendamento}                      appointmentStart                       Global    
    Escrever Variavel na Planilha           ${DataAgendamentoFim}                   appointmentFinish                      Global

#===================================================================================================================================================================
Retornar Slot Reagendamento
    [Tags]                                  RetornarSlotReagendamento
    [Documentation]                         \nConsome API searchTimeSlot e consulta slot agendamento no intervalo de no maximo 14 dias
    ...                                     \nEscreve o slot de agendamento na planilha

    ${DataAgendamento}=                     Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${DataAgendamentoFim}=                  Get Current Date                        increment=14 days                       result_format=%Y-%m-%dT%H:%M:%S-03:00


    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${StartDate}                            Set Variable                            ${DataAgendamento}
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}
    ${AssociatedDocumentDate}               Set Variable                            ${DataAgendamento}
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamentoFim}
    ${ActivityType}                         Set Variable                            4927
    
    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}


    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Slot Reagendamento

    ${AppointmentStart}                     Get Value From Json                     ${Response.json()}                      $.slots[-1].appointmentStart
    ${AppointmentStart}                     Convert Json to String                  ${AppointmentStart[0]}
    ${AppointmentStart}                     Replace String                          ${AppointmentStart}         "       ${EMPTY}

    ${AppointmentFinish}                    Get Value From Json                     ${Response.json()}                      $.slots[-1].appointmentFinish
    ${AppointmentFinish}                    Convert Json to String                  ${AppointmentFinish[0]}
    ${AppointmentFinish}                    Replace String                          ${AppointmentFinish}         "       ${EMPTY}

    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                       Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                      Global

#===================================================================================================================================================================
Retornar Slot Reagendamento Retirada
    [Tags]                                  RetornarSlotReagendamento
    [Documentation]                         Consome API searchTimeSlot e consulta slot agendamento no intervalo de daqui 15 dias e no máximo 20 dias
    ...                                     \nEscreve o slot de agendamento na planilha

    ${DataAgendamento}=                     Get Current Date                        increment=15 days                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${DataAgendamentoFim}=                  Get Current Date                        increment=20 days                       result_format=%Y-%m-%dT%H:%M:%S-03:00


    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${StartDate}                            Set Variable                            ${DataAgendamento}
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}
    ${AssociatedDocumentDate}               Set Variable                            ${DataAgendamento}
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamentoFim}
    ${ActivityType}                         Set Variable                            407
    
    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}


    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Slot Reagendamento Retirada

    ${AppointmentStart}                     Get Value From Json                     ${Response.json()}                      $.slots[-1].appointmentStart
    ${AppointmentStart}                     Convert Json to String                  ${AppointmentStart[0]}
    ${AppointmentStart}                     Replace String                          ${AppointmentStart}         "       ${EMPTY}

    ${AppointmentFinish}                    Get Value From Json                     ${Response.json()}                      $.slots[-1].appointmentFinish
    ${AppointmentFinish}                    Convert Json to String                  ${AppointmentFinish[0]}
    ${AppointmentFinish}                    Replace String                          ${AppointmentFinish}         "       ${EMPTY}

    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                       Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                      Global
#===================================================================================================================================================================
Retornar Slot Agendamento Reparo
    [Documentation]                         Consome API searchTimeSlot e consulta slot agendamento no intervalo de no maximo 72 horas
    ...                                     \nEscreve o slot de agendamento na planilha
    
    ${DataAgendamento}=                     Get Current Date                        increment=0 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${DataAgendamentoFim}=                  Get Current Date                        increment=72 hours                      result_format=%Y-%m-%dT%H:%M:%S-03:00


    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${StartDate}                            Set Variable                            ${DataAgendamento}
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}
    ${AssociatedDocumentDate}               Set Variable                            ${DataAgendamento}
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamentoFim}
    ${ActivityType}                         Set Variable                            4934
    
    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}


    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Slot Agendamento

    ${AppointmentStart}                     Get Value From Json                     ${Response.json()}                      $.slots[0].appointmentStart
    ${AppointmentStart}                     Convert Json to String                  ${AppointmentStart[0]}
    ${AppointmentStart}                     Replace String                          ${AppointmentStart}         "       ${EMPTY}

    ${AppointmentFinish}                    Get Value From Json                     ${Response.json()}          $.slots[0].appointmentFinish
    ${AppointmentFinish}                    Convert Json to String                  ${AppointmentFinish[0]}
    ${AppointmentFinish}                    Replace String                          ${AppointmentFinish}         "       ${EMPTY}

    Set Global Variable                     ${AppointmentStart}
    Set Global Variable                     ${AppointmentFinish}

    Escrever Variavel na Planilha           ${DataAgendamento}                      associatedDocumentDate                 Global
    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                       Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                      Global


#===================================================================================================================================================================
Retornar Slot Agendamento Voip
    [Tags]                                  RetornarSlotAgendamento
    [Documentation]                         Consome API searchTimeSlot e consulta slot agendamento no intervalo de no maximo 14 dias
    ...                                     \nEscreve o slot de agendamento na planilha
    
    ${DataAgendamento}=                     Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT08:00:00-03:00
    ${DataAgendamentoFim}=                  Get Current Date                        increment=14 days                       result_format=%Y-%m-%dT12:00:00-03:00


    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${StartDate}                            Set Variable                            ${DataAgendamento}
    ${FinishDate}                           Set Variable                            ${DataAgendamentoFim}
    ${AssociatedDocumentDate}               Set Variable                            ${DataAgendamento}
    ${PromiseDate}                          Set Variable                            ${DataAgendamento}
    ${NormativeIndicatorDate}               Set Variable                            ${DataAgendamentoFim}
    ${ActivityType}                         Set Variable                            4936
    
    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/searchTimeSlot?address.id=${ADDRESS_ID}&startDate=${StartDate}&finishDate=${FinishDate}&associatedDocumentDate=${AssociatedDocumentDate}&promiseDate=${PromiseDate}&normativeIndicatorDate=${NormativeIndicatorDate}&activityType=${ActivityType}

    

    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Slot Agendamento

    ${AppointmentStart}                     Get Value From Json                     ${Response.json()}                      $.slots[0].appointmentStart
    ${AppointmentStart}                     Convert Json to String                  ${AppointmentStart[0]}
    ${AppointmentStart}                     Replace String                          ${AppointmentStart}         "       ${EMPTY}

    ${AppointmentFinish}                    Get Value From Json                     ${Response.json()}          $.slots[0].appointmentFinish
    ${AppointmentFinish}                    Convert Json to String                  ${AppointmentFinish[0]}
    ${AppointmentFinish}                    Replace String                          ${AppointmentFinish}         "       ${EMPTY}

    Set Global Variable                     ${AppointmentStart}
    Set Global Variable                     ${AppointmentFinish}

    Escrever Variavel na Planilha           ${DataAgendamento}                      associatedDocumentDate                 Global
    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                       Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                      Global
#===================================================================================================================================================================
Retornar Slot Agendamento V2

    [Documentation]                         Consome API searchTimeSlot e consulta slot agendamento na versão 2
    ...                                     \nEscreve o slot de agendamento na planilha
    [Arguments]                             ${orderType}=Instalacao                 # Instalação, Retirada, RemanejamentoPonto, ChamadoTecnico
    ...                                     ${addressChangeFlag}=false              # Indicador de mudança de endereço, habilitado apenas para Instalação
    ...                                     ${priorityFlag}=false                   # Indicador de agendamento prioritário, habilitado apenas para Instalação e ChamadoTecnico
    

    ${dataAgendamento}=                     Get Current Date                        increment=30 minutes                    result_format=%Y-%m-%dT%H:%M:00
    ${dataAgendamentoFim}=                  Get Current Date                        increment=14 days                       result_format=%Y-%m-%dT18:00:00
    
    ${associatedDocument}                   Ler Variavel na Planilha                associatedDocument                     Global
    
    IF    "${Associated_Document}" == "None"
        Log To Console                      Atenção, um novo Associated Document, Correlation Order e Subscriber Id foram gerados.    
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${Associated_Document}=             Get Current Date                        result_format=%m%d%H%M%S
        ${Associated_Document}=             Set Variable                            ibm${Associated_Document}   
        Escrever Variavel na Planilha       ${Associated_Document}                  correlationOrder                       Global
        Escrever Variavel na Planilha       ${Associated_Document}                  associatedDocument                     Global
        Escrever Variavel na Planilha       ${Associated_Document}                  subscriberId                           Global
    END
    
    ${addressId}                            Ler Variavel na Planilha                addressId                               Global
    ${associatedDocument}                   Ler Variavel na Planilha                associatedDocument                      Global
    ${subscriberId}                         Ler Variavel na Planilha                subscriberId                            Global
    ${startDate}                            Set Variable                            ${dataAgendamento}
    ${finishDate}                           Set Variable                            ${dataAgendamentoFim}
    ${productType}                          Set Variable                            Banda Larga
    ${priorityReason}                       Set Variable                            Cliente Diamond
    
    IF    "${priorityFlag}" == "true"
        ${Response}=                        GET_API                                 ${API_BASEAPPOINTMENT_V2}/searchTimeSlot?addressId=${addressId}&subscriberId=${subscriberId}&associatedDocument=${associatedDocument}&startDate=${startDate}&finishDate=${finishDate}&orderType=${orderType}&addressChangeFlag=${addressChangeFlag}&productType=${productType}&priorityFlag=${priorityFlag}&priorityReason=Cliente Diamond
    ELSE
        ${Response}=                        GET_API                                 ${API_BASEAPPOINTMENT_V2}/searchTimeSlot?addressId=${addressId}&subscriberId=${subscriberId}&associatedDocument=${associatedDocument}&startDate=${startDate}&finishDate=${finishDate}&orderType=${orderType}&addressChangeFlag=${addressChangeFlag}&productType=${productType}&priorityFlag=${priorityFlag}
    END

    #Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Slot Agendamento V2 priotiryFlag=true

    ${AppointmentStart}                     Get Value From Json                     ${Response.json()}                      $.slots[0].startDate
    ${AppointmentStart}                     Convert Json to String                  ${AppointmentStart[0]}
    ${AppointmentStart}                     Replace String                          ${AppointmentStart}           "         ${EMPTY}

    ${AppointmentFinish}                    Get Value From Json                     ${Response.json()}                      $.slots[0].finishDate
    ${AppointmentFinish}                    Convert Json to String                  ${AppointmentFinish[0]}
    ${AppointmentFinish}                    Replace String                          ${AppointmentFinish}          "         ${EMPTY}

    # SLOT ID EXPIRA EM 5 MINUTOS
    ${slotId}                               Get Value From Json                     ${Response.json()}                      $.slots[0].id
    ${slotId}                               Convert Json to String                  ${slotId[0]}
    ${slotId}                               Replace String                          ${slotId}                     "         ${EMPTY}

    Escrever Variavel na Planilha           ${DataAgendamento}                      associatedDocumentDate                  Global
    Escrever Variavel na Planilha           ${AppointmentStart}                     appointmentStart                        Global
    Escrever Variavel na Planilha           ${AppointmentFinish}                    appointmentFinish                       Global
    Escrever Variavel na Planilha           ${slotId}                               slotId                                  Global