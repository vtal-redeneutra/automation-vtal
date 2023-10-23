*** Settings ***

Library                                     String

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Keywords ***

Realizar Modificacao Voip
    [Arguments]                             ${INFRATYPE}=FTTH
    [Documentation]                         Realiza a modificação de Voip

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
    ${ACTIVITYTYPE}=                        Set Variable                            4936
    ${NAME}=                                Ler Variavel na Planilha                customerName                            Global
    ${SUBSCRIBERID}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${PHONENUMBER}=                         Ler Variavel na Planilha                phoneNumber                             Global
    ${ADDRESS_ID}=                           Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}=                         Ler Variavel na Planilha                inventoryId                             Global
    ${BAIRRO}=                              Ler Variavel na Planilha                Bairro                                  Global
    ${CEP}=                                 Ler Variavel na Planilha                Address                                 Global
    ${ESTADO}=                              Ler Variavel na Planilha                UF                                      Global
    ${CIDADE}=                              Ler Variavel na Planilha                Cidade                                  Global
    ${RUA}=                                 Ler Variavel na Planilha                addressName                             Global
    ${NUMBER}=                              Ler Variavel na Planilha                Number                                  Global
    ${TIPORUA}=                             Ler Variavel na Planilha                typeLogradouro                          Global
    ${TYPECOMPLEMENT}=                      Ler Variavel na Planilha                typeComplement1                         Global
    ${VALUE1}=                              Ler Variavel na Planilha                value1                                  Global
    ${LOCATIONCODE}=                        Ler Variavel na Planilha                locationCode                            Global
    ${DOCN}=                                Ler Variavel na Planilha                document                                Global
    ${VALUEN}=                              Ler Variavel na Planilha                numeroVoip                              Global
    ${DESCRIPTION}=                         Ler Variavel na Planilha                Description                             Global
    ${STATE}=                               Ler Variavel na Planilha                State                                   Global
    ${LOCABR}=                              Ler Variavel na Planilha                Abbreviation                            Global

    ${RESPONSE}=                            POST_API                                ${API_BASECPOI}/productOrder            "order": {"comOrderService": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "Modificacao","activityType": "4936","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","document": "${DOCN}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}"]}},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "adicionar","neighborhood": "${BAIRRO}","zipCode": "${CEP}","locationCode": "${LOCATIONCODE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${CIDADE}","streetName": "${RUA}","city": "${CIDADE}","number": "${NUMBER}","locationAbbreviation": "${LOCABR}","hasNumber": true,"streetType": "${TIPORUA}","streetTitle": "","stateAbbreviation": "${ESTADO}","complement": {"complements": [{"type": "${TYPECOMPLEMENT}","value": "${VALUE1}"}]}}]},"products": {"product": [{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "remover","technology": "${INFRATYPE}","attributes": {"attribute": [{"name": "Numero VoIP","value": "${VALUEN}","action": "remover"}]}}]}}
    ${RESCODE}=                             Get Value From Json                     ${RESPONSE}                             $.control.code


    Should Be Equal As Strings              ${RESCODE[0]}                           200