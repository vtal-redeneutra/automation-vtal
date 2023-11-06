*** Settings ***
Documentation                               Tratamento de pendência
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
          

*** Variables ***

${date}
${correlationOrder}
${associatedDocument}
${observation}
${action}
${userId}


*** Keywords ***
Tratando Pendência
    [Tags]                                  TratarPendência
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nTratamento de Pendência
    
    Retornar Token Vtal
    Tratamento da Pendência

#===================================================================================================================================================================
Tratamento da Pendência
    [Tags]                                  TrataPedencia
    [Documentation]                         Consome API productOrder e realiza o tratamento da pendência 7029.
    ...                                     \nSe retornar código diferente de 200, informa que o tratamento não ocorreu.

    ${date}=                                Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${correlationOrder}=                    Ler Variavel na Planilha                correlationOrder                        Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global       
    ${observation}=                         Ler Variavel na Planilha                Observation                             Global
    ${action}=                              Set Variable                            fechar
    ${userId}=                              Ler Variavel na Planilha                somOrderId                              Global
    ${code}=                                Set Variable                            7029
    ${orderID}=                             Ler Variavel na Planilha                workOrderId                             Global

    ${updateDate}=                          Get Current Date                        result_format=%Y-%m-%dT%H:%M:%S    
    Escrever Variavel na Planilha           ${updateDate}                           updateDate                              Global



    ${Response}=                            PATCH_API                               ${API_BASEPRODUCTORDERING}/productOrder/${userId}      "order": {"correlationOrder": "${correlationOrder}","associatedDocument": "${associatedDocument}","appointment": {"hasSlot": true,"date": "${date}","mandatoryType": "Permitido","workOrderId": "${orderID}"},"issue": {"code": ${code},"observation": "${observation}","userId": "${userId}","updateDate": "${updateDate}","action": "${action}"}}


    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Tratamento não ocorreu.


    #Falta fazer as validações.

#===================================================================================================================================================================
Tratamento de Pendencia 7065
    [Tags]                                  TratamentoPendencia7065
    [Documentation]                         Consome API productOrder e realiza o tratamento da pendência 7065.
    ...                                     \nSe retornar código diferente de 200, informa que o tratamento não ocorreu.

    ${date}=                                Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${correlationOrder}=                    Ler Variavel na Planilha                correlationOrder                       Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global       
    ${observation}=                         Ler Variavel na Planilha                Observation                             Global
    ${action}=                              Set Variable                            fechar
    ${userId}=                              Ler Variavel na Planilha                somOrderId                              Global
    ${code}=                                Set Variable                            7065
    ${orderID}=                             Ler Variavel na Planilha                workOrderId                             Global

    ${updateDate}=                          Get Current Date                        result_format=%Y-%m-%dT%H:%M:%S    
    Escrever Variavel na Planilha           ${updateDate}                           updateDate                              Global

     ${Response}=                            PATCH_API                               ${API_BASEPRODUCTORDERING}/productOrder/${userId}      "order": {"correlationOrder": "${correlationOrder}","associatedDocument": "${associatedDocument}","appointment": {"hasSlot": true,"date": "${date}","mandatoryType": "Permitido","workOrderId": "${orderID}"},"issue": {"code": ${code},"observation": "${observation}","userId":"${userId}","updateDate": "${updateDate}","action": "${action}"}}


    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Tratamento não ocorreu.
#===================================================================================================================================================================
Tratamento de Pendencia TroubleTicket
    [Documentation]                         Acessa o TroubleTicket ID para fazer tratamento de pendência, deve retornar código 200.
    # [Arguments]                             ${associatedDocument_MassaNETQ}         ${subscriberId_MassaNETQ}               
    
    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                      Global   
    ${Subscriber_Id}                        Ler Variavel na Planilha                subscriberId                            Global   
    ${issueCode}=                           Set Variable                            7029
    ${appointmentStart}=                    Ler Variavel na Planilha                appointmentStart                        Global
    ${appointmentFinish}=                   Ler Variavel na Planilha                appointmentFinish                       Global
    ${workOrderId}=                         Ler Variavel na Planilha                workOrderId                             Global

    ${ttId}=                                Ler Variavel na Planilha                troubleTicketId                         Global

    ${Response}=                            PATCH_API                               ${API_BASETROUBLETICKET}/${ttId}        "troubleTicket": {"associatedDocument": "${Associated_Document}","customer": {"subscriberId": "${Subscriber_Id}"},"issue": {"code": "${issueCode}"},"appointment": {"appointmentStart": "${appointmentStart}","appointmentFinish": "${appointmentFinish}","workOrderId": "${workOrderId}"}}
    Set Global Variable                     ${Response}
    
    ${status_recebido}=                     Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${status_recebido[0]}                   200
#===================================================================================================================================================================
Resolucao Pendencia 7100
    [Documentation]
    
    # Retornar Token Vtal

    ${correlationOrder}=                    Ler Variavel na Planilha                correlationOrder                        Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global   
    ${issueCode}=                           Set Variable                            7100
    ${observation}=                         Set Variable                            Resolucao de pendencia de contato de obra
    ${updateDate}=                          Get Current Date                        increment=1 day                         result_format=%Y-%m-%dT%H:%M:%S        
    ${action}                               Set Variable                            fechar
    ${customer_name}                        Set Variable                            sindico VTAL
    ${customer_email}                       Set Variable                            sindicovtal@vtal.com
    ${customer_phone}                       Set Variable                            21999999999
    ${orderID}                              Ler Variavel na Planilha                somOrderId                              Global


    ${Response}=                            PATCH_API                               ${API_BASEPRODUCTORDERING}/productOrder/${orderID}      "order": {"correlationOrder": "${correlationOrder}","associatedDocument": "${associatedDocument}","issue": {"code": ${issueCode},"observation": "${observation}","userId": "","updateDate": "${updateDate}","action": "${action}"}}


    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Erro na resolução de pendencia 7100
$===================================================================================================================================================================
Resolucao pendencia Tenant
    [Documentation]                         Consome API productOrder e realiza o tratamento da pendência "TA - Notificar Recursos Tenant"
    ...                                     \nSe retornar código diferente de 200, informa que o tratamento não ocorreu.

    ${orderID}                              Ler Variavel na Planilha                osOrderId                               Global
    ${correlationOrder}=                    Ler Variavel na Planilha                correlationOrder                        Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global   
    ${taskId}=                              Ler Variavel na Planilha                taskId                                  Global
    

    ${Response}=                            PATCH_API                               ${API_BASEPRODUCTORDERING}/productOrder/${orderID}      "order": {"correlationOrder": "${correlationOrder}","associatedDocument": "${associatedDocument}","task": {"id": ${taskId},"type": "CONFIGURACAO_NAAS_ACS"}}

    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Erro na resolução de pendencia Bitstream
#===================================================================================================================================================================
Resolucao Pendencia 7111
    [Documentation]
    

    ${date}=                                Get Current Date                        increment=1 day                         result_format=%Y-%m-%dT%H:%M:%S
    ${correlationOrder}=                    Ler Variavel na Planilha                correlationOrder                        Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global   
    ${code}=                                Set Variable                            7111
    ${observation}=                         Set Variable                            Resolucao de pendencia de rede
    ${updateDate}=                          Get Current Date                        increment=1 day                         result_format=%Y-%m-%dT%H:%M:%S
    ${action}                               Set Variable                            redirecionar
    ${orderID}                              Ler Variavel na Planilha                workOrderId                             Global
    ${SOM_orderID}                          Ler Variavel na Planilha                somOrderId                              Global


    ${Response}=                            PATCH_API                               ${API_BASEPRODUCTORDERING}/productOrder/${SOM_orderID}      "order": {"correlationOrder": "${correlationOrder}","associatedDocument": "${associatedDocument}","appointment": {"hasSlot": true,"date": "${date}","mandatoryType": "Permitido","workOrderId": "${orderID}"},"issue": {"code": ${code},"observation": "${observation}","userId": "","updateDate": "${updateDate}","action": "${action}"}}


    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Erro na resolução de pendencia 7111
#===================================================================================================================================================================
Fechar pendencia de rede 7111
    [Documentation]                         Consome API productOrder e realiza o tratamento da pendência "TA - Tratar Pendência Tenant"
    ...                                     \nSe retornar código diferente de 200, informa que o tratamento não ocorreu.
    
    ${correlationOrder}=                    Ler Variavel na Planilha                correlationOrder                        Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global   
    ${code}=                                Set Variable                            7111
    ${observation}=                         Set Variable                            Resolucao de pendencia de rede
    ${action}                               Set Variable                            fechar
    ${osOrderId}                          Ler Variavel na Planilha                  osOrderId                               Global

    ${updateDate}=                          Get Current Date                        result_format=%Y-%m-%dT%H:%M:%S    
    Escrever Variavel na Planilha           ${updateDate}                           updateDate                              Global

    ${Response}=                            PATCH_API                               ${API_BASEPRODUCTORDERING}/productOrder/${osOrderId}    "order": {"correlationOrder": "${correlationOrder}","associatedDocument": "${associatedDocument}","issue": {"code": ${code},"observation": "${observation}","userId": "","updateDate": "${updateDate}","action": "${action}"}}

    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Erro na resolução de pendencia 7111
#===================================================================================================================================================================
Resolucao Pendencia 7029
    [Documentation]                         Consome API productOrder e realiza o tratamento da pendência 7029.
    ...                                     \nSe retornar código diferente de 200, informa que o tratamento não ocorreu.

    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global   
    ${code}=                                Set Variable                            7029
    ${workOrderId}=                         Ler Variavel na Planilha                workOrderId                             Global
    ${troubleTicket}=                       Ler Variavel na Planilha                troubleTicketId                         Global
    ${appointmentStart}=                    Ler Variavel na Planilha                appointmentStart                        Global
    ${appointmentFinish}=                   Ler Variavel na Planilha                appointmentFinish                       Global


    ${Response}=                            PATCH_API                               ${API_BASETROUBLETICKET}/${troubleTicket}      "troubleTicket": {"associatedDocument": "${associatedDocument}","customer": {"subscriberId": "${subscriberId}"},"issue": {"code": "${code}"},"appointment": {"appointmentStart": "${appointmentStart}","appointmentFinish": "${appointmentFinish}","workOrderId": "${workOrderId}"}}


    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    Should Be Equal As Strings              ${returnedCode[0]}                      200                                     Erro na resolução de pendencia 7029
#===================================================================================================================================================================