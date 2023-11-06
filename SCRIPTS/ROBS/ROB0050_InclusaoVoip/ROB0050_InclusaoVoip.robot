*** Settings ***

Library                                     String

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot



*** Keywords ***

Realizar inclusão Voip
    [Arguments]                             ${INFRATYPE}=FTTH
    [Documentation]                         Realiza a inclusão de Voip em massa Whitelabel

    ${DATE}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}   
        
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                      Global
    ${CORRELATIONORDER}=                    Set Variable                            COS${CORRELATIONORDER} 
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     correlationOrder                        Global
    Escrever Variavel na Planilha           ${DATE}                                 associatedDocumentDate                  Global

    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                      Global
    ${ASSOCIATEDDOCUMENTDATE}=              Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${TYPE}=                                Set Variable                            Modificacao
    ${NAME}=                                Ler Variavel na Planilha                customerName                            Global
    ${SUBSCRIBERID}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${PHONENUMBER}=                         Ler Variavel na Planilha                phoneNumber                             Global
    ${ADDRESSID}=                           Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}=                         Ler Variavel na Planilha                inventoryId                             Global
    ${TYPECOMPLEMENT}=                      Ler Variavel na Planilha                typeComplement1                         Global
    ${VALUE1}=                              Ler Variavel na Planilha                value1                                  Global
    
    #Gerar numeroVoip, número de 10 algarismos aleatórios para a criação da OS Voip
    ${numero_voip}=                         Generate Random String                  10                                      1234567890
    Escrever Variavel na Planilha           ${numero_voip}                          numeroVoip                              Global
    ${numero_voip}=                         Ler Variavel na Planilha                numeroVoip                              Global



    ${RESPONSE}=                            POST_API                                ${API_BASECPOI_V2}/productOrder                                         "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${TYPE}","infraType": "${INFRATYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "varejo","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}"]}}, "appointment": {"hasSlot": false,"date":"","mandatoryType": "Permitido","workOrderId": ""},"addresses": {"address": {"id": "${ADDRESSID}","inventoryId": "${INVENTORYID}","reference": "Proximo a padaria","complement": {"complements": [{"type": "${TYPECOMPLEMENT}","value": "${VALUE1}"}]}}},"products": {"product": {"catalogId": "VoIP","action": "adicionar", "attributes": {"attribute": [{"name": "voipNumber","value": "${numero_voip}"}]}}}}
    ${RESCODE}=                             Get Value From Json                     ${RESPONSE}                             $.control.code      
    Should Be Equal As Strings              ${RESCODE[0]}                           201     