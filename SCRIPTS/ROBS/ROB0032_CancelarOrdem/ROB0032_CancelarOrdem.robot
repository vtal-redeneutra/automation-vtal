*** Settings ***
Documentation                               Cancelar a Ordem de Agendamento
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot



*** Variables ***
#${DAT_CENARIO}                              C:/IBM_VTAL/DATA/DAT0005_CancelarAgendamentoExistente.xlsx
${work_OrderId}
${appointmentReason}
${appointmentComments}


#*** Test Cases ***
#Cancelar Agendamento via API
    #Cancelar o Agendamento


*** Keywords ***
Cancelar a Ordem
    [Documentation]                         Keyword encadeador TRG
    ...                                     Cancelar a ordem
    [Tags]                                  CancelarOrdem
    [Arguments]                             ${frente}=Whitelabel                    #Whitelabel ou Voip

    Retornar Token Vtal
    Cancelar a Ordem de Agendamento         wlOuVoip=${frente}

#===================================================================================================================================================================
Cancelar a Ordem de Agendamento
    [Documentation]                         Cancela a Ordem de agendamento através da API pelo método POST
    ...                                     \nLê os campos "SOM_Order_Id", "Associated_Document" e "Subscriber_Id" na planilha
    ...                                     \nPreenche o campo "returnedMessage" na planilha com a resposta da API
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/productOrdering/v2``. |
    [Tags]                                  CancelaOrdemAgendamento
    [Arguments]                             ${wlOuVoip}                             #Whitelabel ou Voip

    IF    "${wlOuVoip}" == "Whitelabel"
        ${SOM_Id}=                          Ler Variavel na Planilha                osOrderId                               Global
    ELSE IF    "${wlOuVoip}" == "Voip"
        ${SOM_Id}=                          Ler Variavel na Planilha                somOrderId                              Global
    END

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${Subscriber_Id}=                       Ler Variavel na Planilha                subscriberId                            Global
    

    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/cancelProductOrder/${SOM_Id}                         "order": {"associatedDocument": "${Associated_Document}","customer": {"subscriberId": "${Subscriber_Id}"}}                  
    
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