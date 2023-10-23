*** Settings ***
Documentation                               Realizar Agendamento
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Variables ***
${ASSOCIATEDDOCUMENTDATE}
${APPOINTMENTSTART}
${APPOINTMENTFINISH}
${ADDRESS_ID}
${workOrderID}                              

*** Keywords ***
#===========================================================================================================================================================================================================
Realizar Agendamento 
    #Realiza Agendagemento e se tiver Associated_Document na planilha não é GERADO e se não tiver é gerado normal (cenário com ou sem complemento)
    [Documentation]                         Consome API appointment e realiza agendamento.
    ...                                     \nCenário com ou sem complemento.
    ...                                     \nSe tiver associatedDocument na planilha, não é gerado um novo. Se não tiver, é gerado normalmente.
    [Tags]                                  RealizarAgendamento
    [Arguments]                             ${cod_activityType}=4927 

    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                      Global
    
    IF    "${Associated_Document}" == "None"    
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${Associated_Document}=             Get Current Date                        result_format=%m%d%H%M%S
        ${Associated_Document}=             Set Variable                            ibm${Associated_Document}   
        

        Escrever Variavel na Planilha       ${Associated_Document}                  associatedDocument                      Global
        Escrever Variavel na Planilha       ${Associated_Document}                  subscriberId                            Global
    END
    
    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                      Global
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${ActivityType}                         Set Variable                            ${cod_activityType}
    ${APPOINTMENTSTART}                     Ler Variavel na Planilha                appointmentStart                        Global
    ${APPOINTMENTFINISH}                    Ler Variavel na Planilha                appointmentFinish                       Global
    ${NormativeIndicatorDate}               Ler Variavel na Planilha                appointmentStart                        Global                                  #Mesmo valor de AppointmentStart
    ${PromiseDate}                          Ler Variavel na Planilha                appointmentStart                        Global                                  #Mesmo valor de AppointmentStart
    ${ADDRESS_ID}=                          Ler Variavel na Planilha                addressId                               Global

    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global

    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global
    
    # Caso possua complemento, verificação de agendamento passa no máximo 3 parametros
    IF    "${type1}" != "None" or "${type2}" != "None" or "${type3}" != "None" 

        ${qntdComp}=                        Convert To Integer                      0
        ${add1}=                            Convert To Integer                      1

        @{listTypes}=                       Create List                             ${type1}                                ${type2}                                ${type3}
                
        FOR    ${element}    IN    @{listTypes}
            IF    "${element}" != "None"
                ${qntdComp} =    Evaluate    ${qntdComp}+${add1}
            END
        END

        IF    ${qntdComp} == 1
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment         "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}          
  
            Set Global Variable             ${Response}
        END
        
        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment        "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}         

            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment        "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}           
        END

    ELSE
        #Endereço sem complemento realiza o agendamento 
        ${Response}=                        POST_API                                ${API_BASEAPPOINTMENT}/appointment         "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}"}           
    	Set Global Variable                 ${Response}
	END
    
    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Agendamento

    ${workOrderID}                          Get Value From Json                     ${Response}                             $.workOrderID

    Escrever Variavel na Planilha           ${Associated_Document}                  associatedDocument                      Global

    Escrever Variavel na Planilha           ${Associated_Document}                  correlationOrder                        Global

    Escrever Variavel na Planilha           ${workOrderID[0]}                       workOrderId                             Global
#=================================================================================================================================================================
Realizar Agendamento de Reparo
    [Documentation]                         Consome API Realiza appointment e Realizar Agendamento de Reparo.
    ...                                     \nCenário sem complemento.
    ...                                     \nLê o associatedDocument da planilha, não gera um novo.

    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                     Global                 
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                 Global
    ${ActivityType}                         Set Variable                            4934
    ${APPOINTMENTSTART}                     Ler Variavel na Planilha                appointmentStart                       Global
    ${APPOINTMENTFINISH}                    Ler Variavel na Planilha                appointmentFinish                      Global
    ${NormativeIndicatorDate}               Ler Variavel na Planilha                appointmentStart                       Global                                  #Mesmo valor de AppointmentStart
    ${PromiseDate}                          Ler Variavel na Planilha                appointmentStart                       Global                                  #Mesmo valor de AppointmentStart
    ${ADDRESS_ID}=                          Ler Variavel na Planilha                addressId                              Global

    ${Response}=                            POST_API                                ${API_BASEAPPOINTMENT}/appointment      "appointment":{"associatedDocument":"${Associated_Document}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","activityType":"${ActivityType}","appointmentStart":"${APPOINTMENTSTART}","appointmentFinish":"${APPOINTMENTFINISH}","normativeIndicatorDate":"${NormativeIndicatorDate}","promiseDate":"${PromiseDate}","appointmentComments":"","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}"}
    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Agendamento

    ${workOrderID}                          Get Value From Json                     ${Response}                             $.workOrderID

    Escrever Variavel na Planilha           ${AssociatedDocument}                   associatedDocument                      Global
    Escrever Variavel na Planilha           ${AssociatedDocument}                   correlationOrder                        Global
    Escrever Variavel na Planilha           ${workOrderID[0]}                       workOrderId                             Global


#=================================================================================================================================================================
Realizar Agendamento para o dia seguinte
    #Realiza Agendagemento para o dia seguinte, e se tiver Associated_Document na planilha não é GERADO e se não tiver é gerado normal (cenário com ou sem complemento)
    [Documentation]                         Consome API appointment e realiza agendamento.
    ...                                     \nCenário com ou sem complemento.
    ...                                     \nSe tiver Associated_Document na planilha, não é gerado um novo. Se não tiver, é gerado normalmente.
    [Tags]                                  RealizarAgendamento

    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                     Global
    
    IF    "${Associated_Document}" == "None"    
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${Associated_Document}=             Get Current Date                        result_format=%m%d%H%M%S
        ${Associated_Document}=             Set Variable                            ibm${Associated_Document}   
        
        Escrever Variavel na Planilha       ${Associated_Document}                  associatedDocument                     Global
        Escrever Variavel na Planilha       ${Associated_Document}                  subscriberId                           Global
    END
    
    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                     Global
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                 Global
    ${ActivityType}                         Set Variable                            4927
    
    ${APPOINTMENTSTART}=                    Get Current Date                        increment=1 day                         result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${APPOINTMENTFINISH}=                   Get Current Date                        increment=1 day 4 hours                 result_format=%Y-%m-%dT%H:%M:%S-03:00
    
    ${NormativeIndicatorDate}=              Set Variable                            ${APPOINTMENTSTART}
    ${PromiseDate}=                         Set Variable                            ${APPOINTMENTSTART}
    
    ${ADDRESS_ID}=                          Ler Variavel na Planilha                addressId                              Global

    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global

    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global
    
    # Caso possua complemento, verificação de agendamento passa no máximo 3 parametros
    IF    "${type1}" != "None" or "${type2}" != "None" or "${type3}" != "None" 

        ${qntdComp}=                        Convert To Integer                      0
        ${add1}=                            Convert To Integer                      1

        @{listTypes}=                       Create List                             ${type1}                                ${type2}                                ${type3}
                
        FOR    ${element}    IN    @{listTypes}
            IF    "${element}" != "None"
                ${qntdComp} =    Evaluate    ${qntdComp}+${add1}
            END
        END

        IF    ${qntdComp} == 1
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment         "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}          
  
            Set Global Variable             ${Response}
        END
        
        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment        "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}         

            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEAPPOINTMENT}/appointment        "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}           
        END

    ELSE
        #Endereço sem complemento realiza o agendamento 
        ${Response}=                        POST_API                                ${API_BASEAPPOINTMENT}/appointment         "appointment": {"associatedDocument": "${Associated_Document}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","activityType": "${ActivityType}","appointmentStart": "${APPOINTMENTSTART}","appointmentFinish": "${APPOINTMENTFINISH}","normativeIndicatorDate": "${NormativeIndicatorDate}","promiseDate": "${PromiseDate}","appointmentComments": "","appointmentReason": ""},"address": {"id": "${ADDRESS_ID}"}           
    	Set Global Variable                 ${Response}
	END
    
    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Agendamento

    ${workOrderID}                          Get Value From Json                     ${Response}                             $.workOrderID

    Escrever Variavel na Planilha           ${Associated_Document}                  associatedDocument                     Global
    Escrever Variavel na Planilha           ${Associated_Document}                  correlationOrder                       Global
    Escrever Variavel na Planilha           ${workOrderID[0]}                       workOrderId                            Global

    Escrever Variavel na Planilha           ${APPOINTMENTSTART}                     appointmentStart                       Global
    Escrever Variavel na Planilha           ${APPOINTMENTFINISH}                    appointmentFinish                      Global
#=================================================================================================================================================================
Realizar Agendamento V2
    [Documentation]                         Realiza o agendamento na versão 2 da API
    [Arguments]                             ${appointmentReason}=Agendamento para Instalação de Fibra

    ${slotId}                               Ler Variavel na Planilha                slotId                                  Global

    ${Response}        POST_API             ${API_BASEAPPOINTMENT_V2}/appointment         "appointment": {"slot": {"id": "${slotId}"},"reason": "${appointmentReason}"}
    
    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Agendamento V2

    ${workOrderID}                          Get Value From Json                     ${Response}                             $.appointment.id
    Escrever Variavel na Planilha           ${workOrderID[0]}                       workOrderId                             Global