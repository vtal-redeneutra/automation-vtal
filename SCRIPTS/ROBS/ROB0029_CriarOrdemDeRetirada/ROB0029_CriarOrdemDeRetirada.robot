*** Settings ***
Documentation                               Cria Ordem de Agendamento de Retirada
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ../../RESOURCE/FSL/UTILS.robot
Resource                                    ../../RESOURCE/API/RES_API.robot

*** Variables ***

${WORKORDERID}


*** Keywords ***
Criar Ordem Agendamento Retirada
    [Documentation]                         Cria ordem de agendamento de retirada.  Keyword encadeador TRG
    [Tags]                                  CriandoOrdemAgendamentoRetirada

    Criar Ordem de Retirada

#===========================================================================================================================================================================================================
Criar Ordem de Retirada
    #Se nenhum argumento for passado, é executado como FTTH e a velocidade como 1000
    [Arguments]                             ${FTTH_ou_FTTP}=FTTH                    ${VELOCIDADE}=1000                     ${bit_true_false}=false               
    [Documentation]                         Cria a ordem de agendamento de retirada através de requisição http utilizando método POST.
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/productOrdering/v2/productOrder``|
    [Tags]                                  CriaOrdemAgendamentoDeRetirada

    
    ${SUBSCRIBERID}                         Ler Variavel na Planilha                subscriberId                            Global

    #${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    #${date}=                                Ler Variavel na Planilha                Appointment_Start                       Global 

   
    IF    "${bit_true_false}" == "true"
        ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDERDOCUMENT}=            Set Variable                            coBIT${CORRELATIONORDER}
        ${BusinessUnity}=                       Convert To String                       varejo
        ${ASSOCIATEDDOCUMENT}=                  Get Current Date                        result_format=%m%d%H%M%S
        ${ASSOCIATEDDOCUMENT}=                  Set Variable                            ibmBIT${AssociatedDocument}                                                        #Obrigatorio possuir nome diferente a cada execucao   

        Escrever Variavel na Planilha           ${ASSOCIATEDDOCUMENT}                   associatedDocument                  Global
    ELSE
        ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
        ${CORRELATIONORDERDOCUMENT}=            Set Variable                            co${CORRELATIONORDER}
        ${BusinessUnity}=                       Convert To String                       empresarial
    END

    Escrever Variavel na Planilha           ${CORRELATIONORDERDOCUMENT}             correlationOrder                        Global
             
    ${Type}                                 Set Variable                            Retirada
    ${InfraType}                            Set Variable                            ${FTTH_ou_FTTP}

    #Customer
    ${NAME}                                 Ler Variavel na Planilha                customerName                            Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Deve ser diferente em cada execucao
    ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                             Global

    #Appointment
    ${MandatoryType}                        Set Variable                            Permitido
    
    IF    "${FTTH_ou_FTTP}" == "FTTP"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
        ${validateDate}=                    Get Current Date                        increment=3 hours                       result_format=%d/%m/%Y %H:%M:%S

        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                  Global
        Escrever Variavel na Planilha       ${validateDate}                         validateDate                            Global

        ${HasSlot}                          Set Variable                            false
        ${APPOINTMENTDATE}=                 Set Variable
        ${WORKORDERID}=                     Set Variable            
        ${ASSOCIATEDDOCUMENT}=              Get Current Date                        result_format=%m%d%H%M%S
        ${ASSOCIATEDDOCUMENT}=              Set Variable                            ibm${AssociatedDocument}                                                        #Obrigatorio possuir nome diferente a cada execucao   
        ${ASSOCIATEDDOCUMENTDATE}           Ler Variavel na Planilha                associatedDocumentDate                  Global
        
        Escrever Variavel na Planilha       ${ASSOCIATEDDOCUMENT}                   associatedDocument                      Global

    ELSE IF    "${FTTH_ou_FTTP}" == "FTTH"
        
        ${date}=                            Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
        ${validateDate}=                    Get Current Date                        increment=3 hours                       result_format=%d/%m/%Y %H:%M:%S

        Escrever Variavel na Planilha       ${date}                                 associatedDocumentDate                  Global
        Escrever Variavel na Planilha       ${validateDate}                         validateDate                            Global

        ${HasSlot}                          Set Variable                            true
        ${APPOINTMENTDATE}                  Ler Variavel na Planilha                appointmentStart                        Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Igual ao promisse date e appointment start
        ${WORKORDERID}                      Ler Variavel na Planilha                workOrderId                             Global
        ${ASSOCIATEDDOCUMENTDATE}           Ler Variavel na Planilha                associatedDocumentDate                  Global
        ${ASSOCIATEDDOCUMENT}=              Ler Variavel na Planilha                associatedDocument                      Global
    END

    #Address
    ${ADDRESS_ID}                            Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                             Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global

    #Product
    ${CatalogID}                            Set Variable                            BL_${VELOCIDADE}MB
    
    #Complementos

    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global

    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global

    ${Action}                               Set Variable                            remover

    IF    "${type1}" != "None" or "${type2}" != "None" or "${type3}" != "None"

        ${qntdComp}=                        Convert To Integer                      0
        ${add1}=                            Convert To Integer                      1

        @{listTypes}=                       Create List                             ${type1}                                ${type2}                                ${type3}
                
        FOR    ${element}    IN    @{listTypes}
            IF    "${element}" != "" and "${element}" != "None"
                ${qntdComp} =    Evaluate    ${qntdComp}+${add1}
            END
        END

        IF    ${qntdComp} == 1
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDERDOCUMENT}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BusinessUnity}","fantasyName": "BOX0071","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            Set Global Variable             ${Response}                                                                        
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDERDOCUMENT}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BusinessUnity}","fantasyName": "BOX0071","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDERDOCUMENT}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BusinessUnity}","fantasyName": "BOX0071","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}"}]}}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
            Set Global Variable             ${Response}
        END

    ELSE
        #Endereço sem complemento realiza a consulta somente por ID
        ${Response}=                        POST_API                                ${API_BASEPRODUCTORDERING}/productOrder    "order": {"correlationOrder": "${CORRELATIONORDERDOCUMENT}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BusinessUnity}","fantasyName": "BOX0071","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "Obrigatorio","workOrderId": "${WORKORDERID}"},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}"}},"products": {"product": [{"catalogId": "${CatalogID}","action": "${Action}"}]}}
        Set Global Variable                 ${Response}
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     201                                     Criar Ordem de Retirada
    Should Be Equal As Strings              ${ResponseMessage[0]}                   Created


    ${OrderID}                              Get Value From Json                     ${Response}                             $.order.id

    IF    ${OrderID[0]} != ""
        
        Escrever Variavel na Planilha       ${OrderID[0]}                           osOrderId                               Global

    ELSE
        
        Log To Console                      OrderID não foi criado.

    END

#===========================================================================================================================================================================================================|
Criar Ordem de Retirada VOIP
    [Documentation]                         Cria a ordem de agendamento de retirada para VOIP através de requisição http utilizando método POST.
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/productOrdering/v2/productOrder``|


    ${Data}=                                Get Current Date                        result_format=%m%d%H%M%S
    ${AssociatedDocument}=                  Set Variable                            ibmVOIP${Data}
    Escrever Variavel na Planilha           ${AssociatedDocument}                   associatedDocument                      Global

    ${CorrelationOrder}=                    Set Variable                            COSibmVOIP${Data}
    Escrever Variavel na Planilha           ${CorrelationOrder}                     comOrderService                         Global

    #Dados Massa
    ${AssociatedDocumentDate}=              Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${CustomerName}=                        Ler Variavel na Planilha                customerName                            Global
    ${SubscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${Document}=                            Ler Variavel na Planilha                document                                Global
    ${Telefone}=                            Ler Variavel na Planilha                phoneNumber                             Global
    ${AppointmentDate}=                     Ler Variavel na Planilha                appointmentStart                        Global
    ${WordOrderId}=                         Ler Variavel na Planilha                workOrderId                             Global


    #Endereço
    ${ADDRESS_ID}=                           Ler Variavel na Planilha                addressId                               Global
    ${InventoryId}=                         Ler Variavel na Planilha                inventoryId                             Global
    ${Bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    ${Cep}=                                 Ler Variavel na Planilha                Address                                 Global
    ${LocationCode}=                        Ler Variavel na Planilha                LocationCode                            Global
    ${Description}=                         Ler Variavel na Planilha                Description                             Global
    ${State}=                               Ler Variavel na Planilha                State                                   Global
    ${Cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    ${NomeRua}=                             Ler Variavel na Planilha                addressName                             Global
    ${Numero}=                              Ler Variavel na Planilha                Number                                  Global
    ${AbreviacaoLocal}=                     Ler Variavel na Planilha                Abbreviation                            Global
    ${TipoLogradouro}=                      Ler Variavel na Planilha                tipoLogradouro                          Global
    ${UF}=                                  Ler Variavel na Planilha                UF                                      Global
    ${Referencia}=                          Ler Variavel na Planilha                Referencia                              Global


    ${ExisteComplemento1}=                  Ler Variavel na Planilha                typeComplement1                         Global
    ${ExisteComplemento2}=                  Ler Variavel na Planilha                typeComplement2                         Global
    ${ExisteComplemento3}=                  Ler Variavel na Planilha                typeComplement3                         Global

    #3 complementos
    IF      "${ExisteComplemento3}" != "None"
        ${TipoComplemento1}=                Ler Variavel na Planilha                typeComplement1                         Global
        ${TipoComplemento2}=                Ler Variavel na Planilha                typeComplement2                         Global
        ${TipoComplemento3}=                Ler Variavel na Planilha                typeComplement3                         Global
        ${ValorComplemento1}=               Ler Variavel na Planilha                value1                                  Global
        ${ValorComplemento2}=               Ler Variavel na Planilha                value2                                  Global
        ${ValorComplemento3}=               Ler Variavel na Planilha                value2                                  Global
        ${Response}=                        POST_API                                ${API_BASEPRODUCTORDERING_V1}/productOrder    "order":{"comOrderService":"${CorrelationOrder}","associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${AssociatedDocumentDate}","type":"Retirada","activityType":"407","customer":{"name":"${CustomerName}","subscriberId":"${SubscriberId}","document":"${Document}","businessUnity":"empresarial","fantasyName":"InterCorp Internet","phoneNumber":{"phoneNumbers":["${Telefone}","",""]}},"appointment":{"hasSlot":"true","date":"${AppointmentDate}","mandatoryType":"Permitido","workOrderId":"${WordOrderId}"},"addresses":{"address":{"id":"${ADDRESS_ID}","inventoryId":"${InventoryId}","action":"remover","neighborhood":"${Bairro}","zipCode":"${Cep}","locationCode":"${LocationCode}","description":"${Description}","state":"${State}","location":"${Cidade}","streetName":"${NomeRua}","city":"${Cidade}","number":"${Numero}","locationAbbreviation":"${AbreviacaoLocal}","hasNumber":"true","streetType":"${TipoLogradouro}","streetTitle":"","stateAbbreviation":"${UF}","referencePoint":"${Referencia}","complement":{"complements":[{"type":"${TipoComplemento1}","value":"${ValorComplemento1}"},{"type":"${TipoComplemento2}","value":"${ValorComplemento2}"},{"type":"${TipoComplemento3}","value":"${ValorComplemento3}"}]}}},"products":{"product":[{"type":"Banda Larga","catalogId":"","name":"VELOC_400MBPS","action":"remover","technology":"FTTH","attributes":{"attribute":[{"name":"Velocidade","value":"400 MBPS","action":"remover"},{"name":"Download","value":"400","action":"remover"},{"name":"Upload","value":"200","action":"remover"},{"name":"Descricao","value":"Internet de alta velocidade (Fibra) com 400MBPS","action":"remover"},{"name":"ValorProduto","value":"200.00","action":"remover"},{"name":"ExibicaoFatura","value":"1","action":"remover"},{"name":"DescricaoFatura","value":"Oi Fibra 400MB","action":"remover"},{"name":"PrecoCap","value":"109.00","action":"remover"},{"name":"Ativo","value":"1","action":"remover"},{"name":"ModeloCobranca","value":"Pre-Pago","action":"remover"}]}}]},"workOrder":{"withdrawal":true}}
    
    #2 complementos
    ELSE IF      "${ExisteComplemento2}" != "None"
        ${TipoComplemento1}=                Ler Variavel na Planilha                typeComplement1                         Global
        ${TipoComplemento2}=                Ler Variavel na Planilha                typeComplement2                         Global
        ${ValorComplemento1}=               Ler Variavel na Planilha                value1                                  Global
        ${ValorComplemento2}=               Ler Variavel na Planilha                value2                                  Global
        ${Response}=                        POST_API                                ${API_BASEPRODUCTORDERING_V1}/productOrder    "order":{"comOrderService":"${CorrelationOrder}","associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${AssociatedDocumentDate}","type":"Retirada","activityType":"407","customer":{"name":"${CustomerName}","subscriberId":"${SubscriberId}","document":"${Document}","businessUnity":"empresarial","fantasyName":"InterCorp Internet","phoneNumber":{"phoneNumbers":["${Telefone}","",""]}},"appointment":{"hasSlot":"true","date":"${AppointmentDate}","mandatoryType":"Permitido","workOrderId":"${WordOrderId}"},"addresses":{"address":{"id":"${ADDRESS_ID}","inventoryId":"${InventoryId}","action":"remover","neighborhood":"${Bairro}","zipCode":"${Cep}","locationCode":"${LocationCode}","description":"${Description}","state":"${State}","location":"${Cidade}","streetName":"${NomeRua}","city":"${Cidade}","number":"${Numero}","locationAbbreviation":"${AbreviacaoLocal}","hasNumber":"true","streetType":"${TipoLogradouro}","streetTitle":"","stateAbbreviation":"${UF}","referencePoint":"${Referencia}","complement":{"complements":[{"type":"${TipoComplemento1}","value":"${ValorComplemento1}"},{"type":"${TipoComplemento2}","value":"${ValorComplemento2}"}]}}},"products":{"product":[{"type":"Banda Larga","catalogId":"","name":"VELOC_400MBPS","action":"remover","technology":"FTTH","attributes":{"attribute":[{"name":"Velocidade","value":"400 MBPS","action":"remover"},{"name":"Download","value":"400","action":"remover"},{"name":"Upload","value":"200","action":"remover"},{"name":"Descricao","value":"Internet de alta velocidade (Fibra) com 400MBPS","action":"remover"},{"name":"ValorProduto","value":"200.00","action":"remover"},{"name":"ExibicaoFatura","value":"1","action":"remover"},{"name":"DescricaoFatura","value":"Oi Fibra 400MB","action":"remover"},{"name":"PrecoCap","value":"109.00","action":"remover"},{"name":"Ativo","value":"1","action":"remover"},{"name":"ModeloCobranca","value":"Pre-Pago","action":"remover"}]}}]},"workOrder":{"withdrawal":true}}

    #1 complemento
    ELSE IF      "${ExisteComplemento1}" != "None"
        ${TipoComplemento1}=                Ler Variavel na Planilha                typeComplement1                         Global
        ${ValorComplemento1}=               Ler Variavel na Planilha                value1                                  Global
        ${Response}=                        POST_API                                ${API_BASEPRODUCTORDERING_V1}/productOrder    "order":{"comOrderService":"${CorrelationOrder}","associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${AssociatedDocumentDate}","type":"Retirada","activityType":"407","customer":{"name":"${CustomerName}","subscriberId":"${SubscriberId}","document":"${Document}","businessUnity":"empresarial","fantasyName":"InterCorp Internet","phoneNumber":{"phoneNumbers":["${Telefone}","",""]}},"appointment":{"hasSlot":"true","date":"${AppointmentDate}","mandatoryType":"Permitido","workOrderId":"${WordOrderId}"},"addresses":{"address":{"id":"${ADDRESS_ID}","inventoryId":"${InventoryId}","action":"remover","neighborhood":"${Bairro}","zipCode":"${Cep}","locationCode":"${LocationCode}","description":"${Description}","state":"${State}","location":"${Cidade}","streetName":"${NomeRua}","city":"${Cidade}","number":"${Numero}","locationAbbreviation":"${AbreviacaoLocal}","hasNumber":"true","streetType":"${TipoLogradouro}","streetTitle":"","stateAbbreviation":"${UF}","referencePoint":"${Referencia}","complement":{"complements":[{"type":"${TipoComplemento1}","value":"${ValorComplemento1}"}]}}},"products":{"product":[{"type":"Banda Larga","catalogId":"","name":"VELOC_400MBPS","action":"remover","technology":"FTTH","attributes":{"attribute":[{"name":"Velocidade","value":"400 MBPS","action":"remover"},{"name":"Download","value":"400","action":"remover"},{"name":"Upload","value":"200","action":"remover"},{"name":"Descricao","value":"Internet de alta velocidade (Fibra) com 400MBPS","action":"remover"},{"name":"ValorProduto","value":"200.00","action":"remover"},{"name":"ExibicaoFatura","value":"1","action":"remover"},{"name":"DescricaoFatura","value":"Oi Fibra 400MB","action":"remover"},{"name":"PrecoCap","value":"109.00","action":"remover"},{"name":"Ativo","value":"1","action":"remover"},{"name":"ModeloCobranca","value":"Pre-Pago","action":"remover"}]}}]},"workOrder":{"withdrawal": true}}
    
    #Sem complemento
    ELSE
        ${Response}=                        POST_API                                ${API_BASEPRODUCTORDERING_V1}/productOrder    "order":{"comOrderService":"${CorrelationOrder}","associatedDocument":"${AssociatedDocument}","associatedDocumentDate":"${AssociatedDocumentDate}","type":"Retirada","activityType":"407","customer":{"name":"${CustomerName}","subscriberId":"${SubscriberId}","document":"${Document}","businessUnity":"empresarial","fantasyName":"InterCorp Internet","phoneNumber":{"phoneNumbers":["${Telefone}","",""]}},"appointment":{"hasSlot":"true","date":"${AppointmentDate}","mandatoryType":"Permitido","workOrderId":"${WordOrderId}"},"addresses":{"address":{"id":"${ADDRESS_ID}","inventoryId":"${InventoryId}","action":"remover","neighborhood":"${Bairro}","zipCode":"${Cep}","locationCode":"${LocationCode}","description":"${Description}","state":"${State}","location":"${Cidade}","streetName":"${NomeRua}","city":"${Cidade}","number":"${Numero}","locationAbbreviation":"${AbreviacaoLocal}","hasNumber":"true","streetType":"${TipoLogradouro}","streetTitle":"","stateAbbreviation":"${UF}","referencePoint":"${Referencia}"}},"products":{"product":[{"type":"Banda Larga","catalogId":"","name":"VELOC_400MBPS","action":"remover","technology":"FTTH","attributes":{"attribute":[{"name":"Velocidade","value":"400 MBPS","action":"remover"},{"name":"Download","value":"400","action":"remover"},{"name":"Upload","value":"200","action":"remover"},{"name":"Descricao","value":"Internet de alta velocidade (Fibra) com 400MBPS","action":"remover"},{"name":"ValorProduto","value":"200.00","action":"remover"},{"name":"ExibicaoFatura","value":"1","action":"remover"},{"name":"DescricaoFatura","value":"Oi Fibra 400MB","action":"remover"},{"name":"PrecoCap","value":"109.00","action":"remover"},{"name":"Ativo","value":"1","action":"remover"},{"name":"ModeloCobranca","value":"Pre-Pago","action":"remover"}]}}]},"workOrder":{"withdrawal":true}}
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    Valida Retorno da API                   ${ResponseCode[0]}                      200                                     Realizar Criacao de OS de Retirada 

    
#===========================================================================================================================================================================================================|
Criar Ordem de retirada 4937
    [Documentation]                         Consome API productOrder e cria ordem de agendamento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VELOCIDADE_DOWN` | Se não for passado argumento, a velocidade de download, por padrão, ficará 400 |
    ...                                     | `VELOCIDADE_UP` | Se não for passado argumento, a velocidade de upload, por padrão, ficará 200 |

    [Arguments]                             ${VELOCIDADE_DOWN}=400                  #Se não for passado argumento, a velocidade fica como 400.
    ...                                     ${VELOCIDADE_UP}=200

    ${ASSOCIATEDDOCUMENT}                   Ler Variavel na Planilha                associatedDocument                      Global
    ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                  Global
    ${Type}                                 Set Variable                            Retirada
    ${ACTIVITYTYPE}                         Set Variable                            4937
    ${InfraType}                            Set Variable                            FTTH

    #Customer
    ${NAME}                                 Ler Variavel na Planilha                customerName                            Global
    ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                             Global

    #Dados da massa
    ${SubscriberId}                         Ler Variavel na Planilha                subscriberId                            Global
    ${CorrelationOrder}                     Ler Variavel na Planilha                correlationOrder                        Global
    ${Document}                             Ler Variavel na Planilha                document                                Global    
    ${numeroVoip}                           Ler Variavel na Planilha                numeroVoip                              Global                                    

    #Appointment
    ${HasSlot}                              Set Variable                            true
    ${APPOINTMENTDATE}                      Ler Variavel na Planilha                appointmentStart                        Global                                  
    ${MandatoryType}                        Set Variable                            permitido
    ${WORKORDERID}                          Ler Variavel na Planilha                workOrderId                             Global

    #Address
    ${ADDRESS_ID}                            Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                             Global
    ${action}                               Set Variable                            remover
    
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
    ${STATEABBREVIATION}                    Ler Variavel na Planilha                UF                                      Global
    
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
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CorrelationOrder}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SubscriberId}","document": "${Document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}","complement": {"complements": [{"type": "${type1}","value": "${value1}"}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "VELOC_${VELOCIDADE_DOWN}MBPS","action": "${action}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}MBPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_UP}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "${infraType}","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeroVoip}","action": "${action}"}]}}]}}
        END
        
        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CorrelationOrder}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SubscriberId}","document": "${Document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "VELOC_${VELOCIDADE_DOWN}MBPS","action": "${action}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}MBPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_UP}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "${infraType}","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeroVoip}","action": "${action}"}]}}]}}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CorrelationOrder}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SubscriberId}","document": "${Document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}","complement": {"complements": [{"type": "${type1}","value": "${value1}"},{"type": "${type2}","value": "${value2}"},{"type": "${type3}","value": "${value3}}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "VELOC_${VELOCIDADE_DOWN}MBPS","action": "${action}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}MBPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_UP}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "${infraType}","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeroVoip}","action": "${action}"}]}}]}}
        END

        ELSE
            ${Response}=                    POST_API                                ${API_BASECPOI}/productOrder    "order": {"comOrderService": "${CorrelationOrder}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","activityType": "${ACTIVITYTYPE}","customer": {"name": "${NAME}","subscriberId": "${SubscriberId}","document": "${Document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"appointment": {"hasSlot": ${HasSlot},"date": "${APPOINTMENTDATE}","mandatoryType": "${MandatoryType}","workOrderId": "${WORKORDERID}"},"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "${action}","neighborhood": "${NEIGHBORHOOD}","zipCode": "${CEP}","locationCode": "${cod_LOCALIDADE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${LOCATION}","streetName": "${RUA}","city": "${LOCATION}","number": "${NUMERO}","locationAbbreviation": "${locationAbbreviation}","hasNumber": ${HasNUMBER},"streetType": "${STREETTYPE}","streetTitle": "","stateAbbreviation": "${STATEABBREVIATION}"}]},"products": {"product": [{"type": "Banda Larga","catalogId": "","name": "VELOC_${VELOCIDADE_DOWN}MBPS","action": "${action}","technology": "${InfraType}","attributes": {"attribute": [{"name": "Velocidade","value": "${VELOCIDADE_DOWN} MBPS","action": "${action}"},{"name": "Download","value": "${VELOCIDADE_DOWN}","action": "${action}"},{"name": "Upload","value": "${VELOCIDADE_UP}","action": "${action}"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${VELOCIDADE_DOWN}MBPS","action": "${action}"},{"name": "ValorProduto","value": "${VELOCIDADE_UP}.00","action": "${action}"},{"name": "ExibicaoFatura","value": "1","action": "${action}"},{"name": "DescricaoFatura","value": "Oi Fibra ${VELOCIDADE_DOWN}MB","action": "${action}"},{"name": "PrecoCap","value": "109.00","action": "${action}"},{"name": "Ativo","value": "1","action": "${action}"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "${action}"}]}},{"type": "VoIP","catalogId": "VoIP","name": "VoIP","action": "${action}","technology": "${infraType}","attributes": {"attribute": [{"name": "Numero VoIP","value": "${numeroVoip}","action": "${action}"}]}}]}}
    
    END

    ${ResponseCode}                         Get Value from Json                     ${Response}                             $.control.code
    ${ResponseMessage}=                     Get Value From Json                     ${Response}                             $.control.message

    Valida Retorno da API                   ${Response_Code[0]}                     200                                     Criar Ordem de retirada
#===================================================================================================================================================================


