*** Settings ***
Documentation                               Consulta Logradouro

Resource                                    ../../RESOURCE/API/RES_API.robot
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/COMMON/RES_EXCEL.robot


*** Variables ***

${ADDRESS}
${NUMBER}


*** Keywords ***
Consulta Id Logradouro
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via GET com o objetivo retornar o Address ID.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/geographicAddressManagement/v1/geographicAddress?address=``.|
    
    [Tags]                                  ConsultaIdLogradouro
    Retornar Address Id
    #Consultar Complements

Consulta Id Logradouro com Id Complements
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via GET com o objetivo retornar o Address ID e o Id Complements.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/geographicAddressManagement/v1/geographicAddress?address=``.|

    [Tags]                                  ConsultaIdLogradouroIdComplements
    Retornar Address Id
    Id Consulta Complemento  
#===================================================================================================================================================================
Retornar Address Id
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via GET com o objetivo retornar o Address ID, armazenar
    ...                                     e escrever dados na DAT relativa ao cenário.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/geographicAddressManagement/v1/geographicAddress?address=``.|


    [Tags]                                  RetornarAddressId

    ${ADDRESS}=                             Ler Variavel na Planilha                Address                                 Global
    ${NUMBER}=                              Ler Variavel na Planilha                Number                                  Global
 
    ${Response}=                            GET_API                                 ${API_BASEGEOGRAPHICADDRES}/geographicAddress?address=${ADDRESS}&number=${NUMBER}

    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Address Id
    
    ${typeLogradouro}=                      Get Value From Json                     ${Response.json()}                      $.addresses.address[0].streetType
    ${streetName}=                          Get Value From Json                     ${Response.json()}                      $.addresses.address[0].streetName
    ${uf_logradouro}=                       Get Value From Json                     ${Response.json()}                      $.addresses.address[0].stateAbbreviation
    ${cidade_logradouro}=                   Get Value From Json                     ${Response.json()}                      $.addresses.address[0].city
    ${bairro_logradouro}=                   Get Value From Json                     ${Response.json()}                      $.addresses.address[0].neighborhood
    
    Escrever Variavel na Planilha           ${typeLogradouro[0]}                    typeLogradouro                         Global
    Escrever Variavel na Planilha           ${streetName[0]}                        addressName                            Global
    Escrever Variavel na Planilha           ${uf_logradouro[0]}                     UF                                      Global
    Escrever Variavel na Planilha           ${cidade_logradouro[0]}                 Cidade                                  Global 
    Escrever Variavel na Planilha           ${bairro_logradouro[0]}                 Bairro                                  Global 


    ${AddressId}=                           Get Value From Json                     ${Response.json()}                      $.addresses.address[0].id
    Escrever Variavel na Planilha           ${AddressId[0]}                         addressId                               Global
    



#===================================================================================================================================================================
Consultar Complements
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via GET com o objetivo de consultar os complementos do 
    ...                                     endereço atráves do Address Id lendo a informação da DAT.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/geographicAddressManagement/v1/addressComplements/``.|



    [Tags]                                  ConsultaComplementoEndereco


    ${Address-ID}=                          Ler Variavel na Planilha                addressId                              Global

    ${Response}=                            GET_API                                 ${API_BASEGEOGRAPHICADDRES}/addressComplements/${Address-ID}

    


    @{returnedComplements}=                 Get Value From Json                     ${Response.json()}                      $.complementList

    FOR    ${element}    IN    @{returnedComplements[0]}

        ${auxElement}=                      Get Value From Json                     ${element}                              $.complement
        
        IF    "${auxElement[0]}"==""
            ${auxElement}=                  Convert To String                       None
        ELSE
            @{auxComplements}=              Get Value From Json                     ${element}                              $.complement.complements

            ${ncomp}=                       Convert To Integer                      0
            ${add1}=                        Convert To Integer                      1

            FOR    ${element2}    IN    @{auxComplements[0]}
                ${auxElement}=              Get Value From Json                     ${element2}                             $.type
                ${value}=                   Get Value From Json                     ${element2}                             $.value

                ${ncomp}=                   Evaluate                                ${ncomp}+${add1}

                Escrever Variavel na Planilha                                       ${auxElement[0]}                        typeComplement${nComp}                  Global
                Escrever Variavel na Planilha                                       ${value[0]}                             value${nComp}                           Global
            END
        END
    END

#===================================================================================================================================================================
Id Consulta Complemento

    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via GET com o objetivo de retornar os complementos do 
    ...                                     endereço atráves do Address Id lendo a informação da DAT
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/geographicAddressManagement/v1/addressComplements/``.|


    [Tags]                                  ConsultaComplemento

    Retornar Address Id

    ${AddressId}=                           Ler Variavel na Planilha                addressId                              Global

    ${Response}=                            GET_API                                 ${API_BASEGEOGRAPHICADDRES}/addressComplements/${AddressId}

    @{returnedComplementos}=                Get Value From Json                     ${Response.json()}                      $.complementList

    FOR    ${element}    IN    @{returnedComplementos[0]}

        ${auxElement}=                      Get Value From Json                     ${element}                              $.complement
        
        IF    "${auxElement[0]}"==""
            ${auxElement}=                  Convert To String                       None
        ELSE
            @{auxComplements}=              Get Value From Json                     ${element}                              $.complement.complements

            ${ncomp}=                       Convert To Integer                      0
            ${add1}=                        Convert To Integer                      1

            FOR    ${element2}    IN    @{auxComplements[0]}
                ${auxElement}=              Get Value From Json                     ${element2}                             $.type
                ${value}=                   Get Value From Json                     ${element2}                             $.value

                ${ncomp}=                   Evaluate                                ${ncomp}+${add1}

                Escrever Variavel na Planilha                                       ${auxElement[0]}                        typeComplement${nComp}                  Global
                Escrever Variavel na Planilha                                       ${value[0]}                             value${nComp}                           Global

            END
        END
    END

    @{returnedComplementos}=                Get Value From Json                     ${Response.json()}                      $.complementList.[0].id

    ${IdComplements}                        Convert To Integer                      @{returnedComplementos}

    Escrever Variavel na Planilha           ${IdComplements}                        idComplements                           Global      

#===================================================================================================================================================================
Consulta Logradouro CPOi
    [Documentation]                         Função usada para iniciar a API, permitindo assim fazer as requests via GET com o objetivo retornar o Address ID, armazenar
    ...                                     e escrever dados na DAT relativa ao cenário.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. ``https://apitrg.vtal.com.br/api/geographicAddressManagement/v1/geographicAddress?address=``.|

    ${ADDRESS}=                             Ler Variavel na Planilha                Address                                 Global
    ${NUMBER}=                              Ler Variavel na Planilha                Number                                  Global
 
    ${Response}=                            GET_API                                 ${API_BASEGEOGRAPHICADDRES}/geographicAddress?address=${ADDRESS}&number=${NUMBER}

    Valida Retorno da API                   ${Response.status_code}                 200                                     Retornar Address Id
    
    ${typeLogradouro}=                      Get Value From Json                     ${Response.json()}                      $.addresses.address[0].streetType
    ${streetName}=                          Get Value From Json                     ${Response.json()}                      $.addresses.address[0].streetName
    ${uf_logradouro}=                       Get Value From Json                     ${Response.json()}                      $.addresses.address[0].stateAbbreviation
    ${cidade_logradouro}=                   Get Value From Json                     ${Response.json()}                      $.addresses.address[0].city
    ${bairro_logradouro}=                   Get Value From Json                     ${Response.json()}                      $.addresses.address[0].neighborhood

    ${description_logradouro}=              Get Value From Json                     ${Response.json()}                      $.addresses.address[0].description
    ${codigo_localidade}=                   Get Value From Json                     ${Response.json()}                      $.addresses.address[0].locationCode
    ${cidade_abreviada}=                    Get Value From Json                     ${Response.json()}                      $.addresses.address[0].locationAbbreviation
    ${STATE}                                Get Value From Json                     ${Response.json()}                      $.addresses.address[0].state
    

    Escrever Variavel na Planilha           ${typeLogradouro[0]}                    typeLogradouro                         Global
    Escrever Variavel na Planilha           ${streetName[0]}                        addressName                            Global
    Escrever Variavel na Planilha           ${uf_logradouro[0]}                     UF                                      Global
    Escrever Variavel na Planilha           ${cidade_logradouro[0]}                 Cidade                                  Global 
    Escrever Variavel na Planilha           ${bairro_logradouro[0]}                 Bairro                                  Global

    Escrever Variavel na Planilha           ${description_logradouro[0]}            Description                             Global
    Escrever Variavel na Planilha           ${codigo_localidade[0]}                 LocationCode                            Global
    Escrever Variavel na Planilha           ${cidade_abreviada[0]}                  Abbreviation                            Global
    Escrever Variavel na Planilha           ${STATE[0]}                             State                                   Global

    ${AddressId}=                           Get Value From Json                     ${Response.json()}                      $.addresses.address[0].id
    Escrever Variavel na Planilha           ${AddressId[0]}                         addressId                              Global
    
#===================================================================================================================================================================
Consultar Logradouro LocGeografica
    [Arguments]                             ${Complemento_True_False}=False                                                
    [Documentation]                         consultar Logradouro por Localização Geográfica
    
    ${LONGITUDE}=                           Ler Variavel na Planilha               Longitude                                Global
    ${LATIDUDE}=                            Ler Variavel na Planilha               Latitude                                 Global
    
    ${STATE}=                               Evaluate                               False                           
    Set Global Variable                     ${STATE}

    FOR    ${counter}    IN RANGE    5    35    5
        
        ${RESPONSE}=                            GET_API                                 ${API_BASEGEOGRAPHICADDRES}/geographicLocation?latitude=${LATIDUDE}&longitude=${LONGITUDE}&radius=${counter}
        ${code}=                                Get Value From Json                     ${RESPONSE.json()}                  $.control.code
        ${List_Address}=                       Get Value From Json                    ${RESPONSE.json()}                 $.addresses.address.[0].id
        

        IF    "${code[0]}" == "200" and ${List_Address} != []
            ${List_Address}=                    Get Value From Json                     ${RESPONSE.json()}                  $.addresses.address
            Set Global Variable                 ${List_Address}
            ${STATE}=                           Evaluate                                True
            Exit For Loop
        END   
    END

    Run Keyword If    "${STATE}" != "True"
    ...    Fatal Error                A api testou todos os raios e não encontrou resultados.
    
    ${STATE}=                               Evaluate                               False                           

    FOR    ${element}    IN    ${List_Address[0]}
        
        IF    "${Complemento_True_False}" == "False"
            ${AddressId}=                   Get Value From Json                      ${element[0]}                              $.id
            Escrever Variavel na Planilha           ${AddressId[0]}                  addressId                                  Global
            Consultar Complements
            ${comp}=                        Ler Variavel na Planilha                 typeComplement1                            Global
            IF    "${comp}" == "None"
                ${typeLogradouro}=                      Get Value From Json                     ${element[0]}                      $.streetType
                ${streetName}=                          Get Value From Json                     ${element[0]}                      $.streetName
                ${uf_logradouro}=                       Get Value From Json                     ${element[0]}                      $.stateAbbreviation
                ${cidade_logradouro}=                   Get Value From Json                     ${element[0]}                      $.city
                ${bairro_logradouro}=                   Get Value From Json                     ${element[0]}                      $.neighborhood
                ${number}=                              Get Value From Json                     ${element[0]}                      $.number
                ${cep}=                                 Get Value From Json                     ${element[0]}                      $.zipCode

                Escrever Variavel na Planilha           ${typeLogradouro[0]}                    typeLogradouro                         Global
                Escrever Variavel na Planilha           ${streetName[0]}                        addressName                            Global
                Escrever Variavel na Planilha           ${uf_logradouro[0]}                     UF                                      Global
                Escrever Variavel na Planilha           ${cidade_logradouro[0]}                 Cidade                                  Global 
                Escrever Variavel na Planilha           ${bairro_logradouro[0]}                 Bairro                                  Global 
                Escrever Variavel na Planilha           ${number[0]}                            Number                                  Global 
                Escrever Variavel na Planilha           ${cep[0]}                               Address                                 Global

                ${AddressId}=                           Get Value From Json                     ${element[0]}                      $.id
                Escrever Variavel na Planilha           ${AddressId[0]}                         addressId                              Global
                ${STATE}=                               Evaluate                                True                            
                Exit For Loop
            END
        ELSE
            ${AddressId}=                   Get Value From Json                      ${element[0]}                              $.id
            Escrever Variavel na Planilha           ${AddressId[0]}                  addressId                                Global
            Consultar Complements
            ${comp}=                        Ler Variavel na Planilha                 typeComplement1                         Global
            IF    "${comp}" != "None"
                ${typeLogradouro}=                      Get Value From Json                     ${element[0]}                      $.streetType
                ${streetName}=                          Get Value From Json                     ${element[0]}                      $.streetName
                ${uf_logradouro}=                       Get Value From Json                     ${element[0]}                      $.stateAbbreviation
                ${cidade_logradouro}=                   Get Value From Json                     ${element[0]}                      $.city
                ${bairro_logradouro}=                   Get Value From Json                     ${element[0]}                      $.neighborhood
                ${number}=                              Get Value From Json                     ${element[0]}                      $.number
                ${cep}=                                 Get Value From Json                     ${element[0]}                      $.zipCode

                Escrever Variavel na Planilha           ${typeLogradouro[0]}                    typeLogradouro                         Global
                Escrever Variavel na Planilha           ${streetName[0]}                        addressName                            Global
                Escrever Variavel na Planilha           ${uf_logradouro[0]}                     UF                                      Global
                Escrever Variavel na Planilha           ${cidade_logradouro[0]}                 Cidade                                  Global 
                Escrever Variavel na Planilha           ${bairro_logradouro[0]}                 Bairro                                  Global 
                Escrever Variavel na Planilha           ${number[0]}                            Number                                  Global 
                Escrever Variavel na Planilha           ${cep[0]}                               Address                                 Global 

                ${AddressId}=                           Get Value From Json                     ${element[0]}                      $.id
                Escrever Variavel na Planilha           ${AddressId[0]}                         addressId                              Global
                ${STATE}=                               Evaluate                                True                            
                Exit For Loop

            END
        END
        
    END

    Run Keyword If    "${STATE}" != "True"
    ...    Fatal Error                O argumento com/sem complemento, não foi satisfeito no retorno da API. Tente com outra localização geográfica.
    
#===================================================================================================================================================================



