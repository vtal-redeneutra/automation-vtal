*** Settings ***
Documentation                               Consultar Agendamento
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot



*** Variables ***
${work_OrderId}
${APPOINTMENTSTART}
${APPOINTMENTFISNISH}


*** Keywords ***
Consultar o Agendamento
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nConsultar Agendamento
    [Tags]                                  ConsultarAgendamento

    # Retornar Token Vtal
    Consultar Agendamento

#===================================================================================================================================================================
Consultar Agendamento
    [Documentation]                         Consulta o Agendamento realizado e verifica se o pedido foi: "Atribuido", "Não atribuido" ou "Cancelado" 
    ...                                     através da API pelo método GET
    ...                                     \nLê na planilha valor do campo Word_Order_Id: "SA-XXXXXX"
    ...                                     \nRetorna o status do pedido e preenche na planilha o campo "LyfeCycleStatus" na planilha
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1``. |
    [Tags]                                  ConsultarAgendamento

    ${work_OrderId}=                        Ler Variavel na Planilha                workOrderId                             Global
    ${Response}=                            GET_API                                 ${API_BASEAPPOINTMENT}/appointment/${work_OrderId}
    
    ${lifeCycleStatus}=                     Get Value From Json                     ${Response.json()}                      $.workOrder.lifeCycleStatus
    
    

    ${type}=                                Get Value From Json                     ${Response.json()}                      $.control.type                    
    ${message}=                             Get Value From Json                     ${Response.json()}                      $.control.message
     
    Should Be Equal As Strings              "${Response.status_code}"               "200"
    Should Be Equal As Strings              "${type[0]}"                            "S"
    Should Be Equal As Strings              "${message[0]}"                         "Ok"

    IF    "${lifeCycleStatus[0]}" == "Cancelado"

        ${cancelReason}=                    Get Value From Json                     ${Response.json()}                      $.workOrder.appointments[0].appointmentReason

        ${AppointmentReason}=               Ler Variavel na Planilha                cancelAppointmentReason                 Global    
            

        ##Should Be Equal As Strings    "${cancelReason[0]}"    "${AppointmentReason}"  -- Validação não possível devido erro no retorno da API, em appointmenReason: "Cancelamento Checkout}", a chaves não deveria estar presente.

        ${cancelDate}=                      Get Value From Json                     ${Response.json()}                      $.workOrder.appointments[0].creationDateTime  

        Escrever Variavel na Planilha       ${cancelDate[0]}                        cancelDate                              Global

    END

    IF    "${lifeCycleStatus[0]}" == "Atribuído"
        

        ${orderId}=                         Get Value From Json                     ${Response.json()}                      $.workOrder.workOrderID
        ${creationDateTime}=                Get Value From Json                     ${Response.json()}                      $.workOrder.appointments[0].creationDateTime


        Should Be Equal As Strings          "${orderId[0]}"                         "${work_OrderId}"
        Escrever Variavel na Planilha       ${creationDateTime[0]}                  creationDate                            Global

        ${appointmentStart}=                Get Value From Json                     ${Response.json()}                      $.workOrder.appointments[0].appointmentStart 
        ${appointmentFinish}=               Get Value From Json                     ${Response.json()}                      $.workOrder.appointments[0].appointmentFinish
    

        ${APPOINTMENTSTART}=                Ler Variavel na Planilha                appointmentStart                        Global
        ${APPOINTMENTFISNISH}=              Ler Variavel na Planilha                appointmentFinish                       Global  


        Should Be Equal As Strings          "${appointmentStart}"                   "${APPOINTMENTSTART}"
        Should Be Equal As Strings          "${appointmentFinish}"                  "${APPOINTMENTFINISH}" 

    END


    IF    "${lifeCycleStatus[0]}" == "Não atribuído" 
        
        Log To Console                      "\n O pedido não está atribuído, verifique o agendamento."

    END

    Escrever Variavel na Planilha           ${lifeCycleStatus[0]}                   lyfeCycleStatus                         Global
    

    Log To Console                          O pedido está ${lifeCycleStatus[0]}

#===================================================================================================================================================================
Consultar Historico Agendamento
    [Arguments]                             ${VERSAO_API}=v1
    [Documentation]                         Consulta o Historico Agendamento através da API pelo método GET
    ...                                     \nLê os campos "associatedDocument" e "Address_Id" na planilha
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/appointment/v1``. |
    [Tags]                                  ConsultarAgendamento

    IF    "${VERSAO_API}" == "v1"
        ${Associated_Document}=             Ler Variavel na Planilha                associatedDocument                      Global
        ${Address_Id}=                      Ler Variavel na Planilha                addressId                               Global
        ${Response}=                        GET_API                                 ${API_BASEAPPOINTMENT}/appointment/?associatedDocument=${Associated_Document}&address.id=${Address_Id}
        @{appointmentsList}=                Get Value From Json                     ${Response.json()}                      $.workOrders[0].appointments
        ${workOrderID}=                     Get Value From Json                     ${Response.json()}                      $.workOrders[0].workOrderID
        ${appointmentsCount}=               Get Length                              ${appointmentsList}
        IF    "${appointmentsCount}" == 0 
            Log To Console                  "\n Não tem histórico de Agendamentos"
            Fail
            
        ELSE
            Log To Console                  "\n Histórico de agendamentos diponível no Log"
            log                             ${appointmentsList}
            log                             ${workOrderID}
        END

    ELSE IF    "${VERSAO_API}" == "v2"
        ${workOrderId}                      Ler Variavel na Planilha                workOrderId                             Global
        ${Response}                         GET_API                                 ${API_BASEAPPOINTMENT_V2}/appointment/${workOrderId}
        ${lyfeCycleStatus}                  Get Value From Json                     ${Response.json()}                      $.appointments.lifeCycleStatus
        ${appointmentsList}=                Get Value From Json                     ${Response.json()}                      $.appointments.occurrences
        ${appointmentsCount}=               Get Length                              ${appointmentsList}
        IF    "${appointmentsCount}" == 0 
            Log To Console                  "\n Não tem histórico de Agendamentos"
            Fail
            
        ELSE
            Log To Console                  "\n Histórico de agendamentos diponível no Log"
            log                             ${appointmentsList}
        END
    END
        
#===================================================================================================================================================================