*** Settings ***
Documentation                               Criar Ordem Agendamento
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Variables ***

${CORRELATIONORDER}
${ASSOCIATEDDOCUMENT}
${ASSOCIATEDDOCUMENTDATE}

${NAME}
${SUBSCRIBERID}
${PHONENUMBER}

${APPOINTMENTDATE}
${WORKORDERID}

${ADDRESS_ID}
${INVENTORYID}



*** Keywords ***


#===================================================================================================================================================================
Criar Ordem Agendamento
    [Documentation]                         Consome API productOrder e cria ordem de agendamento.
    ...                                     \nCenário com ou sem complemento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
    ...                                     Cria ordem de agendamento usando o Associated_Document. Se o pedido foi realizado sem agendamento, é gerado um novo Associated_Document para criação da ordem.
    ...                                     \nAo final cria OSOrderId.
    [Arguments]                             ${VELOCIDADE}=1000                      ${VERSAO}=v2  #Se não for passado argumento, a velocidade fica como 1000.
    ...                                     ${orderType}=Instalacao                 #Instalacao, Retirada, Bloqueio, Desbloqueio, AssociarCPE, Modificacao de Velocidade, RemanejamentoPonto
    [Tags]                                  CriarOrdemAgendamento

    #Customer
    ${NAME}                                 Set Variable                            TRGIBM
    Escrever Variavel na Planilha           ${NAME}                                 customerName                            Global
    
    ${PHONENUMBER}                          Set Variable                            21999999999
    Escrever Variavel na Planilha           ${PHONENUMBER}                          phoneNumber                             Global
    
    ${Reference}                            Set Variable                            Proximo a padaria 
    Escrever Variavel na Planilha           ${Reference}                            Reference                               Global



    ${CORRELATIONORDER}                     Ler Variavel na Planilha                associatedDocument                      Global
    
    #Pedido realizado sem agendamento.
    IF    "${CORRELATIONORDER}" == "None"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDER}=                Set Variable                            ibm${CORRELATIONORDER}   
        
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     associatedDocument                      Global
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     correlationOrder                        Global
        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                  Global
        

    END

    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                      Global           
    
    
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Type}                                 Set Variable                            ${orderType}
    ${InfraType}                            Set Variable                            FTTH

    ${SUBSCRIBERID}                         Ler Variavel na Planilha                associatedDocument                      Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Deve ser diferente em cada execucao

    #Appointment
    ${HasSlot}                              Set Variable                            true
    ${APPOINTMENTDATE}                      Ler Variavel na Planilha                appointmentStart                        Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Igual ao promisse date e appointment start
    ${MandatoryType}                        Set Variable                            Obrigatorio
    ${WORKORDERID}                          Ler Variavel na Planilha                workOrderId                             Global

    #Address
    ${ADDRESS_ID}                            Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                             Global

    #Product
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB
    
    ${Action}                               Set Variable                            adicionar

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
            IF    "${VERSAO}" == "v3"
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}},"products":{"product":[{"catalogId":"${CatalogID}","action": "${Action}"}]}}
            ELSE
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}},"products":{"product":[{"catalogId":"${CatalogID}","action": "${Action}"}]}}
            END
        END

        IF    ${qntdComp} == 2
            IF    "${VERSAO}" == "v3"
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            ELSE
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            END
        
        END

        IF    ${qntdComp} == 3
            IF    "${VERSAO}" == "v3"
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            ELSE
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            END
        
        
        END

    ELSE
        
        IF    "${VERSAO}" == "v3"
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}"}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        ELSE
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}"}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END
        
    END
    
    IF    "${orderType}" == "RemanejamentoPonto"
        IF    "${type1}" != "None" or "${type2}" != "None" or "${type3}" != "None" 

            ${qntdComp}=                    Convert To Integer                      0
            ${add1}=                        Convert To Integer                      1

            @{listTypes}=                   Create List                             ${type1}                                ${type2}                                ${type3}
                    
            FOR    ${element}    IN    @{listTypes}
                IF    "${element}" != "None"
                    ${qntdComp} =    Evaluate    ${qntdComp}+${add1}
                END
            END

            IF    ${qntdComp} == 1
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}}}
            END

            IF    ${qntdComp} == 2
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}}}
            END

            IF    ${qntdComp} == 3
                ${Response}=                POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}}}
            END

        ELSE
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact":{"name": "sindico Vtal","email":"sindicovtal@vtal.com","phone":"21999900000"}},"appointment": {"hasSlot": "${HasSlot}","date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}"}}}
        END
    END 


    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Criar Ordem Agendamento


    ${OSOrderId}                            Get Value From Json                     ${Response}                             $.order.id

    IF    ${OSOrderId[0]} != ""
        Escrever Variavel na Planilha       ${OSOrderId[0]}                         osOrderId                               Global
    ELSE
        Log To Console                      OSOrderId não foi criado.
    END

#===================================================================================================================================================================
Criar Ordem Agendamento FTTP 
    [Documentation]                         Consome API productOrder e cria ordem de agendamento para cenário FTTP.
    ...                                     \nCenário com ou sem complemento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
    ...                                     Cria ordem de agendamento usando o associatedDocument. Se o pedido foi realizado sem agendamento, é gerado um novo Associated_Document para criação da ordem.
    ...                                     \nAo final cria OS_Order_Id.
    [Arguments]                             ${VELOCIDADE}=1000                      #Se não for passado argumento, a velocidade fica como 1000.
    [Tags]                                  CriarOrdemAgendamentoFTTP
    
    #Customer

    ${NAME}                                 Set Variable                            TRGIBMFTTP
    Escrever Variavel na Planilha           ${NAME}                                 customerName                            Global
    
    ${PHONENUMBER}                          Set Variable                            21999999999
    Escrever Variavel na Planilha           ${PHONENUMBER}                          phoneNumber                             Global
    
    ${Reference}                            Set Variable                            Proximo a padaria 
    Escrever Variavel na Planilha           ${Reference}                            Reference                               Global


    ${CORRELATIONORDER}                     Ler Variavel na Planilha                correlationOrder                        Global
    
    #Pedido realizado sem agendamento.
    IF    "${CORRELATIONORDER}" == "None"    
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDER}=                Set Variable                            ibm${CORRELATIONORDER}   
        
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     associatedDocument                      Global
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     correlationOrder                        Global
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     subscriberId                            Global
        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                  Global
    END
    
    # ${DAT_DB}                               Buscar Campo Dat Id                     ${DAT_DB}                          
    # IF  ${DAT_DB}
    #     Set Global Variable                 ${DAT_DB}                                  ${DAT_DB}
    # END
    
    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                      Global               
    ${SUBSCRIBERID}                         Ler Variavel na Planilha                associatedDocument                      Global
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Type}                                 Set Variable                            Instalacao
    ${InfraType}                            Set Variable                            FTTP


    #Appointment
    ${HasSlot}                              Set Variable                            false
    ${APPOINTMENTDATE}                      Ler Variavel na Planilha                appointmentStart                       Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Igual ao promisse date e appointment start
    ${MandatoryType}                        Set Variable                            Permitido

    #Address
    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                            Global

    #Product
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB
    
    #Complementos
    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global
    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global

    ${Action}                               Set Variable                            adicionar


    
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
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "","mandatoryType": "Permitido","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}},"products":{"product":[{"catalogId":"${CatalogID}","action": "${Action}"}]}}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "","mandatoryType": "Permitido","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "","mandatoryType": "Permitido","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END

        ELSE
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "","mandatoryType": "Permitido","workOrderId": ""},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","reference": "${Reference}"}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
    
    END


    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Criar Ordem Agendamento

    ${OSOrderId}                            Get Value From Json                     ${Response}                             $.order.id
    Escrever Variavel na Planilha           ${OSOrderId[0]}                         osOrderId                               Global

#===================================================================================================================================================================
Realizar Associação de ONT
    [Documentation]                         Criação de ordem (Associação de ONT)
    ...                                     \nSe não existe Associated_Document, é criado um novo.
    ...                                     \nAo final cria SOMOrderID.
    [Tags]                                  AssociaçãoONT
    
    Retornar Token Vtal
    
    #Gera uma novo Associated_Document e Correlation_Order
    ${CORRELATIONORDER}                     Ler Variavel na Planilha                associatedDocument                     Global

    IF    "${CORRELATIONORDER}" == "None"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDER}=                Set Variable                            ${CORRELATIONORDER}   
        
        Escrever Variavel na Planilha       ibm${CORRELATIONORDER}                  associatedDocument                     Global
        Escrever Variavel na Planilha       co${CORRELATIONORDER}                   correlationOrder                       Global
        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                Global

    END

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                     Global      
    ${Correlation_Order}=                   Ler Variavel na Planilha                correlationOrder                       Global 
    ${Associated_Document_Date}=            Ler Variavel na Planilha                associatedDocumentDate                Global 

    ${Type1}                                Set Variable                            AssociarCPE           
    ${InfraType}                            Set Variable                            FTTP  

    ${NAME}                                 Ler Variavel na Planilha                customerName                           Global
    ${SUBSCRIBERID}                         Ler Variavel na Planilha                subscriberId                           Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                            Global
    
    ${serialNumber}                         Ler Variavel na Planilha                serialNumber                            Global

    ${Type}                                 Set Variable                            ONT
    ${code}                                 Set Variable                            616551

    ${Action}                               Set Variable                            adicionar                  

    ${Response}=                            POST_API                                ${API_BASEPRODUCTORDERING}/productOrder        "order": {"correlationOrder": "${Correlation_Order}","associatedDocument": "${Associated_Document}","associatedDocumentDate": "${Associated_Document_Date}","type": "${Type1}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"equipments": {"equipment": [{"serialNumber": "${serialNumber}","type": "${Type}","code": ${code},"action": "${Action}"}]}}

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Realizar Associação de ONT
    Should Be Equal As Strings              ${ResponseMessage[0]}                   Created

    ${OSOrderId}                            Get Value From Json                     ${Response}                             $.order.id

    IF    ${OSOrderId[0]} != ""
        
        Escrever Variavel na Planilha       ${OSOrderId[0]}                         osOrderId                             Global

    ELSE
        
        Log To Console                      OS Order ID não foi criado.

    END
#===================================================================================================================================================================
Criar Ordem de Agendamento CPOi
    [Documentation]                         Consome API productOrder e cria ordem de agendamento.
    ...                                     \nCenário com ou sem complemento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE_DOWN` | Se não for passado argumento, a velocidade de download, por padrão, ficará 400 |
    ...                                     | `VELOCIDADE_UP` | Se não for passado argumento, a velocidade de upload, por padrão, ficará 200 |
    ...                                     Cria ordem de agendamento usando o Associated_Document. Se o pedido foi realizado sem agendamento, é gerado um novo Associated_Document para criação da ordem.
    ...                                     \nAo final cria SOMOrderID.
    [Arguments]                             ${VELOCIDADE_DOWN}=400                      #Se não for passado argumento, a velocidade fica como 1000.
    ...                                     ${VELOCIDADE_UP}=200


    ${CORRELATIONORDER}                     Ler Variavel na Planilha                associatedDocument                      Global
    ${comOrderService}                      Set Variable                            COS${CORRELATIONORDER}
    ${SUBSCRIBERID}                         Set Variable                            SI${CORRELATIONORDER}
    Escrever Variavel na Planilha           ${SUBSCRIBERID}                         subscriberId                            Global
    Escrever Variavel na Planilha           ${comOrderService}                      comOrderService                         Global
    

    #Pedido realizado sem agendamento.
    IF    "${CORRELATIONORDER}" == "None"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDER}=                Set Variable                            ibm${CORRELATIONORDER}
        
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     associatedDocument                      Global
        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                  Global
        

    END

    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                      Global
    
    
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Type}                                 Set Variable                            Instalacao
    ${ACTIVITYTYPE}                         Set Variable                            4936
    ${InfraType}                            Set Variable                            FTTH

    #Customer
    ${NAME}                                 Ler Variavel na Planilha                customerName                            Global
    ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                             Global

    #Appointment
    ${HasSlot}                              Set Variable                            true
    ${APPOINTMENTDATE}                      Ler Variavel na Planilha                appointmentStart                        Global                                  # Igual ao promisse date e appointment start
    ${MandatoryType}                        Set Variable                            Permitido
    ${WORKORDERID}                          Ler Variavel na Planilha                workOrderId                             Global

    #Address
    ${ADDRESS_ID}                            Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                             Global

    ${NEIGHBORHOOD}                         Ler Variavel na Planilha                Bairro                                  Global
    ${CEP}                                  Ler Variavel na Planilha                Address                                 Global
    ${cod_LOCALIDADE}                       Ler Variavel na Planilha                LocationCode                            Global
    ${DESCRIPTION}                          Ler Variavel na Planilha                Description                             Global
    ${STATE}                                Ler Variavel na Planilha                State                                   Global
    ${LOCATION}                             Ler Variavel na Planilha                Cidade                                  Global
    ${RUA}                                  Ler Variavel na Planilha                addressName                             Global
    ${NUMERO}                               Ler Variavel na Planilha                Number                                  Global
    ${locationAbbreviation}                 Ler Variavel na Planilha                Abbreviation                            Global
    ${HasNUMBER}                            Set Variable                            true
    ${STREETTYPE}                           Ler Variavel na Planilha                typeLogradouro                          Global
    ${streetTITLE}                          Set Variable                            null
    ${STATEABBREVIATION}                    Ler Variavel na Planilha                UF                                      Global


    #Product
    ${product_NAME}                         Set Variable                            VELOC_${VELOCIDADE_DOWN}MBPS
    ${Action}                               Set Variable                            adicionar

   
    ${Response}=                            POST_API                                ${API_BASECPOI}/productOrder    "order":{"comOrderService":"${comOrderService}","associatedDocument":"${ASSOCIATEDDOCUMENT}","associatedDocumentDate":"${ASSOCIATEDDOCUMENTDATE}","type":"${Type}","activityType":"${ACTIVITYTYPE}","customer":{"name":"${NAME}","subscriberId":"${SUBSCRIBERID}","phoneNumber":{"phoneNumbers":["${PHONENUMBER}","",""]}},"appointment":{"hasSlot":"${HasSlot}","date":"${APPOINTMENTDATE}","mandatoryType":"${MandatoryType}","workOrderId":"${WORKORDERID}"},"addresses":{"address":[{"id":"${ADDRESS_ID}","inventoryId":"${INVENTORYID}","action": "${Action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "${streetTITLE}","stateAbbreviation": "${STATEABBREVIATION}"}]},"products":{"product":[{"type":"Banda Larga","catalogId":"","name":"${product_NAME}","action":"${Action}","technology":"${InfraType}","attributes":{"attribute":[{"name":"Velocidade","value":"${VELOCIDADE_DOWN} MBPS","action":"${Action}"},{"name":"Download","value":"${VELOCIDADE_DOWN}","action":"${Action}"},{"name":"Upload","value":"${VELOCIDADE_UP}","action":"${Action}"},{"name":"Descricao","value":"Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}MBPS","action":"${Action}"},{"name":"ValorProduto","value":"400.00","action":"${Action}"},{"name":"ExibicaoFatura","value":"1","action":"${Action}"},{"name":"DescricaoFatura","value":"Oi Fibra ${VELOCIDADE_DOWN}MB","action":"${Action}"},{"name":"PrecoCap","value":"109.00","action":"${Action}"},{"name":"Ativo","value":"1","action":"${Action}"},{"name":"ModeloCobranca","value":"Pré-Pago","action":"${Action}"}]}}]}}



    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     200                                     Criar Ordem Agendamento

#===================================================================================================================================================================
Criar Ordem Agendamento Bitstream 
    [Documentation]                         Consome API productOrder V2 e cria ordem de agendamento Bitstream.
    ...                                     \nCenário com ou sem complemento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
    ...                                     Cria ordem de agendamento usando o associatedDocument. Se o pedido foi realizado sem agendamento, é gerado um novo Associated_Document para criação da ordem.
    ...                                     \nAo final cria OS_Order_Id.
    [Arguments]                             ${VELOCIDADE}=1000                      
    [Tags]                                  CriarOrdemAgendamentoBitstream
    

    ${NAME}                                 Set Variable                            TRGIBMTIMBIT
    Escrever Variavel na Planilha           ${NAME}                                 customerName                            Global
    
    ${PHONENUMBER}                          Set Variable                            21999999999
    Escrever Variavel na Planilha           ${PHONENUMBER}                          phoneNumber                             Global
    
    ${Reference}                            Set Variable                            Proximo a padaria 
    Escrever Variavel na Planilha           ${Reference}                            Reference                               Global



    ${CORRELATIONORDER}                     Ler Variavel na Planilha                associatedDocument                     Global
    
    #Pedido realizado sem agendamento.
    IF    "${CORRELATIONORDER}" == "None"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDER}=                Set Variable                            ibm${CORRELATIONORDER}   
        
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     associatedDocument                     Global
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     correlationOrder                       Global
        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                Global
    END

    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                     Global           
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                Global
    ${Type}                                 Set Variable                            Instalacao
    ${InfraType}                            Set Variable                            FTTH

    #Customer
    ${SUBSCRIBERID}                         Ler Variavel na Planilha                associatedDocument                     Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Deve ser diferente em cada execucao
    ${business_unity}                       Set Variable                            varejo

    #Appointment
    ${HasSlot}                              Set Variable                            true
    ${APPOINTMENTDATE}                      Ler Variavel na Planilha                appointmentStart                       Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Igual ao promisse date e appointment start
    ${MandatoryType}                        Set Variable                            Obrigatorio
    ${WORKORDERID}                          Ler Variavel na Planilha                workOrderId                           Global

    #Address
    ${ADDRESS_ID}                           Ler Variavel na Planilha                addressId                              Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                            Global

    #Product
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB
    ${Action}                               Set Variable                            adicionar

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
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${business_unity}","fantasyName": "Internet Bits","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact": {"name": "sindico Vtal","email": "sindicovtal@vtal.com","phone": "21999900000"}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${INVENTORYID},"reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${business_unity}","fantasyName": "Internet Bits","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact": {"name": "sindico Vtal","email": "sindicovtal@vtal.com","phone": "21999900000"}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${INVENTORYID},"reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${business_unity}","fantasyName": "Internet Bits","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact": {"name": "sindico Vtal","email": "sindicovtal@vtal.com","phone": "21999900000"}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${INVENTORYID},"reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END

        ELSE
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${business_unity}","fantasyName": "Internet Bits","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]},"workContact": {"name": "sindico Vtal","email": "sindicovtal@vtal.com","phone": "21999900000"}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": ${ADDRESS_ID},"inventoryId": ${INVENTORYID},"reference": "${Reference}"}},"products": {"product": [{"catalogId": "${CatalogID}","action": "adicionar"}]}}
    
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Criar Ordem Agendamento


    ${OSOrderId}                            Get Value From Json                     ${Response}                             $.order.id

    IF    ${OSOrderId[0]} != ""
        Escrever Variavel na Planilha       ${OSOrderId[0]}                         osOrderId                             Global
    ELSE
        Log To Console                      OS_Order_Id não foi criado.
    END
#===================================================================================================================================================================
Criar ordem sem agendamento                                                                                                                                                                                                                               
    [Documentation]                         Consome API productOrder e cria ordem sem agendamento (Não passa Work_Order_Id e nem Appointment_Start).
    ...                                     \nCenário com ou sem complemento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE` | Se não for passado argumento, a velocidade por padrão fica 1000 |
    ...                                     Cria ordem de agendamento usando o associatedDocument. Se o pedido foi realizado sem agendamento, é gerado um novo Associated_Document para criação da ordem.
    ...                                     \nAo final cria OSOrderId.
    [Arguments]                             ${VELOCIDADE}=1000                      #Se não for passado argumento, a velocidade fica como 1000.
    [Tags]                                  CriarOrdemAgendamento

    ${CORRELATIONORDER}                     Ler Variavel na Planilha                associatedDocument                      Global
    
    #Pedido realizado sem agendamento.
    IF    "${CORRELATIONORDER}" == "None"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDER}=                Set Variable                            ibm${CORRELATIONORDER}   
        
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     associatedDocument                      Global
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     correlationOrder                       Global
        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                Global
        

    END

    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                      Global           
    
    
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                Global
    ${Type}                                 Set Variable                            Instalacao
    ${InfraType}                            Set Variable                            FTTH

    #Customer
    ${NAME}                                 Ler Variavel na Planilha                customerName                           Global
    ${SUBSCRIBERID}                         Ler Variavel na Planilha                associatedDocument                      Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Deve ser diferente em cada execucao
    ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                            Global

    #Appointment
    ${HasSlot}                              Set Variable                            true
    ${APPOINTMENTDATE}                      Ler Variavel na Planilha                appointmentStart                       Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Igual ao promisse date e appointment start
    ${MandatoryType}                        Set Variable                            Obrigatorio

    #Address
    ${ADDRESS_ID}                            Ler Variavel na Planilha                addressId                              Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                            Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global

    #Product
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB
    
    ${Action}                               Set Variable                            adicionar

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
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "","mandatoryType": "Obrigatorio","workOrderId": ""},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}},"products":{"product":[{"catalogId":"${CatalogID}","action": "${Action}"}]}}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "","mandatoryType": "Obrigatorio","workOrderId": ""},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${Name}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "","mandatoryType": "Obrigatorio","workOrderId": ""},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        END

        ELSE
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": "${HasSlot}","date": "","mandatoryType": "Obrigatorio","workOrderId": ""},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}"}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
    
    END



    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Criar Ordem Agendamento


    ${OSOrderId}                            Get Value From Json                     ${Response}                             $.order.id

    IF    ${OSOrderId[0]} != ""
        Escrever Variavel na Planilha       ${OSOrderId[0]}                         osOrderId                             Global
    ELSE
        Log To Console                      OSOrderId não foi criado.
    END
#===================================================================================================================================================================
Criar Ordem de Agendamento Voip
    [Documentation]                         Consome API productOrder e cria ordem de agendamento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE_DOWN` | Se não for passado argumento, a velocidade de download, por padrão, ficará 400 |
    ...                                     | `VELOCIDADE_UP` | Se não for passado argumento, a velocidade de upload, por padrão, ficará 200 |
    ...                                     Cria ordem de agendamento usando o Associated_Document. Se o pedido foi realizado sem agendamento, é gerado um novo Associated_Document para criação da ordem.
    ...                                     \nAo final cria SOMOrderID.
    [Arguments]                             ${VELOCIDADE_DOWN}=400                  #Se não for passado argumento, a velocidade fica como 1000.
    ...                                     ${VELOCIDADE_UP}=200


    ${CORRELATIONORDER}                     Ler Variavel na Planilha                associatedDocument                      Global
    ${comOrderService}                      Set Variable                            COS${CORRELATIONORDER}
    ${SUBSCRIBERID}                         Set Variable                            SI${CORRELATIONORDER}
    Escrever Variavel na Planilha           ${SUBSCRIBERID}                         subscriberId                           Global
    Escrever Variavel na Planilha           ${comOrderService}                      comOrderService                         Global
    

    #Pedido realizado sem agendamento.
    IF    "${CORRELATIONORDER}" == "None"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00

        ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDER}=                Set Variable                            ibm${CORRELATIONORDER}
        
        Escrever Variavel na Planilha       ${CORRELATIONORDER}                     associatedDocument                      Global
        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                Global
        

    END

    ${ASSOCIATEDDOCUMENT}=                  Ler Variavel na Planilha                associatedDocument                      Global
    
    
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                Global
    ${Type}                                 Set Variable                            Instalacao
    ${ACTIVITYTYPE}                         Set Variable                            4936
    ${InfraType}                            Set Variable                            FTTH

    #Customer
    ${NAME}                                 Ler Variavel na Planilha                customerName                           Global
    ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                            Global

    #Gerar 15 números aleatorios para o campo "Document" da criação da OS Voip
    ${numeros_document}=                    Generate Random String                  15                                      1234567890
    Escrever Variavel na Planilha           ${numeros_document}                     document                                Global
    ${numeros_document}                     Ler Variavel na Planilha                document                                Global

    #Gerar 10 números aleatorios para o campo "Document" da criação da OS Voip
    ${numeros_voip}=                        Generate Random String                  10                                      1234567890
    Escrever Variavel na Planilha           ${numeros_voip}                         numeroVoip                              Global
    ${numeros_voip}                         Ler Variavel na Planilha                numeroVoip                              Global


    #Appointment
    ${HasSlot}                              Set Variable                            true
    ${APPOINTMENTDATE}                      Ler Variavel na Planilha                appointmentStart                       Global                                  # Igual ao promisse date e appointment start
    ${MandatoryType}                        Set Variable                            Permitido
    ${WORKORDERID}                          Ler Variavel na Planilha                workOrderId                           Global

    #Address
    ${ADDRESS_ID}                            Ler Variavel na Planilha                addressId                              Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                            Global
    ${action}                               Set Variable                            adicionar

    ${NEIGHBORHOOD}                         Ler Variavel na Planilha                Bairro                                  Global
    ${CEP}                                  Ler Variavel na Planilha                Address                                 Global
    ${cod_LOCALIDADE}                       Ler Variavel na Planilha                LocationCode                            Global
    ${DESCRIPTION}                          Ler Variavel na Planilha                Description                             Global
    ${STATE}                                Ler Variavel na Planilha                State                                   Global
    ${LOCATION}                             Ler Variavel na Planilha                Cidade                                  Global
    ${RUA}                                  Ler Variavel na Planilha                addressName                            Global
    ${NUMERO}                               Ler Variavel na Planilha                Number                                  Global
    ${locationAbbreviation}                 Ler Variavel na Planilha                Abbreviation                            Global
    ${HasNUMBER}                            Set Variable                            true
    ${STREETTYPE}                           Ler Variavel na Planilha                typeLogradouro                         Global
    ${streetTITLE}                          Set Variable                            null
    ${STATEABBREVIATION}                    Ler Variavel na Planilha                UF                                      Global


    #Product
    ${product_NAME}                         Set Variable                            VELOC_${VELOCIDADE_DOWN}MBPS
    ${Action}                               Set Variable                            adicionar
    
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
            # ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "COSibm0526145558","associatedDocument": "ibm0526145558","associatedDocumentDate": "2023-05-26T08:00:00-03:00","type": "Instalacao","activityType": "4936","customer": {"name": "Voip Internet","subscriberId": "SIibm0526145558","document": "979957931903790","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999","",""]}},"appointment": {"hasSlot": true,"date": "2023-05-27T08:00:00","mandatoryType": "Permitido","workOrderId": "SA-617404"},"addresses": {"address": [{"id": 219785,"inventoryId": "25806500","action": "adicionar","neighborhood": "Capuchinhos","zipCode": "44076060","locationCode": "71220","description": "Rua Brigadeiro Eduardo Gomes 665, Capuchinhos - Feira De Santana, BA (44076-060)","state": "Bahia","location": "Feira De Santana","streetName": "Eduardo Gomes","city": "Feira De Santana","number": "665","locationAbbreviation": "FSA","hasNumber": true,"streetType": "Rua","streetTitle": "","stateAbbreviation": "BA","complement": {"complements": [{"type": "CA","value": "1"}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "VELOC_400MBPS","action": "adicionar","technology": "FTTH","attributes": {"attribute": [{"name": "Velocidade","value": "400 MBPS","action": "adicionar"},{"name": "Download","value": "400","action": "adicionar"},{"name": "Upload","value": "200","action": "adicionar"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com 400MBPS","action": "adicionar"},{"name": "ValorProduto","value": "400.00","action": "adicionar"},{"name": "ExibicaoFatura","value": "1","action": "adicionar"},{"name": "DescricaoFatura","value": "Oi Fibra 400MB","action": "adicionar"},{"name": "PrecoCap","value": "109.00","action": "adicionar"},{"name": "Ativo","value": "1","action": "adicionar"},{"name": "ModeloCobranca","value": "Pré-Pago","action": "adicionar"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "adicionar","technology": "FTTH","attributes": {"attribute": [{"name": "Numero VoIP","value": "3728346905","action": "adicionar"}]}}]}}
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${comOrderService}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "${product_NAME}","action": "${action}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}MBPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_DOWN}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeros_voip}","action": "${action}"}]}}]}}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${comOrderService}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","${PHONENUMBER}","${PHONENUMBER}"]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "${product_NAME}","action": "${action}","technology": "FTTH","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}BPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_DOWN}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "FTTH","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeros_voip}","action": "${action}"}]}}]}}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${comOrderService}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","${PHONENUMBER}","${PHONENUMBER}"]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "${product_NAME}","action": "${action}","technology": "FTTH","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}BPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_DOWN}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "FTTH","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeros_voip}","action": "${action}"}]}}]}}
        END

        ELSE
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${comOrderService}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","document": "${numeros_document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","${PHONENUMBER}","${PHONENUMBER}"]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}"}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "${product_NAME}","action": "${action}","technology": "FTTH","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}BPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_DOWN}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "FTTH","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeros_voip}","action": "${action}"}]}}]}}
    
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     200                                     Criar Ordem Agendamento
#===================================================================================================================================================================
