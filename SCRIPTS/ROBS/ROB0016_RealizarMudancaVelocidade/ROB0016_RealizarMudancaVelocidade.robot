*** Settings ***
Documentation                               Mudança de Velocidade
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot

Library    RPA.Windows

*** Variables ***
#${DAT_CENARIO}                              C:/IBM_VTAL/DATA/DAT0009_RealizarMudancaVelocidadeSemPendencia.xlsx

#*** Test Cases ***
#Muda Velocidade
    #Mudando Velocidade


*** Keywords ***


#===================================================================================================================================================================
Mudar Velocidade
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo de mudar a velocidade criando
    ...                                     uma novo Order_Id no sistema SOM.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/productOrdering/v2/productOrder ``. |

    
    [Arguments]                             ${Complements_true_false}=false         ${Voip_true_false}=false                ${CatalogADD}=1000                      ${CatalogREMOVE}=400
    
    [Tags]                                  MudarVelocidade

    #Address
    ${ADDRESS_ID}                            Ler Variavel na Planilha                addressId                               Global
    ${INVENTORYID}                          Ler Variavel na Planilha                inventoryId                             Global
    ${Reference}                            Ler Variavel na Planilha                Reference                               Global

    IF    "${Complements_true_false}" != "false"
        
        ${jsonComplements}=                 Create List
        Set Global Variable                 ${jsonComplements}

        FOR    ${x}    IN RANGE    2
            
            ${x}=                           Evaluate                                ${x}+1

            &{complements}=                 Create Dictionary
            Set Global Variable             ${complements}
           
            ${typeComplement}=              Ler Variavel na Planilha                typeComplement${x}                      Global
            ${valueComplement}=             Ler Variavel na Planilha                value${x}                               Global

            Set Global Variable             ${typeComplement}
            Set Global Variable             ${valueComplement}

            IF    "${typeComplement}" != "None"   
                
                Set To Dictionary           ${complements}                          type=${typeComplement}
                Set To Dictionary           ${complements}                          value=${valueComplement}
                Append To List              ${jsonComplements}                      ${complements}
                ${jsonComplements}=         Convert JSON To String                  ${jsonComplements}
            END
            
        END

        IF    "${Voip_true_false}" != "false"
            
            
            ${DATE}=                            Get Current Date                        increment=3 hours                                   result_format=%Y-%m-%dT%H:%M:%S-03:00

            ${CORRELATIONORDER}=                Get Current Date                        result_format=%m%d%H%M%S
            ${CORRELATIONORDER}=                Set Variable                            ibm${CORRELATIONORDER}   
        
            Escrever Variavel na Planilha       ${CORRELATIONORDER}                     associatedDocument                                 Global
            ${CORRELATIONORDER}=                Set Variable                            COS${CORRELATIONORDER} 
            Escrever Variavel na Planilha       ${CORRELATIONORDER}                     correlationOrder                                    Global
            Escrever Variavel na Planilha       ${DATE}                                 associatedDocumentDate                              Global

            ${ASSOCIATEDDOCUMENT}=              Ler Variavel na Planilha                associatedDocument                                  Global
            ${ASSOCIATEDDOCUMENTDATE}=          Ler Variavel na Planilha                associatedDocumentDate                              Global
            ${NAME}=                            Ler Variavel na Planilha                customerName                                        Global
            ${SUBSCRIBERID}=                    Ler Variavel na Planilha                subscriberId                                        Global
            ${PHONENUMBER}=                     Ler Variavel na Planilha                phoneNumber                                         Global
            ${ADDRESS_ID}=                       Ler Variavel na Planilha                addressId                                           Global
            ${INVENTORYID}=                     Ler Variavel na Planilha                inventoryId                                         Global
            ${BAIRRO}=                          Ler Variavel na Planilha                Bairro                                              Global
            ${CEP}=                             Ler Variavel na Planilha                Address                                             Global
            ${ESTADO}=                          Ler Variavel na Planilha                UF                                                  Global
            ${CIDADE}=                          Ler Variavel na Planilha                Cidade                                              Global
            ${RUA}=                             Ler Variavel na Planilha                addressName                                         Global
            ${NUMBER}=                          Ler Variavel na Planilha                Number                                              Global
            ${TIPORUA}=                         Ler Variavel na Planilha                typeLogradouro                                      Global
            ${TYPECOMPLEMENT}=                  Ler Variavel na Planilha                typeComplement1                                     Global
            ${VALUE1}=                          Ler Variavel na Planilha                value1                                              Global
            ${LOCATIONCODE}=                    Ler Variavel na Planilha                LocationCode                                        Global
            ${DOCN}=                            Ler Variavel na Planilha                document                                            Global
            ${DESCRIPTION}=                     Ler Variavel na Planilha                Description                                         Global
            ${STATE}=                           Ler Variavel na Planilha                State                                               Global
            ${LOCABR}=                          Ler Variavel na Planilha                Abbreviation                                        Global
            ${INFRATYPE}=                       Ler Variavel na Planilha                infraType                                           Global

            ${UploadRemove}=                    Evaluate                                ${CatalogREMOVE}/2
            ${UploadRemove}=                    Convert To String                       ${UploadRemove}
            ${UploadRemove}=                    Split String                            ${UploadRemove}                                    .
            ${UploadAdd}=                       Evaluate                                ${CatalogADD}/2
            ${UploadAdd}=                       Convert To String                       ${UploadAdd}
            ${UploadAdd}=                       Split String                            ${UploadAdd}                                        .

            ${UploadRemove}=                    Set Variable                            ${UploadRemove[0]}    
            ${UploadAdd}=                       Set Variable                            ${UploadAdd[0]}

            ${RESPONSE}=                        POST_API                                ${API_BASECPOI}/productOrder                        "order": {"comOrderService": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "Modificacao de Velocidade","activityType": "05051","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","document": "${DOCN}","businessUnity": "empresarial","fantasyName": "InterCorp Internet","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}"]}},"appointment": null,"addresses": {"address": [{"id": ${ADDRESS_ID},"inventoryId": "${INVENTORYID}","action": "adicionar","neighborhood": "${BAIRRO}","zipCode": "${CEP}","locationCode": "${LOCATIONCODE}","description": "${DESCRIPTION}","state": "${STATE}","location": "${CIDADE}","streetName": "${RUA}","city": "${CIDADE}","number": "${NUMBER}","locationAbbreviation": "${LOCABR}","hasNumber": true,"streetType": "${TIPORUA}","streetTitle": "","stateAbbreviation": "${ESTADO}","complement": {"complements": [{"type": "${TYPECOMPLEMENT}","value": "${VALUE1}"}]}}]},"products": {"product": [{"type": "Banda Larga","catalogId": "BL_${CatalogREMOVE}MB","name": "VELOC_${CatalogREMOVE}MBPS","action": "remover","technology": "${INFRATYPE}","attributes": {"attribute": [{"name": "Velocidade","value": "${CatalogREMOVE} MBPS","action": "remover"},{"name": "Download","value": "${CatalogREMOVE}","action": "remover"},{"name": "Upload","value": "${UploadRemove}","action": "remover"},{"name": "Descricao","value": "Internet de alta velocidade (Fibra) com 400MBPS","action": "remover"},{"name": "ValorProduto","value": "${CatalogREMOVE}","action": "remover"},{"name": "ExibicaoFatura","value": "1","action": "remover"},{"name": "DescricaoFatura","value": "Oi Fibra ${CatalogREMOVE}MB","action": "remover"},{"name": "PrecoCap","value": "109.00","action": "remover"},{"name": "Ativo","value": "1","action": "remover"},{"name": "ModeloCobranca","value": "Pre-Pago","action": "remover"}]}},{"type": "Banda Larga","catalogId": "BL_${CatalogADD}MB","name": "VELOC_${CatalogADD}MBPS","action": "adicionar","technology": "${INFRATYPE}","attributes": {"attribute": [{"name": "Velocidade","value":"${CatalogADD} MBPS","action": "adicionar"},{"name": "Download","value": "${CatalogADD}", "action": "adicionar"},{"name": "Upload","value":"${UploadAdd}","action":"adicionar"},{"name":"Descricao","value":"Internet de alta velocidade (Fibra) com ${CatalogADD}MBPS","action":"adicionar"},{"name":"ValorProduto","value":"${CatalogADD}","action":"adicionar"},{"name":"ExibicaoFatura","value":"1","action":"adicionar"},{"name":"DescricaoFatura","value":"Oi Fibra ${CatalogADD}MB","action":"adicionar"},{"name":"PrecoCap","value":"109.00","action":"adicionar"},{"name":"Ativo","value":"1","action":"adicionar"},{"name":"ModeloCobranca","value":"Pre-Pago","action":"adicionar"}]}}]}}
            ${RESCODE}=                         Get Value From Json                     ${RESPONSE}                                         $.control.code


            Should Be Equal As Strings          ${RESCODE[0]}                           200

        ELSE

            ${date}=                                Get Current Date                        increment=3 hours                       result_format=%Y-%m-%dT%H:%M:%S-03:00
            ${validateDate}=                        Get Current Date                        increment=3 hours                       result_format=%d/%m/%Y %H:%M:%S


            ${CORRELATIONORDER}=                    Get Current Date                        result_format=%m%d%H%M%S
            ${CORRELATIONORDER}=                    Set Variable                            ibm${CORRELATIONORDER}   
        
            Escrever Variavel na Planilha           ${CORRELATIONORDER}                     associatedDocument                      Global
            Escrever Variavel na Planilha           ${CORRELATIONORDER}                     correlationOrder                        Global
            Escrever Variavel na Planilha           ${date}                                 associatedDocumentDate                  Global
            Escrever Variavel na Planilha           ${validateDate}                         validateDate                            Global

            ${CORRELATIONORDER}                     Ler Variavel na Planilha                correlationOrder                        Global
            ${ASSOCIATEDDOCUMENT}                   Ler Variavel na Planilha                associatedDocument                      Global
            ${ASSOCIATEDDOCUMENTDATE}               Ler Variavel na Planilha                associatedDocumentDate                  Global
            ${Type}                                 Ler Variavel na Planilha                Type                                    Global           
            ${InfraType}                            Ler Variavel na Planilha                infraType                               Global   

            #Customer
            ${NAME}                                 Ler Variavel na Planilha                customerName                            Global
            ${SUBSCRIBERID}                         Ler Variavel na Planilha                subscriberId                            Global                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 # Deve ser diferente em cada execucao
            ${PHONENUMBER}                          Ler Variavel na Planilha                phoneNumber                             Global
            ${BUSINESSUNITY}                        Ler Variavel na Planilha                BusinessUnity                           Global
            ${FANTASYNAME}                          Ler Variavel na Planilha                FantasyName                             Global       


            ${Response}=                    POST_API                                ${API_BASEPRODUCTORDERING}/productOrder                               "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BUSINESSUNITY}","fantasyName": "${FANTASYNAME}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}","complement": {"complements": ${jsonComplements}}}},"products": {"product": [{"catalogId": "BL_${CatalogADD}MB","action": "adicionar"},{"catalogId": "BL_${CatalogREMOVE}MB","action": "remover"}]}}                   
            Set Global Variable             ${Response}
        END    
    

    ELSE
        ${Response}=                        POST_API                                ${API_BASEPRODUCTORDERING}/productOrder                               "order": {"correlationOrder": "${CORRELATIONORDER}","associatedDocument": "${ASSOCIATEDDOCUMENT}","associatedDocumentDate": "${ASSOCIATEDDOCUMENTDATE}","type": "${Type}","infraType": "${InfraType}","customer": {"name": "${NAME}","subscriberId": "${SUBSCRIBERID}","businessUnity": "${BUSINESSUNITY}","fantasyName": "${FANTASYNAME}","phoneNumber": {"phoneNumbers": ["${PHONENUMBER}","",""]}},"addresses": {"address": {"id": "${ADDRESS_ID}","inventoryId": "${INVENTORYID}","reference": "${Reference}"}},"products": {"product": [{"catalogId": "BL_${CatalogADD}MB","action": "adicionar"},{"catalogId": "BL_${CatalogREMOVE}MB","action": "remover"}]}}                   
        Set Global Variable                 ${Response}
    END


    IF    "${Voip_true_false}" == "false"
        ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code         
        ${returnedMessage}=                     Get Value From Json                     ${Response}                             $.control.message
        ${returnedOrderId}=                     Get Value From Json                     ${Response}                             $.order.id

        Escrever Variavel na Planilha           ${returnedOrderId[0]}                   somOrderId                              Global
    
        Should Be Equal As Strings              ${returnedCode[0]}                      201
        Should Be Equal As Strings              ${returnedMessage[0]}                   Created
    

        IF    ${returnedOrderId[0]} == ""
        
            Log To Console                      OrderId não retornada.

        ELSE
        
            Log To Console                      OrderId retornada.

        END
  
    END

#===================================================================================================================================================================