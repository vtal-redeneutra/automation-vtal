*** Settings ***
Documentation                               Desbloqueia totalmente
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Variables ***
#${DAT_CENARIO}                             C:/IBM_VTAL/DATA/DAT0008_RealizarDesbloqueioTotal.xlsx

#*** Test Cases ***
#Desbloqueando Totalmente
    #Desbloquear Totalmente


*** Keywords ***
Desbloqueia Totalmente no FTTP
    [Tags]                                  DesbloqueioTotalFTTP
    [Arguments]                             ${VELOCIDADE}=1000
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nDesbloqueio Total no FTTP
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
    
    Retornar Token Vtal     
    Desbloquear Total no FTTP               ${VELOCIDADE}

Realizar Desbloqueio total
    [Tags]                                  DesbloqueioTotalFTTH
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nDesbloqueio Total FTTH

    Retornar Token Vtal
    Desbloquear Total

#===================================================================================================================================================================
Desbloquear Total
    [Tags]                                  DesbloqueioTotalmenteFTTH
    [Documentation]                         Realizar Desbloqueio total. Cenário FTTH.
    ...                                     \nCenário com complemento.
    ...                                     \nGera novo Associated_Document e Correlation_Order.
    ...                                     \nAo final gera order_id.
    
    Retornar Token Vtal
   
    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDERDOCUMENT}=            Set Variable                            co${CORRELATIONORDER}
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}
        
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                      Global
    Escrever Variavel na Planilha           ${CORRELATIONORDERDOCUMENT}             correlationOrder                        Global

    ${CorrelationOrder}                     Ler Variavel na Planilha                correlationOrder                        Global
    ${AssociatedDocument}                   Ler Variavel na Planilha                associatedDocument                      Global
    ${AssociatedDocumentDate}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Name}                                 Ler Variavel na Planilha                customerName                            Global
    ${SubscriberId}                         Ler Variavel na Planilha                subscriberId                            Global
    ${PhoneNumbers}                         Ler Variavel na Planilha                phoneNumber                             Global
    ${InventoryId}                          Ler Variavel na Planilha                inventoryId                             Global
    ${addressId}                            Ler Variavel na Planilha                addressId                               Global
    ${TypeComplement1}                      Ler Variavel na Planilha                typeComplement1                         Global
    ${Value1}                               Ler Variavel na Planilha                value1                                  Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global

    ${Action}                               Set Variable                            desbloquear total
    ${Type}                                 Set Variable                            Desbloqueio
    ${InfraType}                            Set Variable                            FTTH    

    ${CatalogID}                            Ler Variavel na Planilha                maxBandWidth                            Global    
    ${CatalogID}                            Set Variable                            BL_${CatalogID}MB           

    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/productOrder  "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": ${addressId},"inventoryId": ${InventoryId},"reference": "${Reference}","complement": {"complements": [{"type": "${TypeComplement1}","value": "${Value1}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
    
    ${Response_Code}                        Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Bloqueio Agendamento FTTP

    ${Resposta_order_id}                    Get Value from Json                     ${Response}                             $.order.id

    ${Resposta_order_id}=                   Convert To Integer                      ${Resposta_order_id[0]}

    Escrever Variavel na Planilha           ${Resposta_order_id}                    idDesbloqueio                           Global

#====================================================================================================================================================================================================================================
Desbloquear Total no FTTP
    [Arguments]                             ${VELOCIDADE}=1000
    [Tags]                                  DesbloqueioTotalmenteFTTP
    [Documentation]                         Realizar Desbloqueio total. Cenário FTTP.
    ...                                     \nCenário com complemento.
    ...                                     \nGera novo Associated_Document e Correlation_Order.
    ...                                     \nAo final gera order_id.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
     
    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${validateDate}=                        Get Current Date                        increment=3 hours                       result_format=%d/%m/%Y %H:%M:%S

    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDERDOCUMENT}=            Set Variable                            co${CORRELATIONORDER}
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}
    
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                      Global
    Escrever Variavel na Planilha           ${CORRELATIONORDERDOCUMENT}             correlationOrder                        Global
    Escrever Variavel na Planilha           ${date}                                 associatedDocumentDate                  Global
    Escrever Variavel na Planilha           ${validateDate}                         validateDate                            Global

    ${CorrelationOrder}                     Ler Variavel na Planilha                correlationOrder                        Global
    ${AssociatedDocument}                   Ler Variavel na Planilha                associatedDocument                      Global
    ${AssociatedDocumentDate}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Type}                                 Set Variable                            Desbloqueio
    ${InfraType}                            Set Variable                            FTTP
    ${Name}                                 Ler Variavel na Planilha                customerName                            Global
    ${SubscriberId}                         Ler Variavel na Planilha                subscriberId                            Global
    ${PhoneNumbers}                         Ler Variavel na Planilha                phoneNumber                             Global
    ${addressId}                            Ler Variavel na Planilha                addressId                               Global
    ${InventoryId}                          Ler Variavel na Planilha                inventoryId                             Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global
    ${TypeComplement1}                      Ler Variavel na Planilha                typeComplement1                         Global
    ${Value1}                               Ler Variavel na Planilha                value1                                  Global
    ${CatalogID}                            Ler Variavel na Planilha                maxBandWidth                            Global
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB
    ${Action}                               Set Variable                            desbloquear total
    

    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/productOrder     "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": ${addressId},"inventoryId": ${InventoryId},"reference": "${Reference}","complement": {"complements": [{"type": "${TypeComplement1}","value": "${Value1}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
    
    
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code         
    ${returnedMessage}=                     Get Value From Json                     ${Response}                             $.control.message
    ${returnedOrderId}=                     Get Value From Json                     ${Response}                             $.order.id

    
    Should Be Equal As Strings              ${returnedCode[0]}                      201
    Should Be Equal As Strings              ${returnedMessage[0]}                   Created
    
    ${Resposta_order_desbloqueio}           Get Value from Json                     ${Response}                             $.order.id

    ${Resposta_order_desbloqueio}=          Convert To Integer                      ${Resposta_order_desbloqueio[0]}

    Escrever Variavel na Planilha           ${Resposta_order_desbloqueio}           idDesbloqueio                           Global

    IF    ${returnedOrderId[0]} == ""
        
        Log To Console                      OrderId não retornada.

    ELSE
        
        Log To Console                      OrderId retornada.

    END

#=====================================================================================================================================================================================================================================================================

