*** Settings ***
Documentation                               Realiza o agendamento de retirada.
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

Resource                                    ../../RESOURCE/FSL/UTILS.robot
Resource                                    ../../RESOURCE/API/RES_API.robot

*** Variables ***

${WORKORDERID}

*** Keywords ***
Realizando Agendamento Retirada
    [Documentation]                         Keyword encadeador TRG
    ...                                     Realiza o Agendamento de Retirada.
    [Tags]                                  RealizandoAgendamentoDeRetirada

    Realizar Agendamento de Retirada

#===========================================================================================================================================================================================================
Realizar Agendamento de Retirada 
    [Documentation]                         Realiza o agendamento de retirada através da API pelo método POST
    ...                                     \nRecebe endereço com ou sem complemento
    ...                                     \nGera um Associated_Document e preenche na planilha
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1``. |
    [Tags]                                  RealizarAgendamentoRetirada
    [Arguments]                             ${CodActivityType}=407

    #${AssociatedDocument}=                  Ler Variavel na Planilha                Associated_Document                Global
    ${AssociatedDocument}=                  Get Current Date                        result_format=%m%d%H%M%S
    ${AssociatedDocument}=                  Set Variable                            ibm${AssociatedDocument}                                                        #Obrigatorio possuir nome diferente a cada execucao

    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                Global
    ${ActivityType}                         Set Variable                            ${CodActivityType}
    ${APPOINTMENTSTART}                     Ler Variavel na Planilha                appointmentStart                       Global
    ${APPOINTMENTFINISH}                    Ler Variavel na Planilha                appointmentFinish                      Global
    ${NormativeIndicatorDate}               Ler Variavel na Planilha                appointmentStart                       Global                                  #Mesmo valor de AppointmentStart
    ${PromiseDate}                          Ler Variavel na Planilha                appointmentStart                       Global                                  #Mesmo valor de AppointmentStart
    ${ADDRESS_ID}=                          Ler Variavel na Planilha                addressId                              Global

    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global

    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global

    # Caso possua complemento, verificação de viabilidade passa no máximo 3 parametros
    IF    "${type1}" != "None" or "${type2}" != "None" or "${type3}" != "None"

        ${qntdComp}=                        Convert To Integer                      0
        ${add1}=                            Convert To Integer                      1

        @{listTypes}=                       Create List                             ${type1}                                ${type2}                                ${type3}
                
        FOR    ${element}    IN    @{listTypes}
            IF    "${element}" != "" and "${element}" != "None"
                ${qntdComp} =    Evaluate    ${qntdComp}+${add1}
            END
        END

        IF    ${qntdComp} == 1
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"Retirada FTTH 991","appointmentReason": "Retirada FTTH 991"},"address": {"id": "${ADDRESS_ID}","complement":{"complements":[{"type": "${type1}","value": "${value1}"}]}}
            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"Retirada FTTH 991","appointmentReason": "Retirada FTTH 991"},"address": {"id": "${ADDRESS_ID}","complement":{"complements":[{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}
            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"Retirada FTTH 991","appointmentReason": "Retirada FTTH 991"},"address": {"id": "${ADDRESS_ID}","complement":{"complements":[{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}
            Set Global Variable             ${Response}
        END

    ELSE
        #Endereço sem complemento realiza a consulta somente por ID
        ${Response}=                        POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"Retirada FTTH 991","appointmentReason": "Retirada FTTH 991"},"address": {"id": "${ADDRESS_ID}"}
        Set Global Variable                 ${Response}
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Agendamento de Retirada 

    ${workOrderID}                          Get Value From Json                     ${Response}                             $.workOrderID

    Escrever Variavel na Planilha           ${AssociatedDocument}                   associatedDocument                      Global
    Escrever Variavel na Planilha           ${AssociatedDocument}                   correlationOrder                       Global
    Escrever Variavel na Planilha           ${workOrderID[0]}                       workOrderId                           Global

#===========================================================================================================================================================================================================
Realizar Novo Agendamento de Retirada 
    [Documentation]                         Realizar Novo Agendamento de Retirada através da API pelo método POST
    ...                                     \nLê o Associated_Document gerado pelo agendamento anterior
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1``. |
    [Tags]                                  RealizarNovoAgendamentoRetirada 

    ${AssociatedDocument}                   Ler Variavel na Planilha                associatedDocument                     Global   
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                Global
    ${ActivityType}                         Set Variable                            407
    ${APPOINTMENTSTART}                     Ler Variavel na Planilha                appointmentStart                       Global
    ${APPOINTMENTFINISH}                    Ler Variavel na Planilha                appointmentFinish                      Global
    ${NormativeIndicatorDate}               Ler Variavel na Planilha                appointmentStart                       Global                                  #Mesmo valor de AppointmentStart
    ${PromiseDate}                          Ler Variavel na Planilha                appointmentStart                       Global                                  #Mesmo valor de AppointmentStart
    ${ADDRESS_ID}=                          Ler Variavel na Planilha                addressId                              Global

    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global

    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global

    # Caso possua complemento, verificação de viabilidade passa no máximo 3 parametros
    IF    "${type1}" != "None" or "${type2}" != "None" or "${type3}" != "None"

        ${qntdComp}=                        Convert To Integer                      0
        ${add1}=                            Convert To Integer                      1

        @{listTypes}=                       Create List                             ${type1}                                ${type2}                                ${type3}
                
        FOR    ${element}    IN    @{listTypes}
            IF    "${element}" != "" and "${element}" != "None"
                ${qntdComp} =    Evaluate    ${qntdComp}+${add1}
            END
        END

        IF    ${qntdComp} == 1
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement":{"complements":[{"type": "${type1}","value": "${value1}}]}}
            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement":{"complements":[{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}
            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement":{"complements":[{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}
            Set Global Variable             ${Response}
        END

    ELSE
        #Endereço sem complemento realiza a consulta somente por ID
        ${Response}=                        POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"Retirada FTTH 991","appointmentReason": "Retirada FTTH 991"},"address": {"id": "${ADDRESS_ID}"}
        Set Global Variable                 ${Response}
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Agendamento de Retirada 

    ${workOrderID}                          Get Value From Json                     ${Response}                             $.workOrderID

    # Escrever Variavel na Planilha           ${AssociatedDocument}                   Associated_Document                     Global
    # Escrever Variavel na Planilha           ${AssociatedDocument}                   Correlation_Order                       Global
    Escrever Variavel na Planilha           ${workOrderID[0]}                       workOrderId                           Global

#===========================================================================================================================================================================================================