*** Settings ***
Documentation                               Realizar Bloqueio Agendamento
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot

*** Keywords ***
Bloqueio de Agendamento FTTH
      [Documentation]                       Keyword encadeador TRG  
      ...                                   \nRealiza Bloqueio de Agendamento
    Retornar Token Vtal
    Realizar Bloqueio da SA Após ativação

#===================================================================================================================================================================
Realizar Bloqueio Agendamento FTTP
    [Arguments]                             ${VELOCIDADE}=1000
    [Tags]                                  RealizarBloqueioAgendamentoFTTP
    [Documentation]                         Realizar Bloqueio de Agendamento. Cenário FTTP.
    ...                                     \nCenário com complemento.
    ...                                     \nGera novo Associated_Document e correlationOrder.
    ...                                     \nAo final gera order_id.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
   
     
    Retornar Token Vtal
   
    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${validateDate}=                        Get Current Date                        increment=3 hours                       result_format=%d/%m/%Y %H:%M:%S

    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDERDOCUMENT}=            Set Variable                            co${CORRELATIONORDER}
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}

    Escrever Variavel na Planilha           ${date}                                 associatedDocumentDate                Global   
    Escrever Variavel na Planilha           ${CORRELATIONORDERDOCUMENT}             correlationOrder                       Global   
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                     Global
    Escrever Variavel na Planilha           ${validateDate}                         validateDate                            Global

    ${CorrelationOrder}                     Ler Variavel na Planilha                correlationOrder                       Global
    ${AssociatedDocument}                   Ler Variavel na Planilha                associatedDocument                     Global
    ${AssociatedDocumentDate}               Ler Variavel na Planilha                associatedDocumentDate                Global
    ${Name}                                 Ler Variavel na Planilha                customerName                           Global
    ${SubscriberId}                         Ler Variavel na Planilha                subscriberId                           Global
    ${PhoneNumbers}                         Ler Variavel na Planilha                phoneNumber                            Global
    ${InventoryId}                          Ler Variavel na Planilha                inventoryId                            Global
    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                               Global
    ${TypeComplement1}                      Ler Variavel na Planilha                typeComplement1                         Global
    ${Value1}                               Ler Variavel na Planilha                value1                                  Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global

    ${Action}                               Set Variable                            bloquear total
    ${Type}                                 Set Variable                            Bloqueio
    ${InfraType}                            Set Variable                            FTTP      

    ${CatalogID}                            Ler Variavel na Planilha                maxBandWidth                            Global    
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB           

    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/productOrder  "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${InventoryId},"reference": "${Reference}","complement": {"complements": [{"type": "${TypeComplement1}","value": "${Value1}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
    
    ${Response_Code}                        Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Bloqueio Agendamento FTTP

    ${Resposta_order_id}                    Get Value from Json                     ${Response}                             $.order.id

    ${Resposta_order_id}=                   Convert To Integer                      ${Resposta_order_id[0]}

    Escrever Variavel na Planilha           ${Resposta_order_id}                    BlockId                                 Global

#===================================================================================================================================================================
Realizar Bloqueio da SA Após ativação
    [Tags]                                  RealizarBloqueioAgendamentoFTTH  
    [Documentation]                         Realizar Bloqueio de Agendamento. Cenário FTTH.
    ...                                     \nCenário com complemento.
    ...                                     \nGera novo Associated_Document e correlationOrder.
    ...                                     \nAo final gera order_id.
     
    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDERDOCUMENT}=            Set Variable                            co${CORRELATIONORDER}
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}
        
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                     Global
    Escrever Variavel na Planilha           ${CORRELATIONORDERDOCUMENT}             correlationOrder                       Global
    
    ${CorrelationOrder}                     Ler Variavel na Planilha                correlationOrder                       Global
    ${AssociatedDocument}                   Ler Variavel na Planilha                associatedDocument                     Global
    ${AssociatedDocumentDate}               Ler Variavel na Planilha                associatedDocumentDate                Global
    ${Name}                                 Ler Variavel na Planilha                customerName                           Global
    ${SubscriberId}                         Ler Variavel na Planilha                SubscriberId                            Global
    ${PhoneNumbers}                         Ler Variavel na Planilha                phoneNumber                            Global
    ${InventoryId}                          Ler Variavel na Planilha                InventoryId                             Global
    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${TypeComplement1}                      Ler Variavel na Planilha                typeComplement1                         Global
    ${Value1}                               Ler Variavel na Planilha                value1                                  Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global

    ${Action}                               Ler Variavel na Planilha                Action                                  Global
    ${Type}                                 Ler Variavel na Planilha                Type                                    Global
    ${InfraType}                            Ler Variavel na Planilha                InfraType                               Global

    ${CatalogID}                            Ler Variavel na Planilha                maxBandWidth                            Global    
    ${CatalogID}                            Set Variable                            BL_${CatalogID}MB           

    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/productOrder  "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${InventoryId},"reference": "${Reference}","complement": {"complements": [{"type": "${TypeComplement1}","value": "${Value1}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
    
    ${Response_Code}                        Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Bloqueio Agendamento FTTP

    ${Resposta_order_id}                    Get Value from Json                     ${Response}                             $.order.id

    ${Resposta_order_id}=                   Convert To Integer                      ${Resposta_order_id[0]}

    Escrever Variavel na Planilha           ${Resposta_order_id}                    BlockId                                 Global
#===================================================================================================================================================================
Realizar Bloqueio ou Desbloqueio
    [Tags]                                  RealizarBloqueioAgendamento
    [Arguments]                             ${Type}                                 ${InfraType}                            ${Action}                               ${VELOCIDADE}=1000
    [Documentation]                         Realizar Bloqueio ou Desbloqueio, total ou parcial. Cenário FTTH ou FTTP.
    ...                                     \nCenário com ou sem complemento.
    ...                                     \nGera novo associatedDocument e correlationOrder.
    ...                                     \nAo final gera order_id.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `TYPE` | Bloqueio ou Desbloqueio |
    ...                                     | `INFRATYPE` | FTTH ou FTTP |
    ...                                     | `ACTION` | bloquear total, desbloquear total, bloquear parcial |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
   
    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDERDOCUMENT}=            Set Variable                            co${CORRELATIONORDER}
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}
        
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                      Global
    Escrever Variavel na Planilha           ${CORRELATIONORDERDOCUMENT}             correlationOrder                        Global
    Escrever Variavel na Planilha           ${date}                                 associatedDocumentDate                  Global

    ${validateDate}=                        Get Current Date                        increment=3 hours                       result_format=%d/%m/%Y %H:%M
    Escrever Variavel na Planilha           ${validateDate}                         validateDate                            Global

    ${CorrelationOrder}                     Ler Variavel na Planilha                correlationOrder                        Global
    ${AssociatedDocument}                   Ler Variavel na Planilha                associatedDocument                      Global
    ${AssociatedDocumentDate}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Name}                                 Ler Variavel na Planilha                customerName                            Global
    ${SubscriberId}                         Ler Variavel na Planilha                subscriberId                            Global
    ${PhoneNumbers}                         Ler Variavel na Planilha                phoneNumber                             Global
    ${InventoryId}                          Ler Variavel na Planilha                inventoryId                             Global
    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                               Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global
    ${CatalogID}                            Ler Variavel na Planilha                maxBandWidth                            Global    
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB           
    
    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global

    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global

    # Caso possua complemento, verificação de bloqueio passa no máximo 1 parametros
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
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder      "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${InventoryId},"reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${Value1}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            Set Global Variable             ${Response}
        END
        
        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder      "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${InventoryId},"reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}

            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder      "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${InventoryId},"reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            Set Global Variable             ${Response}
        END

    ELSE
        #Endereço sem complemento realiza o bloqueio 
        ${Response}=                        POST_API                                ${API_BASEPRODUCTORDERING}/productOrder      "order": {"correlationOrder": "${CorrelationOrder}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${InventoryId}","reference": "${Reference}"}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        Set Global Variable                 ${Response}
    END
    
    ${Response_Code}                        Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Bloqueio Agendamento FTTP

    ${Resposta_order_id}                    Get Value from Json                     ${Response}                             $.order.id

    ${Resposta_order_id}=                   Convert To Integer                      ${Resposta_order_id[0]}

    IF  "${Type}" == "Bloqueio"
        Escrever Variavel na Planilha       ${Resposta_order_id}                    blockId                                 Global
    ELSE
        Escrever Variavel na Planilha       ${Resposta_order_id}                    idDesbloqueio                           Global
    END
#===================================================================================================================================================================
Realiza Bloqueio/Desbloqueio Voip
    [Tags]                                  RealizarBloqueioAgendamento
    [Arguments]                             ${Type}                                 ${acao}                                 ${VELOCIDADE_DOWN}=400                  ${VELOCIDADE_UP}=200                                                    
    [Documentation]                         Realizar Bloqueio ou Desbloqueio, total ou parcial. Cenário FTTH ou FTTP.
    ...                                     \nCenário com ou sem complemento.
    ...                                     \nGera novo associatedDocument e correlationOrder.
    ...                                     \nAo final gera order_id.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `TYPE` | Bloqueio ou Desbloqueio |
    ...                                     | `INFRATYPE` | FTTH ou FTTP |
    ...                                     | `ACTION` | bloquear total, desbloquear total, bloquear parcial |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 400 e 200 |

    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

    ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
    ${CORRELATIONORDERDOCUMENT}=            Set Variable                            co${CORRELATIONORDER}
    ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}
        
    Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                      Global
    Escrever Variavel na Planilha           ${CORRELATIONORDERDOCUMENT}             correlationOrder                        Global
    Escrever Variavel na Planilha           ${date}                                 associatedDocumentDate                  Global

    ${validateDate}=                        Get Current Date                        increment=3 hours                       result_format=%d/%m/%Y %H:%M
    Escrever Variavel na Planilha           ${validateDate}                         validateDate                            Global

    ${CORRELATIONORDER}                     Ler Variavel na Planilha                correlationOrder                        Global
    ${AssociatedDocument}                   Ler Variavel na Planilha                associatedDocument                      Global
    ${AssociatedDocumentDate}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Name}                                 Ler Variavel na Planilha                customerName                            Global
    ${SubscriberId}                         Ler Variavel na Planilha                subscriberId                            Global
    ${numeros_document}                     Ler Variavel na Planilha                document                                Global
    ${PhoneNumbers}                         Ler Variavel na Planilha                phoneNumber                             Global
    ${HasSlot}                              Set Variable                            true
    ${MandatoryType}                        Set Variable                            Permitido
    ${InventoryId}                          Ler Variavel na Planilha                inventoryId                             Global
    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                               Global
    ${Action}                               Set Variable                            adicionar

    ${NEIGHBORHOOD}                         Ler Variavel na Planilha                Bairro                                  Global
    ${CEP}                                  Ler Variavel na Planilha                Address                                 Global
    ${cod_LOCALIDADE}                       Ler Variavel na Planilha                LocationCode                            Global
    ${DESCRIPTION}                          Ler Variavel na Planilha                Description                             Global
    ${STATE}                                Ler Variavel na Planilha                State                                   Global
    ${RUA}                                  Ler Variavel na Planilha                addressName                             Global
    ${NUMERO}                               Ler Variavel na Planilha                Number                                  Global
    ${locationAbbreviation}                 Ler Variavel na Planilha                Abbreviation                            Global
    ${HasNUMBER}                            Set Variable                            true
    ${STREETTYPE}                           Ler Variavel na Planilha                typeLogradouro                          Global
    ${streetTITLE}                          Set Variable                            null
    ${STATEABBREVIATION}                    Ler Variavel na Planilha                UF                                      Global
    ${InfraType}                            Set Variable                            FTTH
    
    #Complementos
    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global
    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global

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
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CORRELATIONORDER}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","activityType": "","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PhoneNumbers}","",""]}},"appointment": {"hasSlot": ${HasSlot},"mandatoryType": "${MandatoryType}","dayPeriod": "","appointmentStart": "","appointmentFinish": "","startPromiseDate": "","finishPromiseDate": ""},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${InventoryId}","action": "${Action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${STATE}","streetName": "${RUA}","city": "${STATE}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": ${streetTITLE},"stateAbbreviation": "${STATEABBREVIATION}","referencePoint": "","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "${VELOCIDADE_DOWN} MBPS","name": "Oi Banda Larga ${VELOCIDADE_DOWN}MBPS","action": "${acao}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${acao}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${acao}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${acao}"}]}}]}}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CORRELATIONORDER}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","activityType": "","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PhoneNumbers}","",""]}},"appointment": {"hasSlot": ${HasSlot},"mandatoryType": "${MandatoryType}","dayPeriod": "","appointmentStart": "","appointmentFinish": "","startPromiseDate": "","finishPromiseDate": ""},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${InventoryId}","action": "${Action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${STATE}","streetName": "${RUA}","city": "${STATE}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": ${streetTITLE},"stateAbbreviation": "${STATEABBREVIATION}","referencePoint": "","complement": {"complements": [{"type": "${type1}","value": "${value1}",{"type": "${type2}","value": "${value2}"}}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "${VELOCIDADE_DOWN} MBPS","name": "Oi Banda Larga ${VELOCIDADE_DOWN}MBPS","action": "${acao}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${acao}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${acao}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${acao}"}]}}]}}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CORRELATIONORDER}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","activityType": "","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PhoneNumbers}","",""]}},"appointment": {"hasSlot": ${HasSlot},"mandatoryType": "${MandatoryType}","dayPeriod": "","appointmentStart": "","appointmentFinish": "","startPromiseDate": "","finishPromiseDate": ""},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${InventoryId}","action": "${Action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${STATE}","streetName": "${RUA}","city": "${STATE}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": ${streetTITLE},"stateAbbreviation": "${STATEABBREVIATION}","referencePoint": "","complement": {"complements": [{"type": "${type1}","value": "${value1}",{"type": "${type2}","value": "${value2}",{"type": "${type3}","value": "${value3}}}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "${VELOCIDADE_DOWN} MBPS","name": "Oi Banda Larga ${VELOCIDADE_DOWN}MBPS","action": "${acao}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${acao}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${acao}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${acao}"}]}}]}}
        END

        ELSE
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CORRELATIONORDER}","associatedDocument": "${AssociatedDocument}","associatedDocumentDate": "${AssociatedDocumentDate}","type": "${Type}","activityType": "","customer": {"name": "${Name}","subscriberId": "${SubscriberId}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PhoneNumbers}","",""]}},"appointment": {"hasSlot": ${HasSlot},"mandatoryType": "${MandatoryType}","dayPeriod": "","appointmentStart": "","appointmentFinish": "","startPromiseDate": "","finishPromiseDate": ""},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${InventoryId}","action": "${Action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${STATE}","streetName": "${RUA}","city": "${STATE}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": ${streetTITLE},"stateAbbreviation": "${STATEABBREVIATION}","referencePoint": ""}]},"products": {"product": [{"type": "Banda Larga","catalogId": "${VELOCIDADE_DOWN} MBPS","name": "Oi Banda Larga ${VELOCIDADE_DOWN}MBPS","action": "${acao}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${acao}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${acao}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${acao}"}]}}]}}
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     200                                     Realizado o Bloqueio

#===================================================================================================================================================================
