*** Settings ***
Documentation                               Script para Abertura de Reparo BL + Voip

Library                                     String

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot


*** Keywords ***

Criar Ordem de Reparo Voip
    [Arguments]                             ${velocidadeDown}=400
    ...                                     ${velocidadeUp}=200
    [Documentation]                         Realiza a Criação de Reparo BL + Voip
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST sem complemento e com o objetivo retornar 
    ...                                     o troubleTicket_id, armazenar e escrever dados na DAT relativa ao cenário.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. |``https://apitrg.vtal.com.br/api/productOrdering/v1/productOrder``.|

    ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
    ${associatedDocumentDate}=              Set Variable                            ${date}
    ${associatedDocument}=                  Get Current Date                        result_format=%m%d%H%M%S
    ${associatedDocument}=                  Set Variable                            ibm${associatedDocument}
    ${comOrderService}=                     Set Variable                            COSibm${associatedDocument}
        
    Escrever Variavel na Planilha           ${associatedDocumentDate}               associatedDocumentDate                  Global
    Escrever Variavel na Planilha           ${associatedDocument}                   associatedDocument                      Global
    Escrever Variavel na Planilha           ${comOrderService}                      comOrderService                         Global

    ${dayPeriod}=                           Get Current Date                        increment=1 day 10 minutes              result_format=%Y-%m-%dT%H:%M:%S
    ${data}=                                Get Current Date                        result_format=%d/%m/%Y
    ${hora}=                                Get Current Date                        result_format=%H:%M

    ${appointmentStart}=                    Set Variable                            ${date}T08:00:00
    ${appointmentFinish}=                   Set Variable                            ${date}T12:00:00

    ${activityType}=                        Set Variable                            4934
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${customerName}=                        Ler Variavel na Planilha                customerName                            Global
    ${document}=                            Ler Variavel na Planilha                document                                Global
    ${adress_id}=                           Ler Variavel na Planilha                addressId                               Global
    ${invetory_id}=                         Ler Variavel na Planilha                inventoryId                             Global
    ${bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    ${cep}=                                 Ler Variavel na Planilha                Address                                 Global
    ${locationCode}=                        Ler Variavel na Planilha                locationCode                            Global
    ${enderecoCompleto}=                    Ler Variavel na Planilha                Description                             Global
    ${estado}=                              Ler Variavel na Planilha                State                                   Global
    ${cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    ${logradouro}=                          Ler Variavel na Planilha                addressName                             Global
    ${numero}=                              Ler Variavel na Planilha                Number                                  Global
    ${locationAbbreviation}=                Ler Variavel na Planilha                Abbreviation                            Global
    ${typeLogradouro}=                      Ler Variavel na Planilha                typeLogradouro                          Global
    ${UF}=                                  Ler Variavel na Planilha                UF                                      Global

    ${problemCode}=                         Set Variable                            6B200FB
    ${techCode}=                            Ler Variavel na Planilha                trTecnico                               Global

    ${Response}=                            POST_API                                ${API_BASECPOI}/productOrder            "order": {"comOrderService": "${comOrderService}","associatedDocument": "${associatedDocument}","associatedDocumentDate": "${associatedDocumentDate}","type": "Reparo","activityType": "${activityType}","customer": {"name": "${customerName}","subscriberId": "${subscriberId}","document": "${document}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["21999999999"]}},"appointment": {"hasSlot": "true","mandatoryType": "Permitido","dayPeriod": "${dayPeriod}","appointmentStart": "${appointmentStart}","appointmentFinish": "${appointmentFinish}","startPromiseDate": "${appointmentStart}","finishPromiseDate": "${appointmentFinish}"},"addresses": {"address": [{"id": "${adress_id}","inventoryId": "${invetory_id}","action": "reparar","neighborhood": "${bairro}","zipCode": "${cep}","locationCode": "${locationCode}","description": "${enderecoCompleto}","state": "${estado}","location": "${cidade}","streetName": "${logradouro}","city": "${cidade}","number": "${numero}","locationAbbreviation": "${locationAbbreviation}","hasNumber": "true","streetType": "${typeLogradouro}","streetTitle": "","stateAbbreviation": "${UF}"}]},"products": {"product": {"type": "Banda Larga","catalogId": "","name": "VELOC_${velocidadeDown}MBPS","action": "reparar","attributes": {"attribute": [{"name": "Velocidade","value": "${velocidadeDown} MBPS","action": "reparar"},{"name": "Download","value": "${velocidadeDown}","action": "reparar"},{"name": "Upload","value": "${velocidadeUp}","action": "reparar"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com ${velocidadeDown}MBPS","action": "reparar"},{"name": "ValorProduto","value": "${velocidadeDown}.00","action": "reparar"},{"name": "ExibicaoFatura","value": "1","action": "reparar"},{"name": "DescricaoFatura","value": "Oi Fibra ${velocidadeDown}MB","action": "reparar"},{"name": "PrecoCap","value": "109.00","action": "reparar"},{"name": "Ativo","value": "1","action": "reparar"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "reparar"}]}}},"workOrder": {"progType": "A","problemCode": "${problemCode}","start_date": "${data}","start_hour": "${hora}","priority": "01","techCode": "${techCode}","techArea": "FSA","activity": "TP2GP","activityType": "C","infoType": "SLF","due_data": "","due_hour": "","networkType": "Planta Externa","problem": "Problema123476","description": "Nome: Fulano de Ciclano/ GPON: A0000568O/ Reclamacao/checks: Nao Faz e Nao Recebe chamadas /Teste telefonico e Reboot sem sucesso / Aparelho e cabo ok.","problemDesc": "Teste reparo Shakeout"}}

    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.

    ELSE 
        Log to console    \n Criação do reparo realizada.
    END