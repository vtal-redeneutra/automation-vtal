*** Settings ***
Documentation                               Consultar Viabilidade

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot


*** Variables ***
${ADDRESS_ID}


*** Keywords ***
Retorna Viabilidade dos Produtos
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo de retornar a 
    ...                                     viabilidade técnica confirmada através do Address ID sem complemento.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/resourcePoolManagement/v2/availabilityCheck``. |
    [Tags]                                  ConsultaLogradouro

    Retorna Viabilidade Produtos
    Valida Banda Maxima



Retorna Viabilidade dos Produtos Bitstream
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo de retornar a 
    ...                                     viabilidade técnica confirmada através do Address ID sem complemento.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/resourcePoolManagement/v2/availabilityCheck``. |

    Retorna Viabilidade Produtos
    Valida Banda Maxima
    Valida Viabilidade Bitstream


#===================================================================================================================================================================
Retorna Viabilidade Produtos
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as outras requests via POST com o objetivo de retornar a 
    ...                                     viabilidade técnica confirmada através do Address ID sem complemento.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. Exemplo: ``https://apitrg.vtal.com.br/api/resourcePoolManagement/v2/availabilityCheck``. |
    [Arguments]                             ${RETORNO_ESPERADO}=Viável – Viabilidade técnica confirmada

    ${ADDRESS_ID}=                          Ler Variavel na Planilha                addressId                               Global

    ${type1}=                               Ler Variavel na Planilha                typeComplement1                         Global
    ${type2}=                               Ler Variavel na Planilha                typeComplement2                         Global
    ${type3}=                               Ler Variavel na Planilha                typeComplement3                         Global

    ${value1}=                              Ler Variavel na Planilha                value1                                  Global
    ${value2}=                              Ler Variavel na Planilha                value2                                  Global
    ${value3}=                              Ler Variavel na Planilha                value3                                  Global

    # Caso possua complemento, verificação de viabilidade passa no máximo 3 parametros
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
            ${Response}=                    POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck    "address":{"id": "${ADDRESS_ID}","complement":{"complements":[{"type":"${type1}","value":"${value1}"}]}}
            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 2
            ${Response}=                    POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck    "address":{"id": "${ADDRESS_ID}","complement":{"complements":[{"type":"${type1}","value":"${value1}"},{"type":"${type2}","value":"${value2}"}]}}
            Set Global Variable             ${Response}
        END

        IF    ${qntdComp} == 3
            ${Response}=                    POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck    "address":{"id": "${ADDRESS_ID}","complement":{"complements":[{"type":"${type1}","value":"${value1}"},{"type":"${type2}","value":"${value2}"},{"type":"${type3}","value":"${value3}"}]}}
            Set Global Variable             ${Response}
        END

    ELSE
        #Endereço sem complemento realiza a consulta somente por ID
        ${Response}=                        POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck    "address":{"id": "${ADDRESS_ID}"}
        Set Global Variable                 ${Response}
    END

    ${Response_Code}                        Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     200                                     Retorna Viabilidade Produtos

    ${AvailabilityDescription}              Get Value from Json                     ${Response}                             $.resource.availabilityDescription
    Set Global Variable                     ${AvailabilityDescription}

    ${InventoryId}                          Get Value from Json                     ${Response}                             $.resource.inventoryId
    Set Global Variable                     ${InventoryId} 
    
    # Dados serão atualizados com sucesso na DAT somente se o Json de retorno possuir a informação viável, do contrário, os dados de erro serão salvos.
    IF  "${AvailabilityDescription[0]}" == "${RETORNO_ESPERADO}"
        Escrever Variavel na Planilha       ${InventoryId[0]}                       inventoryId                            Global
        Escrever Variavel na Planilha       ${AvailabilityDescription[0]}           availabilityDescription                Global
    ELSE
        IF    "${AvailabilityDescription[0]}" == "Viável com obra – CDO(s) sem porta livre e em célula disponível"
            Escrever Variavel na Planilha   ${InventoryId[0]}                       inventoryId                          Global
            Escrever Variavel na Planilha   ${AvailabilityDescription[0]}           availabilityDescription              Global
        ELSE
            Escrever Variavel na Planilha   ${InventoryId[0]}                       inventoryId                            Global
            Escrever Variavel na Planilha   ${AvailabilityDescription[0]}           availabilityDescription                Global
        END
    END

#===================================================================================================================================================================
Retorna Banda Maxima
    [Arguments]                             ${MAX_BAND}
    [Documentation]                         Função usada para armazenar e escrever dados na DAT relativa ao cenário.

    Escrever Variavel na Planilha           ${MAX_BAND}                             maxBandWidth                            Global

#===================================================================================================================================================================
Valida Banda Maxima
    [Arguments]                             ${Complements_true_false}=false
    [Documentation]                         Função que valida e trata se o status é compativel ou não como ``Viável – Viabilidade técnica confirmada`` dessa forma,
    ...                                     habilita-se o retorno da Banda Máxima.
   
    IF    "${AvailabilityDescription[0]}" == "Viável – Viabilidade técnica confirmada" or "${AvailabilityDescription[0]}" == "Viável com obra - Survey sem CDO e em célula disponível"
        
        ${HighestBand}=                     Get Value From Json                     ${Response}                             $.resource.maxBandwidth
        ${HighestBand}=                     Convert To Integer                      ${HighestBand[0]}
        @{Bands}=                           Get Value From Json                     ${Response}                             $.resource.products.product
    
        FOR    ${element}    IN    @{Bands[0]}     
            ${velocity}=                    Get Value From Json                     ${element}    $.catalogId

            IF  "${velocity[0]}"=="VoIP"       CONTINUE

            ${velocity}=                    Split String                            ${velocity[0]}    _
            ${velocity}=                    Split String                            ${velocity[1]}    M
            ${velocity}=                    Convert To Integer                      ${velocity[0]}
            
            IF    ${velocity} > ${HighestBand}
                ${HighestBand}=             ${velocity}
                Retorna Banda Maxima        ${HighestBand}
            ELSE
                Retorna Banda Maxima        ${HighestBand}
            END
        END    
    ELSE
     
        Fatal Error                         Não foi possível encontrar a Banda Máxima devido inviabilidade do endereço.

    END

#===================================================================================================================================================================
Viabilidade Fora de Cobertura
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo de retornar a
    ...                                     viabilidade fora de cobertura.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/resourcePoolManagement/v2/availabilityCheck``. |

    [Tags]                                  ViabilidadeForaCobertura
    [Arguments]                             ${Complements_true_false}=false

    ${IdComplements}=                       Ler Variavel na Planilha                idComplements                           Global

    IF    "${Complements_true_false}" == "false"
        ${Response}=                        POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck      "customer": {"subscriberId": ""},"address": {"id": "${IdComplements}"}
        Set Global Variable                 ${Response}
    ELSE

        ${Address_Id}=                      Ler Variavel na Planilha                addressId                              Global
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

        ${Response}=                        POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck      "customer": {"subscriberId": ""},"address": {"id": "${IdComplements}","complement": {"complements": ${jsonComplements}}}
        Set Global Variable                 ${Response}
    END 

    ${Response_Code}                        Get Value from Json                     ${Response}                             $.control.code

    Valida Retorno da API                   ${Response_Code[0]}                     401                                     Viabilidade Fora de Cobertura

    log To Console                          viabilidade técnica não autorizada

#===================================================================================================================================================================
Valida Viabilidade Bitstream

    [Documentation]                         
   
    IF    "${AvailabilityDescription[0]}" == "Viável – Viabilidade técnica confirmada" or "${AvailabilityDescription[0]}" == "Viável com obra - Survey sem CDO e em célula disponível"
        
        ${productClass}=                    Get Value From Json                     ${Response}                             $.resource.catalog.catalogItem.productClass
        ${installation}=                    Get Value From Json                     ${Response}                             $.resource.catalog.catalogItem.installation
    
        Should Be Equal As Strings          ${productClass[0]}                      BIT
        Should Be Equal As Strings          ${installation[0]}                      V.tal
        
    ELSE
        Fatal Error                         \nEndereço sem viabilidade
    END

#===================================================================================================================================================================
Consultar Viabilidade com Erro
    [Documentation]                     Espera retorno 400 com mensagem "Complemento obrigatório para o endereço informado."
    
    ${AddressId}=                           Ler Variavel na Planilha                addressId                              Global
    
    ${Response}=                            POST_API                                ${API_BASERESOURCEPOOL_V2}/availabilityCheck      "customer": {"subscriberId": ""},"address": {"id": "${AddressId}"}
    Set Global Variable                     ${Response}

    ${Code}=                                Get Value From Json                     ${Response}                             $.control.code
    ${Message}=                             Get Value From Json                     ${Response}                             $.control.message

    Should Be Equal As Strings              ${Code[0]}                              400
    Should Be Equal As Strings              ${Message[0]}                           Complemento obrigatorio para o endereco informado                ignore_case=True        collapse_spaces=True
    Escrever Variavel na Planilha           ${Code[0]}                              CodigoAPI                               Global
    Escrever Variavel na Planilha           ${Message[0]}                           MensagemAPI                             Global
    Log To Console                          Erro esperado foi retornado.