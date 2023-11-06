*** Settings ***

Library                                     String

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot



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
    ${ADDRESSID}=                           Ler Variavel na Planilha                addressId                               Global
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

    ${RESPONSE}=                            POST_API                                ${API_BASECPOI}/productOrder            "order": {"comOrderService": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "Modificacao","activityType": "4936","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","document": "${DOCN}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}"]}},"addresses": {"address": [{"id": ${ADDRESSID},"inventoryId": "${INVENTORYID}","action": "adicionar","neighborhood": "${BAIRRO}","zipCode": "${CEP}","locationCode": "${LOCATIONCODE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${CIDADE}","streetName": "${RUA}","city": "${CIDADE}","number": "${NUMBER}","locationAbbreviation": "${LOCABR}","hasNumber": true,"streetType": "${TIPORUA}","streetTitle": "","stateAbbreviation": "${ESTADO}","complement": {"complements": [{"type": "${TYPECOMPLEMENT}","value": "${VALUE1}"}]}}]},"products": {"product": [{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "remover","technology": "${INFRATYPE}","attributes": {"attribute": [{"name": "Numero VoIP","value": "${VALUEN}","action": "remover"}]}}]}}
    ${RESCODE}=                             Get Value From Json                     ${RESPONSE}                             $.control.code


    Should Be Equal As Strings              ${RESCODE[0]}                           200
#===================================================================================================================================================================
Realizar Modificacao BL + Voip 
    [Documentation]                         Realiza a modificação de BL + Voip
    ...                                     KW com ou sem complemento

    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}   
    
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                      Global
    Escrever Variavel na Planilha           CO${CORRELATIONORDER}                   correlationOrder                        Global
    

    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                      Global
    ${CORRELATIONORDER}=                    Ler Variavel na Planilha                correlationOrder                        Global
    ${ASSOCIATEDDOCUMENTDATE}=              Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${TYPE}=                                Set Variable                            Modificacao
    ${INFRATYPE}                            Set Variable                            FTTH
    ${NAME}=                                Set Variable                            Teste Voip
    ${SUBSCRIBERID}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${BUSINESSUNITY}                        Set Variable                            varejo
    ${FANTASYNAME}                          Set Variable                            InterCorp Internet
    ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                             Global
    ${HASSLOT}                              Set Variable                            false
    ${MANDATORYTYPE}                        Set Variable                            Permitido
    ${ADDRESSID}                            Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                             Global
    ${REFERENCE}                            Ler Variavel na Planilha                Reference                               Global
    ${CATALOGID}                            Set Variable                            VoIP
    ${ACTION}                               Set Variable                            remover
    
    #GERAR 10 NÚMEROS ALEÁTORIOS 
    ${NUMEROVOIP}=                          Generate Random String                  10                                      1234567890
    Escrever Variavel na Planilha           ${NUMEROVOIP}                           numeroVoip                              Global
    ${NUMEROVOIP}                           Ler Variavel na Planilha                numeroVoip                              Global
    
    #COMPLEMENTOS
    ${TYPE1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${TYPE2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${TYPE3}=                               Ler Variavel na Planilha                typeComplement3                         Global
    ${VALUE1}=                              Ler Variavel na Planilha                value1                                  Global
    ${VALUE2}=                              Ler Variavel na Planilha                value2                                  Global
    ${VALUE3}=                              Ler Variavel na Planilha                value3                                  Global

    #VALIDAR COMPLEMENTOS
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
            ${Response}=                    POST_API                                ${API_BASECPOI_V2}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${TYPE}","infraType": "${INFRATYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BUSINESSUNITY}","fantasyName": "${FANTASYNAME}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HASSLOT},"date": "","mandatoryType": "${MANDATORYTYPE}","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESSID},"inventoryId": "${INVENTORYID}","reference": "${REFERENCE}","complement": {"complements": [{"type": "${TYPE1}","value": "${VALUE1}"}]}}},"products": {"product": [{"catalogId": "${CATALOGID}","action": "${ACTION}","attributes": {"attribute": [{"name": "voipNumber","value": "${NUMEROVOIP}"}]}}]}}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASECPOI_V2}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${TYPE}","infraType": "${INFRATYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BUSINESSUNITY}","fantasyName": "${FANTASYNAME}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HASSLOT},"date": "","mandatoryType": "${MANDATORYTYPE}","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESSID},"inventoryId": "${INVENTORYID}","reference": "${REFERENCE}","complement": {"complements": [{"type": "${TYPE1}","value": "${VALUE1}","${TYPE2}","value": "${VALUE2}"}]}}},"products": {"product": [{"catalogId": "${CATALOGID}","action": "${ACTION}","attributes": {"attribute": [{"name": "voipNumber","value": "${NUMEROVOIP}"}]}}]}}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASECPOI_V2}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${TYPE}","infraType": "${INFRATYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BUSINESSUNITY}","fantasyName": "${FANTASYNAME}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HASSLOT},"date": "","mandatoryType": "${MANDATORYTYPE}","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESSID},"inventoryId": "${INVENTORYID}","reference": "${REFERENCE}","complement": {"complements": [{"type": "${TYPE1}","value": "${VALUE1}","${TYPE2}","value": "${VALUE2}","${TYPE3}","value": "${VALUE3}"}]}}},"products": {"product": [{"catalogId": "${CATALOGID}","action": "${ACTION}","attributes": {"attribute": [{"name": "voipNumber","value": "${NUMEROVOIP}"}]}}]}}
        END

        ELSE
            ${Response}=                    POST_API                                ${API_BASECPOI_V2}/productOrder   "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${TYPE}","infraType": "${INFRATYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BUSINESSUNITY}","fantasyName": "${FANTASYNAME}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HASSLOT},"date": "","mandatoryType": "${MANDATORYTYPE}","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESSID},"inventoryId": "${INVENTORYID}","reference": "${REFERENCE}"}},"products": {"product": [{"catalogId": "${CATALOGID}","action": "${ACTION}","attributes": {"attribute": [{"name": "voipNumber","value": "${NUMEROVOIP}"}]}}]}}
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Modificacao BL + Voip 

    ${MODVOIP}                              Get Value From Json                     ${Response}                             $.order.id

    IF    ${MODVOIP[0]} != ""
        Escrever Variavel na Planilha       ${MODVOIP[0]}                           modBlVoip                               Global
    ELSE
        Log To Console                      Numero da modificação do VOIP + BL não foi criado
    END
#===========================================================================================================================================================================================================