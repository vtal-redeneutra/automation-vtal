*** Settings ***
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     Browser

Resource                                    ../../RESOURCE/SOM/PAGE_OBJECTS.robot
Resource                                    ../../RESOURCE/SOM/VARIABLES.robot
Resource                                    ../COMMON/RES_UTIL.robot

*** Variable ***
@{NOMES_LINHA}                              Associar Equipamento                    T024 - Atualizar Equipamento            T025 - Confirmar Designacao             T026 - Notificar Encerramento de Ordem


*** Keywords ***

#===================================================================================================================================================================
Login SOM
    [Documentation]                         Realiza login no sistema SOM Ultilizando as variaveis da Param_Global, Usuario e senha    
    [TAGS]                                  Login SOM

    ${usuario_som}=                         Ler Variavel Param Global               $.Logins.SOM.Usuario                             
    ${senha_som}=                           Ler Variavel Param Global               $.Logins.SOM.Senha                               
    Set Test Variable                       ${usuario_som}

    Contexto para navegador                 ${URL_SOM}                                                        

    Wait For Elements State                 ${SOM_input_login}                      visible                                 timeout=${TIMEOUT}

    Input Text Web Element Is Visible       ${SOM_input_login}                      ${usuario_som}
    Input Text Web Element Is Visible       ${SOM_input_password}                   ${senha_som}
    Click Web Element Is Visible            ${SOM_btn_login}

#===================================================================================================================================================================
Altera Filtro Consulta Order ID
    [Arguments]                             ${AssociatedDocument_OR_SomID}=associatedDocument
    [Documentation]                         Altera o Filtro para preview e insere o valor Order_Id ou AssociatedDocument, ultilizando os dados da planilha, pra fazer a pesquisa.
    [TAGS]                                  ConsultaOrderID

    Wait For Elements State                 ${SOM_rb_Preview}                       visible                                 timeout=${TIMEOUT}
    Click Web Element Is Visible            ${SOM_rb_Preview}


    IF    "${AssociatedDocument_OR_SomID}" == "associatedDocument"
        
        ${Associated_Document}=             Ler Variavel na Planilha                associatedDocument                     Global
        Input Text Web Element Is Visible   (//*[@id="aazone.worklist"]/form/table/tbody/tr[1]/td/input[2])                 *${Associated_Document}*

    END

    Click Web Element Is Visible            ${SOM_btn_refresh}
    Sleep     3
    
#===================================================================================================================================================================
Valida OS Completa
    [Documentation]                         Função usada para Validar e fazer a consulta de um pedido concluido com sucesso das tabelas no Order ID no SOM
    [TAGS]                                  ValidaOSCompleta
    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${Associated_Document}
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    
    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é Completed
    ${order_state}=                         Get Text Element is Visible             ${SOM_order_state}
    IF  "${order_state}" != "Completed"
        Fatal Error                         Order State está diferente de Completed
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}

    ${Count_numero_linhas}=                 Get Length                              ${NOMES_LINHA}

    #For que pega os 4 itens que são esperados quando se completa a tarefa e Valida o Status, a descrição e o retorno da ultima tarefa da ordem, Esperado é Encerrado, Sucesso e o código 0000
    FOR     ${Count_nomes}      IN RANGE    ${Count_numero_linhas}

        ${STATUS_Tarefa}=                   Get Text Element is Visible Valida      //*[@value='${NOMES_LINHA[${Count_nomes}]}']${SOM_linha_Status}                 ==          Encerrado
        ${DESCRIÇÃO_tarefa}=                Get Text Element is Visible Valida      //*[@value='${NOMES_LINHA[${Count_nomes}]}']${SOM_linha_Descrição}              *=          sucesso
        
        IF  '${NOMES_LINHA[${Count_nomes}]}' == 'T026 - Notificar Encerramento de Ordem'
            ${COD_Retorno_Tarefa}=          Get Text Element is Visible Valida      //*[@value='${NOMES_LINHA[${Count_nomes}]}']${SOM_linha_retorno}                ==          0000
        END

    END

#===================================================================================================================================================================
Valida Mudanca de Velocidade 
    [Documentation]                         Função usada para validar a mudança de velocidade
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Valida Mudanca de Velocidade
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]
    [Tags]                                  ValidaMudancaDeVelocidadeSOM

    ${associated_document}=                 Ler Variavel na Planilha                associatedDocument                     Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${associated_document}
    Sleep                                   3
    Click Web Element Is Visible            ${SOM_btn_search}
    Click Web Element Is Visible            ${SOM_rb_Preview}   
    
    FOR    ${x}    IN RANGE    10
        ${order_state}=                     Get Text Element is Visible             ${SOM_order_state}
        IF  "${order_state}" != "Completed"
            Click Web Element Is Visible                                            ${SOM_btn_refresh}
            Sleep                           5
        ELSE
            BREAK
        END
        
        IF    ${x} == 10
            Fatal Error                     Order State está diferente de Completed
        END

    END

    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Mais de uma linha da tabela foi encontrada, o que não é comum.
    END

    
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}
    Wait For Elements State                 ${SOM_Ordem_numeroCOM}                  visible

#===================================================================================================================================================================
Valida OS Bloqueada
    [Arguments]                             ${VELOCIDADE}=1000                      ${FTTH_ou_FTTP}=FTTH
    [Documentation]                         Função usada para validar um pedido bloqueado
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``VELOCIDADE`` | Valor passado na hora de criar o pedido referente a qual velocidade o pedido vai ter, pego da planilha, 1000MBS é o valor padrão. |
    ...                                     | ``FTTH_ou_FTTP`` | Especifica para qual tipo foi criado o pedido, FTTH ou FTTP, FTTH é o valor padrão . |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Valida OS Bloqueada                   400                                     FTTP
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]
    [TAGS]                                  ValidaOSCompleta

    ${associated_document}=                 Ler Variavel na Planilha                associatedDocument                      Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${associated_document}
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}

    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "Completed"
            Log To Console                  Estado da Ordem está completa
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END

    END    

    #Valida o Status da type, esperado é Bloqueio
    ${order_type}=                          Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type}" != "Vtal Fibra Bloqueio"
        Fatal Error                         Order type está diferente de Bloqueio
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}

    ${Action}                               Ler Variavel na Planilha                Action                                  Global

    IF      "${Action}" == "bloquear parcial"
        Get Text Element is Visible Valida      ${SOM_bloq_045}                     ==                                      T045 - Bloquear Banda Larga - Parcial - NASS
    ELSE
        Get Text Element is Visible Valida      ${SOM_bloq_043}                     ==                                      T043 - Bloquear Banda Larga Total APC
    END
    
    Get Text Element is Visible Valida      ${SOM_Ordem_tipo}                       ==                                      Bloqueio 

    ${infraType}=                           Set Variable                            ${FTTH_ou_FTTP}
    #${correlationOrder}=                    Ler Variavel na Planilha                correlationOrder                       Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    # ${customerName}=                        Ler Variavel na Planilha                customerName                           Global
    ${addressId}=                           Ler Variavel na Planilha                addressId                              Global
    ${inventoryId}=                         Ler Variavel na Planilha                inventoryId                            Global
    ${tipoOrdem}=                           Set Variable                            Bloqueio    
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${data_abertura}=                       Ler Variavel na Planilha                validateDate                            Global
    # ${tpLogradouro}=                        Ler Variavel na Planilha                typeLogradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                addressName                            Global
    # ${numero}=                              Ler Variavel na Planilha                Number                                  Global
    # ${bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    # ${cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    # ${uf}=                                  Ler Variavel na Planilha                UF                                      Global
    # ${cep}=                                 Ler Variavel na Planilha                Address                                 Global
    # ${ref}=                                 Ler Variavel na Planilha                Reference                               Global

    Scroll To Element                       ${SOM_Ordem_numeroCOM}

    #${Ordem_numeroCOM}=                     Browser.Get Text                        ${SOM_Ordem_numeroCOM}
    ${Ordem_numeroPedido}=                  Browser.Get Text                        ${SOM_Ordem_numeroPedido}
    ${SOM_infra}=                           Browser.Get Text                        ${SOM_infraType}
    ${Ordem_tipo}=                          Browser.Get Text                        ${SOM_Ordem_tipo}
    # ${Cliente_nome}=                        Browser.Get Text                        ${SOM_Cliente_nome}
    
    Scroll To Element                       ${SOM_Endereco_id}
    
    ${Endereco_id}=                         Browser.Get Text                        ${SOM_Endereco_id}
    ${Endereco_inventory}=                  Browser.Get Text                        ${SOM_Endereco_inventory}
    ${Abertura_Pedido}=                     Browser.Get Text                        ${SOM_Ordem_dtAberturaPedido}
    ${Abertura_Pedido}=                     Get Substring                           ${Abertura_Pedido}                      0                                       16
    ${Origem_Ordem}=                        Browser.Get Text                        ${SOM_Origem_Solicitacao}
    # ${Empresa_Name}=                        Browser.Get Text                        ${SOM_Cliente_empresa}
    ${Contrato_Id}=                         Browser.Get Text                        ${SOM_Cliente_idContrato}
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    # ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    
    # FOR    ${x}    IN RANGE    3
    #     ${n}=                               Evaluate                                ${x}+1
    #     ${type_comp}=                       Ler Variavel na Planilha                TypeComplement${n}                      Global
        
    #     IF    "${type_comp}" != "None"
    #         ${comp_value}=                  Ler Variavel na Planilha                Value${n}                               Global

    #         ${TypeComp_SOM}=                Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Tipo de Complemento ${n}']/../../../../..//input
    #         ${Comp_SOM}=                    Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Complemento ${n}']/../../../../..//input
            
    #         Should Be Equal As Strings      ${type_comp}                            ${TypeComp_SOM}
    #         Should Be Equal As Strings      ${comp_value}                           ${Comp_SOM}

    #     END
    # END

    #Should Be Equal As Strings              ${Ordem_numeroCOM}                      ${correlationOrder}                     ignore_case=true
    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true           
    Should Be Equal As Strings              ${SOM_infra}                            ${infraType}                            ignore_case=true           
    Should Be Equal As Strings              ${Ordem_tipo}                           ${tipoOrdem}                            ignore_case=true
    # Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    Should Be Equal As Strings              ${Abertura_Pedido}                      ${data_abertura}
    # Should Be Equal As Strings              ${Origem_Ordem}                         TRGIBM
    # Should Be Equal As Strings              ${Empresa_Name}                         TRGIBM
    Should Be Equal As Strings              ${Contrato_Id}                          ${subscriberId}            
    # Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}           
    # Should Be Equal As Strings              ${Endereco_numero}                      ${numero}
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}
    # Should Be Equal As Strings              ${Endereco_ref}                         ${ref}

    Scroll To Element                       ${SOM_NomeDoProdutoAdd}

    ${NomeDoProdutoAdd}=                    Browser.Get Text                        ${SOM_NomeDoProdutoAdd}
    ${TecnologiaProdutoAdd}=                Browser.Get Text                        ${SOM_TecnologiaAdd}
    ${TipoDeProdutoAdd}=                    Browser.Get Text                        ${SOM_TipoDeProdutoAdd}
    ${IdDoCatalogoAdd}=                     Browser.Get Text                        ${SOM_IdCatalogAdd}
    ${AcaoAdd}=                             Browser.Get Text                        ${SOM_AcaoAdd}        

    Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE}MBPS
    Should Be Equal As Strings              ${TecnologiaProdutoAdd}                 ${infraType}
    Should Be Equal As Strings              ${IdDoCatalogoAdd}                      BL_${VELOCIDADE}MB
    Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    Should Be Equal As Strings              ${AcaoAdd}                              bloquear parcial

    @{productList}=                         Create List                             Velocidade    Download    Upload
    Set Global Variable                     ${productList}

    FOR    ${x}    IN RANGE    3
        ${xpathPosition}=                   Evaluate                                ${x}+1

        ${nomeAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input     
        ${valorAtributoXPATH}               Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Valor"]/../../../../..//input
        ${acaoAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Ação"]/../../../../..//input
    
        Scroll To Element                   //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input

        ${nomeAtributo}=                    Browser.Get Text                        ${nomeAtributoXPATH}
        ${valorAtributo}=                   Browser.Get Text                        ${valorAtributoXPATH}
        ${acaoAtributo}=                    Browser.Get Text                        ${acaoAtributoXPATH}

        IF    "${productList[${x}]}" == "Upload"

            ${uploadVelocity}=              Evaluate                                ${VELOCIDADE}/2
            Should Be Equal As Strings      ${valorAtributo}.0                      ${uploadVelocity}

        ELSE IF    "${productList[${x}]}" == "Velocidade"    
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE} MBPS
        
        ELSE IF    "${productList[${x}]}" == "Upload"
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE}
        END 

        Should Be Equal As Strings          ${productList[${x}]}                    ${nomeAtributo}                                                                  
        Should Be Equal As Strings          ${acaoAtributo}                         bloquear parcial
    END
    
    Scroll To Element                       ${SOM_Ordem_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Ordem_Block} 
    
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

#==================================================================================================================================================================
Valida OS Desbloqueio
    [Documentation]                         Valida e Consulta um pedido que foi desbloqueado consultando as tabelas no Order ID no SOM
    [TAGS]                                  ValidaOSCompleta
    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_from}                       ${IdDesbloqueio}
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    
    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é Completed
    ${order_state_Des}=                     Get Text Element is Visible             ${SOM_order_state}
    IF  "${order_state_Des}" != "Completed"
        Fatal Error                         Order State está diferente de Completed
    END

    #Valida o Status da type, esperado é Desbloqueio
    ${order_type_Des}=                      Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type_Des}" != "Vtal Fibra Desbloqueio"
        Fatal Error                         Order type está diferente de Desbloqueio
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}

    Get Text Element is Visible Valida      ${SOM_desblo_044}                       ==                                      T044 - Desbloquear Banda Larga Total APC
    Get Text Element is Visible Valida      ${SOM_Ordem_tipo}                       ==                                      Desbloqueio 

#==================================================================================================================================================================
Valida OS Retirada
    [Documentation]                         Valida e Consulta um pedido que teve uma retirada consultando as tabelas no Order ID no SOM
    [TAGS]                                  ValidaOSRetirada

    ${subscriber_Id}=                       Ler Variavel na Planilha                associatedDocument                      Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${subscriber_Id}
    Click Web Element Is Visible            ${SOM_btn_search}

    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}

    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é In Progress
    ${order_state_Des}=                     Get Text Element is Visible             ${SOM_order_state}
    IF  "${order_state_Des}" != "In Progress"
        Fatal Error                         Order State está diferente de In Progress
    END

    #Valida o Status da type, esperado é Retirada
    ${order_type_Des}=                      Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type_Des}" != "Vtal Fibra Retirada"
        Fatal Error                         Order type está diferente de Retirada
    END
    
#==================================================================================================================================================================
Valida OS Retirada Cancelada
    [Documentation]                         Valida e Consulta um pedido que teve uma retirada cancelada consultando as tabelas no Order ID no SOM
    [TAGS]                                  ValidaOSRetirada

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_from}                       ${Associated_Document}
    Click Web Element Is Visible            ${SOM_btn_search}

    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}

    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é In Progress
    ${order_state_Des}=                     Get Text Element is Visible             ${SOM_order_state}
    IF  "${order_state_Des}" != "Cancelado" and "${order_state_Des}" != "Cancelled"
        Fatal Error                         Order State está diferente de In Progress
    END

    #Valida o Status da type, esperado é Retirada
    ${order_type_Des}=                      Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type_Des}" != "Vtal Fibra Retirada"
        Fatal Error                         Order type está diferente de Retirada
    END

#===================================================================================================================================================================
Valida OS Completa FTTP
    [Documentation]                         Valida e Consulta um pedido FTTP que foi concluido com sucesso consultando as tabelas no Order ID no SOM
    [TAGS]                                  ValidaOSCompletaFTTP

    ${subscriber_Id}=                       Ler Variavel na Planilha                subscriberId                            Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${subscriber_Id}
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    
    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END
    
    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "Completed"
            Log To Console                  Estado da Ordem está completa
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END

    END


    # #Valida o Status da type, esperado é Vtal Fibra Instalação
    ${order_type}=                          Get Text Element is Visible             ${SOM_order_type} 
    IF  "${order_type}" != "Vtal Fibra Instalação"
        Fatal Error                         Order type está diferente de Vtal Fibra Instalação
    END

#==================================================================================================================================================================    
Valida OS Bloqueada FTTP
    [Arguments]                             ${VELOCIDADE}=1000
    [Documentation]                         Função usada para validar um pedido FTP bloqueado
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``VELOCIDADE`` | Valor passado na hora de criar o pedido referente a qual velocidade o pedido vai ter, pego da planilha, 1000MBS é o valor padrão. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Valida OS Bloqueada FTTP              400
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]
    [TAGS]                                   ValidaOSCompletaFTTP
    
    ${associated_document}=                 Ler Variavel na Planilha                associatedDocument                      Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_from}                       ${associated_document}
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    
    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é Completed
    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "Completed"
            Log To Console                  Estado da Ordem está completa
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END

    END

    #Valida o Status da type, esperado é Bloqueio
    ${order_type}=                          Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type}" != "Vtal Fibra Bloqueio"
        Fatal Error                         Order type está diferente de Bloqueio
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}

    ${infraType}=                           Set Variable                            FTTP
    ${correlationOrder}=                    Ler Variavel na Planilha                blockId                                 Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    # ${customerName}=                        Ler Variavel na Planilha                customerName                           Global
    # ${addressId}=                           Ler Variavel na Planilha                addressId                              Global
    # ${inventoryId}=                         Ler Variavel na Planilha                inventoryId                            Global
    ${tipoOrdem}=                           Set Variable                            Bloqueio    
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${data_abertura}=                       Ler Variavel na Planilha                validateDate                            Global
    # ${tpLogradouro}=                        Ler Variavel na Planilha                typeLogradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                addressName                            Global
    # ${numero}=                              Ler Variavel na Planilha                Number                                  Global
    # ${bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    # ${cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    # ${uf}=                                  Ler Variavel na Planilha                UF                                      Global
    # ${cep}=                                 Ler Variavel na Planilha                Address                                 Global
    # ${ref}=                                 Ler Variavel na Planilha                Reference                               Global

    Scroll To Element                       ${SOM_Ordem_numeroCOM}

    ${Ordem_numeroCOM}=                     Browser.Get Text                        ${SOM_Ordem_numeroCOM}
    ${Ordem_numeroPedido}=                  Browser.Get Text                        ${SOM_Ordem_numeroPedido}
    ${SOM_infra}=                           Browser.Get Text                        ${SOM_infraType}
    ${Ordem_tipo}=                          Browser.Get Text                        ${SOM_Ordem_tipo}
    # ${Cliente_nome}=                        Browser.Get Text                        ${SOM_Cliente_nome}
    
    Scroll To Element                       ${SOM_Endereco_id}
    
    ${Endereco_id}=                         Browser.Get Text                        ${SOM_Endereco_id}
    ${Endereco_inventory}=                  Browser.Get Text                        ${SOM_Endereco_inventory}
    ${Abertura_Pedido}=                     Browser.Get Text                        ${SOM_Ordem_dtAberturaPedido}
    # ${Origem_Ordem}=                        Browser.Get Text                        ${SOM_Origem_Solicitacao}
    # ${Empresa_Name}=                        Browser.Get Text                        ${SOM_Cliente_empresa}
    ${Contrato_Id}=                         Browser.Get Text                        ${SOM_Cliente_idContrato}
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    # ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    
    # FOR    ${x}    IN RANGE    3
    #     ${n}=                               Evaluate                                ${x}+1
    #     ${type_comp}=                       Ler Variavel na Planilha                TypeComplement${n}                      Global
        
    #     IF    "${type_comp}" != "None"
    #         ${comp_value}=                  Ler Variavel na Planilha                Value${n}                               Global

    #         ${TypeComp_SOM}=                Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Tipo de Complemento ${n}']/../../../../..//input
    #         ${Comp_SOM}=                    Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Complemento ${n}']/../../../../..//input
            
    #         Should Be Equal As Strings      ${type_comp}                            ${TypeComp_SOM}
    #         Should Be Equal As Strings      ${comp_value}                           ${Comp_SOM}

    #     END
    # END

    Should Be Equal As Strings              ${Ordem_numeroCOM}                      ${correlationOrder}                     ignore_case=true
    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true           
    Should Be Equal As Strings              ${SOM_infra}                            ${infraType}                            ignore_case=true           
    Should Be Equal As Strings              ${Ordem_tipo}                           ${tipoOrdem}                            ignore_case=true
    # Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    # Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    # Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    Should Be Equal As Strings              ${Abertura_Pedido}                      ${data_abertura}
    # Should Be Equal As Strings              ${Origem_Ordem}                         TRGIBM
    # Should Be Equal As Strings              ${Empresa_Name}                         TRGIBM
    Should Be Equal As Strings              ${Contrato_Id}                          ${subscriberId}            
    # Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}           
    # Should Be Equal As Strings              ${Endereco_numero}                      ${numero}
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}
    # Should Be Equal As Strings              ${Endereco_ref}                         ${ref}

    # Scroll To Element                       ${SOM_NomeDoProdutoAdd}

    # ${NomeDoProdutoAdd}=                    Browser.Get Text                        ${SOM_NomeDoProdutoAdd}
    # ${TecnologiaProdutoAdd}=                Browser.Get Text                        ${SOM_TecnologiaAdd}
    # ${TipoDeProdutoAdd}=                    Browser.Get Text                        ${SOM_TipoDeProdutoAdd}
    # ${IdDoCatalogoAdd}=                     Browser.Get Text                        ${SOM_IdCatalogAdd}
    # ${AcaoAdd}=                             Browser.Get Text                        ${SOM_AcaoAdd}        

    # Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE}MBPS
    # Should Be Equal As Strings              ${TecnologiaProdutoAdd}                 ${infraType}
    # Should Be Equal As Strings              ${IdDoCatalogoAdd}                      BL_${VELOCIDADE}MB
    # Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    # Should Be Equal As Strings              ${AcaoAdd}                              bloquear total

    @{productList}=                         Create List                             Velocidade    Download    Upload
    Set Global Variable                     ${productList}

    FOR    ${x}    IN RANGE    3
        ${xpathPosition}=                   Evaluate                                ${x}+1

        ${nomeAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input     
        ${valorAtributoXPATH}               Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Valor"]/../../../../..//input
        ${acaoAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Ação"]/../../../../..//input
    
        Scroll To Element                   //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input

        ${nomeAtributo}=                    Browser.Get Text                        ${nomeAtributoXPATH}
        ${valorAtributo}=                   Browser.Get Text                        ${valorAtributoXPATH}
        ${acaoAtributo}=                    Browser.Get Text                        ${acaoAtributoXPATH}

        IF    "${productList[${x}]}" == "Upload"

            ${uploadVelocity}=              Evaluate                                ${VELOCIDADE}/2
            Should Be Equal As Strings      ${valorAtributo}.0                      ${uploadVelocity}

        ELSE IF    "${productList[${x}]}" == "Velocidade"    
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE} MBPS
        
        ELSE IF    "${productList[${x}]}" == "Upload"
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE}
        END 

        Should Be Equal As Strings          ${productList[${x}]}                    ${nomeAtributo}                                                                  
        Should Be Equal As Strings          ${acaoAtributo}                         bloquear total
    END
    
    Scroll To Element                       ${SOM_Ordem_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Ordem_Block} 
    
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    
#===========================================================================================================================================================================================================
Valida OS Desbloqueio em FTTP
    [Arguments]                             ${VELOCIDADE}=1000
    [Documentation]                         Função usada para validar um pedido FTP Desbloqueado
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``VELOCIDADE`` | Valor passado na hora de criar o pedido referente a qual velocidade o pedido vai ter, pego da planilha, 1000MBS é o valor padrão. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Valida OS Desbloqueio em FTTP         400
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]
    [TAGS]                                  ValidaOSCompletaFTTP

    ${associated_document}=                 Ler Variavel na Planilha                associatedDocument                      Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${associated_document}
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    
    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é Completed
    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "Completed"
            Log To Console                  Estado da Ordem está completa
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END
    END

    #Valida o Status da type, esperado é Desbloqueio
    ${order_type_Des}=                      Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type_Des}" != "Vtal Fibra Desbloqueio"
        Fatal Error                         Order type está diferente de Desbloqueio
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}

    
   Get Text Element is Visible Valida       ${SOM_Ordem_tipo}                       ==                                      Desbloqueio 

    ${infraType}=                           Set Variable                            FTTP
    ${correlationOrder}=                    Ler Variavel na Planilha                idDesbloqueio                           Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    # ${customerName}=                        Ler Variavel na Planilha                customerName                           Global
    # ${addressId}=                           Ler Variavel na Planilha                addressId                              Global
    # ${inventoryId}=                         Ler Variavel na Planilha                inventoryId                            Global
    ${tipoOrdem}=                           Set Variable                            Desbloqueio    
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${data_abertura}=                       Ler Variavel na Planilha                validateDate                            Global
    # ${tpLogradouro}=                        Ler Variavel na Planilha                typeLogradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                addressName                            Global
    # ${numero}=                              Ler Variavel na Planilha                Number                                  Global
    # ${bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    # ${cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    # ${uf}=                                  Ler Variavel na Planilha                UF                                      Global
    # ${cep}=                                 Ler Variavel na Planilha                Address                                 Global
    # ${ref}=                                 Ler Variavel na Planilha                Reference                               Global

    Scroll To Element                       ${SOM_Ordem_numeroCOM}

    ${Ordem_numeroCOM}=                     Browser.Get Text                        ${SOM_Ordem_numeroCOM}
    ${Ordem_numeroPedido}=                  Browser.Get Text                        ${SOM_Ordem_numeroPedido}
    ${SOM_infra}=                           Browser.Get Text                        ${SOM_infraType}
    ${Ordem_tipo}=                          Browser.Get Text                        ${SOM_Ordem_tipo}
    # ${Cliente_nome}=                        Browser.Get Text                        ${SOM_Cliente_nome}
    
    Scroll To Element                       ${SOM_Endereco_id}
    
    ${Endereco_id}=                         Browser.Get Text                        ${SOM_Endereco_id}
    ${Endereco_inventory}=                  Browser.Get Text                        ${SOM_Endereco_inventory}
    ${Abertura_Pedido}=                     Browser.Get Text                        ${SOM_Ordem_dtAberturaPedido}
    # ${Origem_Ordem}=                        Browser.Get Text                        ${SOM_Origem_Solicitacao}
    # ${Empresa_Name}=                        Browser.Get Text                        ${SOM_Cliente_empresa}
    ${Contrato_Id}=                         Browser.Get Text                        ${SOM_Cliente_idContrato}
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    # ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    
    # FOR    ${x}    IN RANGE    3
    #     ${n}=                               Evaluate                                ${x}+1
    #     ${type_comp}=                       Ler Variavel na Planilha                TypeComplement${n}                      Global
        
    #     IF    "${type_comp}" != "None"
    #         ${comp_value}=                  Ler Variavel na Planilha                Value${n}                               Global

    #         ${TypeComp_SOM}=                Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Tipo de Complemento ${n}']/../../../../..//input
    #         ${Comp_SOM}=                    Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Complemento ${n}']/../../../../..//input
            
    #         Should Be Equal As Strings      ${type_comp}                            ${TypeComp_SOM}
    #         Should Be Equal As Strings      ${comp_value}                           ${Comp_SOM}

    #     END
    # END

    Should Be Equal As Strings              ${Ordem_numeroCOM}                      ${correlationOrder}                     ignore_case=true
    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true           
    Should Be Equal As Strings              ${SOM_infra}                            ${infraType}                            ignore_case=true           
    Should Be Equal As Strings              ${Ordem_tipo}                           ${tipoOrdem}                            ignore_case=true
    # Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    # Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    # Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    Should Be Equal As Strings              ${Abertura_Pedido}                      ${data_abertura}
    # Should Be Equal As Strings              ${Origem_Ordem}                         TRGIBM
    # Should Be Equal As Strings              ${Empresa_Name}                         TRGIBM
    Should Be Equal As Strings              ${Contrato_Id}                          ${subscriberId}            
    # Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}           
    # Should Be Equal As Strings              ${Endereco_numero}                      ${numero}
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}
    # Should Be Equal As Strings              ${Endereco_ref}                         ${ref}

    Scroll To Element                       xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Nome do Produto"]/../../../../..//input

    ${NomeDoProdutoAdd}=                    Browser.Get Text                        xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Nome do Produto"]/../../../../..//input
    ${TecnologiaProdutoAdd}=                Browser.Get Text                        xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Tecnologia"]/../../../../..//input
    ${TipoDeProdutoAdd}=                    Browser.Get Text                        xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Tipo de Produto"]/../../../../..//input
    ${IdDoCatalogoAdd}=                     Browser.Get Text                        xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Id do Catálogo"]/../../../../..//input
    ${AcaoAdd}=                             Browser.Get Text                        xpath=//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../../../../../../../../../../../div[5]//*[text()="Ação"]/../../../../..//input       

    Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE}MBPS
    Should Be Equal As Strings              ${TecnologiaProdutoAdd}                 ${infraType}
    Should Be Equal As Strings              ${IdDoCatalogoAdd}                      BL_${VELOCIDADE}MB
    Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    Should Be Equal As Strings              ${AcaoAdd}                              desbloquear total

    @{productList}=                         Create List                             Velocidade    Download    Upload
    Set Global Variable                     ${productList}

    FOR    ${x}    IN RANGE    3
        ${xpathPosition}=                   Evaluate                                ${x}+1

        ${nomeAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input     
        ${valorAtributoXPATH}               Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Valor"]/../../../../..//input
        ${acaoAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Ação"]/../../../../..//input
    
        Scroll To Element                   //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input

        ${nomeAtributo}=                    Browser.Get Text                        ${nomeAtributoXPATH}
        ${valorAtributo}=                   Browser.Get Text                        ${valorAtributoXPATH}
        ${acaoAtributo}=                    Browser.Get Text                        ${acaoAtributoXPATH}

        IF    "${productList[${x}]}" == "Upload"

            ${uploadVelocity}=              Evaluate                                ${VELOCIDADE}/2
            Should Be Equal As Strings      ${valorAtributo}.0                      ${uploadVelocity}

        ELSE IF    "${productList[${x}]}" == "Velocidade"    
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE} MBPS
        
        ELSE IF    "${productList[${x}]}" == "Upload"
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE}
        END 

        Should Be Equal As Strings          ${productList[${x}]}                    ${nomeAtributo}                                                                  
        Should Be Equal As Strings          ${acaoAtributo}                         desbloquear total
    END

    Scroll To Element                       ${SOM_Ordem_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Ordem_Block} 
    
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    Close Browser                           CURRENT
#===============================================================================================================================================================================================
Validar Enriquecimento SOM
    [Documentation]                         Valida e Consulta o Enriquecimento de massa no SOM
    [TAGS]                                  ValidaEnriquecimentoSOM

    ${subscriber_Id}=                       Ler Variavel na Planilha                associatedDocument                            Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${subscriber_Id}
    Click Web Element Is Visible            ${SOM_btn_search}

    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}

    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da type, esperado é Retirada
    ${order_type_Des}=                      Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type_Des}" != "Vtal Fibra Retirada"
        Fatal Error                         Order type está diferente de Retirada
    END

    #Valida o Process, esperado é "SP999 - Gerenciar Pendência"                                              
    ${SOM_process_valida}=                      Get Text Element is Visible             ${SOM_process}
    IF  "${SOM_process_valida}" != "SP999 - Gerenciar Pendência"
        Fatal Error                         Process está diferente de SP999 - Gerenciar Pendência
    END

#===============================================================================================================================================================================================
Validar Conclusao OS Retirada
    [Arguments]                             ${FTTH_ou_FTTP}=FTTH                    ${VELOCIDADE}=1000                    ${bit_true_false}=false           
    [Documentation]                         Validar Conclusao OS Retirada
    [TAGS]                                  ValidarConclusaoOSRetirada

    ${Nome_Empresa}=                        Convert To String                       TRGIBM
    ${customer_name}=                       Convert To String                       TRGIBM

    ### BITSTREAM ######
    IF    "${bit_true_false}" == "true"
        ${Nome_Empresa}=                    Convert To String                       TIM
        ${customer_name}=                   Convert To String                       TRGIBMTIMBIT
    END
    ######
    ${associated_document}=                 Ler Variavel na Planilha                associatedDocument                      Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${associated_document}
    Click Web Element Is Visible            ${SOM_btn_search}
    Click Web Element Is Visible            ${SOM_rb_Preview}
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    
    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é Completed
    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "Completed"
            Log To Console                  Estado da Ordem está completa
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END
    END

    ${order_type}=                          Get Text Element is Visible             ${SOM_order_type}
    IF    "${bit_true_false}" == "true"
        IF  "${order_type}" != "Vtal Bitstream Retirada"
            Fatal Error                         Order type está diferente de Vtal Bitstream Retirada
        END
    ELSE
        IF  "${order_type}" != "Vtal Fibra Retirada"
            Fatal Error                         Order type está diferente de Vtal Fibra Retirada
        END
    END
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    ${infraType}=                           Set Variable                            ${FTTH_ou_FTTP}
    ${correlationOrder}=                    Ler Variavel na Planilha                osOrderId                               Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    # ${customerName}=                        Ler Variavel na Planilha                customerName                           Global
    # ${addressId}=                           Ler Variavel na Planilha                addressId                              Global
    # ${inventoryId}=                         Ler Variavel na Planilha                inventoryId                            Global
    ${tipoOrdem}=                           Set Variable                            Retirada    
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${data_abertura}=                       Ler Variavel na Planilha                validateDate                            Global
    # ${tpLogradouro}=                        Ler Variavel na Planilha                typeLogradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                addressName                            Global
    # ${numero}=                              Ler Variavel na Planilha                Number                                  Global
    # ${bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    # ${cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    # ${uf}=                                  Ler Variavel na Planilha                UF                                      Global
    # ${cep}=                                 Ler Variavel na Planilha                Address                                 Global
    # ${ref}=                                 Ler Variavel na Planilha                Reference                               Global

    Scroll To Element                       ${SOM_Ordem_numeroCOM}

    ${Ordem_numeroCOM}=                     Browser.Get Text                        ${SOM_Ordem_numeroCOM}
    ${Ordem_numeroPedido}=                  Browser.Get Text                        ${SOM_Ordem_numeroPedido}
    ${SOM_infra}=                           Browser.Get Text                        ${SOM_infraType}
    ${Ordem_tipo}=                          Browser.Get Text                        ${SOM_Ordem_tipo}
    # ${Cliente_nome}=                        Browser.Get Text                        ${SOM_Cliente_nome}
    
    Scroll To Element                       ${SOM_Endereco_id}
    
    # ${Endereco_id}=                         Browser.Get Text                        ${SOM_Endereco_id}
    # ${Endereco_inventory}=                  Browser.Get Text                        ${SOM_Endereco_inventory}
    ${Abertura_Pedido}=                     Browser.Get Text                        ${SOM_Ordem_dtAberturaPedido}
    # ${Empresa_Name}=                        Browser.Get Text                        ${SOM_Cliente_empresa}
    # ${Contrato_Id}=                         Browser.Get Text                        ${SOM_Cliente_idContrato}
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    # ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    
    # FOR    ${x}    IN RANGE    3
    #     ${n}=                               Evaluate                                ${x}+1
    #     ${type_comp}=                       Ler Variavel na Planilha                TypeComplement${n}                      Global
        
    #     IF    "${type_comp}" != "None"
    #         ${comp_value}=                  Ler Variavel na Planilha                Value${n}                               Global

    #         ${TypeComp_SOM}=                Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Tipo de Complemento ${n}']/../../../../..//input
    #         ${Comp_SOM}=                    Browser.Get Text                        //a[.='Dados dos Endereços']/../../../..//*[text()='Complemento ${n}']/../../../../..//input
            
    #         Should Be Equal As Strings      ${type_comp}                            ${TypeComp_SOM}
    #         Should Be Equal As Strings      ${comp_value}                           ${Comp_SOM}

    #     END
    # END

    Should Be Equal As Strings              ${Ordem_numeroCOM}                      ${correlationOrder}                     ignore_case=true
    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true           
    Should Be Equal As Strings              ${SOM_infra}                            ${infraType}                            ignore_case=true           
    Should Be Equal As Strings              ${Ordem_tipo}                           ${tipoOrdem}                            ignore_case=true
    # Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    # Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    # Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    Should Be Equal As Strings              ${Abertura_Pedido}                      ${data_abertura}
    # Should Be Equal As Strings              ${Empresa_Name}                         ${Nome_Empresa}
    # Should Be Equal As Strings              ${Contrato_Id}                          ${subscriberId}                         ignore_case=true
    # Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}                         ignore_case=true
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}                           ignore_case=true
    # Should Be Equal As Strings              ${Endereco_numero}                      ${numero}                               ignore_case=true
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}                               ignore_case=true
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}                               ignore_case=true
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}                                   ignore_case=true
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}                                  ignore_case=true
    # Should Be Equal As Strings              ${Endereco_ref}                         ${ref}                                  ignore_case=true

    # Scroll To Element                       ${SOM_NomeDoProdutoAdd}


    ### BITSTREAM ######
    IF    "${bit_true_false}" == "true"
        ${SOM_TecnologiaAdd}=                     Convert To String                       (//*[text()="Produto"]/../../../../../..//span[contains(text(),"Tecnologia")]/../../../..//input)
        ${infraType}=                             Set Variable                           
        ${produtoRede}=                           Browser.Get Text                        (//div[@class="windowContent"]//a[text()="Rede"]/../../../..//input[@value="BIT"]) 
        Scroll To Element                         (//div[@class="windowContent"]//a[text()="Rede"]/../../../..//input[@value="BIT"])
        Take Screenshot Web Element is visible    (//div[@class="windowContent"]//a[text()="Rede"]/../../../..//input[@value="BIT"])
        Should Be Equal As Strings                ${produtoRede}                          BIT                                      Classe do Produto na Rede não está como BIT.         
    END
    ######


    # ${NomeDoProdutoAdd}=                    Browser.Get Text                        ${SOM_NomeDoProdutoAdd}
    # ${TecnologiaProdutoAdd}=                Browser.Get Text                        ${SOM_TecnologiaAdd}
    # ${TipoDeProdutoAdd}=                    Browser.Get Text                        ${SOM_TipoDeProdutoAdd}
    # ${IdDoCatalogoRemove}=                  Browser.Get Text                        ${SOM_IdCatalogRemove}
    # ${AcaoRemover}=                         Browser.Get Text                        ${SOM_AcaoAdd}        

    # Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE}MBPS
    # Should Be Equal As Strings              ${TecnologiaProdutoAdd}                 ${infraType}
    # Should Be Equal As Strings              ${IdDoCatalogoRemove}                   BL_${VELOCIDADE}MB
    # Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    # Should Be Equal As Strings              ${AcaoRemover}                          remover

    Scroll To Element                       ${SOM_Ordem_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Ordem_Block} 
    
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    Close Browser                           CURRENT
#===============================================================================================================================================================================================
Valida TroubleTicket Cancelado
    [Documentation]                         Valida Cancelamento do Chamado tecnico no SOM
    [Tags]                                  ValidaTroubleTicketCancelado

    Wait For Elements State                 ${SOM_rb_Preview}                       visible                                 timeout=${TIMEOUT}
    Click Web Element Is Visible            ${SOM_rb_Preview}

    ${TroubleTicket}=                       Ler Variavel na Planilha                TroubleTicket                           Global

    Wait For Elements State                 ${SOM_order_input}                      visible                                 timeout=${TIMEOUT}
    Input Text Web Element Is Visible       ${SOM_order_input}                      ${TroubleTicket}
    
    Click Web Element Is Visible            ${SOM_btn_refresh}
    Sleep     3

    #Valida o Status da ordem, esperado é Cancelled
    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "Cancelled"
            Log To Console                  Estado da Ordem está cancelada
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END
    END

    #Valida o Status da Stake Name, esperado é OI Fibra Chamado Tecnico Ordem	
    ${order_type}=                          Get Text Element is Visible             ${Order_Type_SOM} 
    IF  "${order_type}" != "OI Fibra Chamado Tecnico Ordem"
        Fatal Error                         Order type está diferente de OI Fibra Chamado Tecnico Ordem	
    END
#===================================================================================================================================================================
Validar Conclusao OS Trouble Ticket
    [Documentation]                         Validar Conclusao OS Retirada
    [TAGS]                                  ValidarConclusaoOSRetirada

    Login SOM

    ${troubleTicket_id}=                    Ler Variavel na Planilha                troubleTicketId                        Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_OrderId}                    ${troubleTicket_id}
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    

    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END

    #Valida o Status da ordem, esperado é Completed
    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "Completed"
            Log To Console                  Estado da Ordem está completa
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END
    END

    #Valida o Status da type, esperado é Bloqueio
    ${order_type}=                          Get Text Element is Visible             ${SOM_order_type}
    IF  "${order_type}" != "Vtal Fibra Chamado Tecnico Ordem"
        Fatal Error                         Order type está diferente de Vtal Fibra Chamado Tecnico Ordem
    END
#==================================================================================================================================================================
Valida Evento SOM
    [Documentation]                         Função usada para validar um evento no SOM
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``CodRetornado`` | Nome na planilha que está o Order_ID. |
    ...                                     | ``ordem_State_Consulta`` | Estado da Ordem que se espera. Exemplo: ``Completed``. |
    ...                                     | ``Order_Type_Consulta`` | Tipo de consulta que se quer fazer. Exemplo: ``Oi Fibra Instalação``. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Valida Evento SOM                     somOrderId                              Completed                               Oi Fibra Instalação
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]
    [Arguments]                             ${CodRetornado}                         ${ordem_State_Consulta}                 ${Order_Type_Consulta}                   
    # Keyword Generica para Valida no SOM.  ARGUMENTOS: Coluna da planilha, ordem_state e Ordem Type do SOM

    Login SOM
    Altera Filtro Consulta Order ID

    ${CodRetornado}                         Ler Variavel na Planilha                ${CodRetornado}                          Global
    Set Global Variable                     ${CodRetornado}

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_from}                       *${CodRetornado}*
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 ${SOM_btn_tres_pontos}                  visible                                 timeout=${TIMEOUT}
    
    #Valida a quantia de linhas das tarefas, o comum é se ter 1 linha, além da linha de descrição
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            ${SOM_linha_tarefa}
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Tarefa não existe
    END
    
    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${ordemState}=                      Get Table Cell Element                  //html/body/table/tbody/tr[1]/td/div[4]/div/form/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Order State"     ${row}
        ${value}=                           Get Text Element is Visible             ${ordemState}

        IF  "${value}" == "${ordem_State_Consulta}"
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END

    END

    # #Valida o Status da type, esperado pelo argumento
    ${order_type}=                          Get Text Element is Visible             ${SOM_order_type} 
    IF  "${order_type}" != "${Order_Type_Consulta}"
        Fatal Error                         Order type está diferente do argumento
    END
    Close Browser                           CURRENT

#===================================================================================================================================================================
Validar Evento Simples SOM
    [Documentation]                         Função usada para validar um evento Simples no SOM
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``VALOR_PESQUISA`` | Nome na planilha que está o Order_ID. |
    ...                                     | ``TASK_NAME`` | Task Name que espera que o pedido esteja. Exemplo: ``T017 - Instalar Equipamento ``. |
    ...                                     | ``ORDER_TYPE`` | Tipo de ordem que se quer pesquisar. Exemplo: ``Oi Fibra Retirada``. |
    ...                                     | ``ORDER_STATE`` | Estado do pedido que se espera. Exemplo: ``In progress``. |
    ...                                     | ``TIPO_PESQUISA`` | Tipo de pesquisa que se quer fazer. Exemplo: ``WorkList``. |
    ...                                     | ``TENTATIVAS_FOR`` | Número de vezes que o for deve ser repetido antes do código acabar. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     |     Validar Evento Simples SOM        VALOR_PESQUISA=somOrderId
    ...                                     |     ...                               ORDER_TYPE=Oi Fibra Retirada
    ...                                     |     ...                               ORDER_STATE=In Progress
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]

    [Arguments]                             ${VALOR_PESQUISA}=somOrderId
    ...                                     ${TASK_NAME}=NULL
    ...                                     ${ORDER_TYPE}=NULL
    ...                                     ${ORDER_STATE}=NULL
    ...                                     ${TIPO_PESQUISA}=QUERY
    ...                                     ${TIPO_PESQUISA_preview}=orderId
    ...                                     ${TENTATIVAS_FOR}=15


    Login SOM
    
    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                ${VALOR_PESQUISA}                       Global

    IF    "${TIPO_PESQUISA}" == "QUERY"
        #PESQUISAR PELA QUERY
        Click Web Element Is Visible        ${SOM_btn_query}
        Input Text Web Element Is Visible   ${SOM_input_from}                       ${VALOR_PESQUISA}
        Sleep                               3s
        Click Web Element Is Visible        ${SOM_btn_search}
    
    ELSE IF  "${TIPO_PESQUISA}" == "PREVIEW"
        #PESQUISAR PELO PREVIEW
        Click Web Element Is Visible        ${SOM_rb_Preview}

        IF  "${TIPO_PESQUISA_preview}" == "orderId"                 #Pesquisa pelo Order Id
            Input Text Web Element Is Visible   ${SOM_order_input}                  ${VALOR_PESQUISA}
        ELSE IF  "${TIPO_PESQUISA_preview}" == "reference"          #Pesquisa pelo Reference
            Input Text Web Element Is Visible   ${SOM_Ref_Input}                    ${VALOR_PESQUISA}
        END
        
        Sleep                               3s
        Click Web Element Is Visible        ${SOM_btn_refresh}

    END


    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}


    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="${ORDER_STATE}"])[1]    Visible    10
            IF    ${EXIST} == True
            
                Take Screenshot Web Element is visible                              //tr[@class="context-menu-target"]/../..

                IF    "${ORDER_STATE}" != "NULL"
                    ${ORDER_STATE_SOM}=     Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order State"                           1
                    Scroll To Element                                               ${ORDER_STATE_SOM}
                    Take Screenshot Web Element is visible                          ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Browser.Get Text                        ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Strip String                            ${ORDER_STATE_SOM}

                    IF    "${ORDER_STATE}" != "${ORDER_STATE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder State está ${ORDER_STATE_SOM}, esperado é ${ORDER_STATE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END
                
                IF    "${ORDER_TYPE}" != "NULL"
                    ${ORDER_TYPE_SOM}=      Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order Type"                            1
                    Scroll To Element                                               ${ORDER_TYPE_SOM}
                    Take Screenshot Web Element is visible                          ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Browser.Get Text                        ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Strip String                            ${ORDER_TYPE_SOM}

                    IF    "${ORDER_TYPE}" != "${ORDER_TYPE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder Type está ${ORDER_TYPE_SOM}, esperado é ${ORDER_TYPE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    ELSE IF    "${ORDER_TYPE}" == "${ORDER_TYPE_SOM}" and "${TASK_NAME}" == "NULL"
                        Close Browser               CURRENT
                        BREAK
                    END
                END
                
                IF    "${TASK_NAME}" != "NULL"
                    ${TASK_NAME_SOM}=       Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Task Name"                             1
                    Scroll To Element                                               ${TASK_NAME_SOM}
                    Take Screenshot Web Element is visible                          ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Browser.Get Text                        ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Strip String                            ${TASK_NAME_SOM}

                    IF    "${TASK_NAME}" == "${TASK_NAME_SOM}"
                        Close Browser               CURRENT
                        BREAK
                    ELSE IF    "${TASK_NAME}" != "${TASK_NAME_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error             \n${TASK_NAME} não foi encontrado no SOM
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END

            ELSE
                Click Web Element Is Visible            ${SOM_btn_refresh}
                IF    ${x} == ${TENTATIVAS_FOR}-1
                    Fatal Error             \n${ORDER_STATE} não foi encontrado no SOM
                END
            END
    END





#===================================================================================================================================================================
Validar Evento Completo SOM
    [Documentation]                         Função usada para validar um evento COmpleto no SOM
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``VALOR_PESQUISA`` | Nome na planilha que está o Order_ID. |
    ...                                     | ``TASK_NAME`` | Task Name que espera que o pedido esteja. Exemplo: ``T017 - Instalar Equipamento ``. |
    ...                                     | ``ORDER_TYPE`` | Tipo de ordem que se quer pesquisar. Exemplo: ``Oi Fibra Retirada``. |
    ...                                     | ``ORDER_STATE`` | Estado do pedido que se espera. Exemplo: ``In progress``. |
    ...                                     | ``TIPO_PESQUISA`` | Tipo de pesquisa que se quer fazer. Exemplo: ``WorkList``. |
    ...                                     | ``XPATH_VALIDACOES`` | Xpath que contem todas os itens das validações, normalmente é uma lista. |
    ...                                     | ``RETORNO_ESPERADO`` | Retorno esperado para comparar com o que é mostrado no site, normalmente é uma lista. |
    ...                                     | ``TENTATIVAS_FOR`` | Número de vezes que o for deve ser repetido antes do código acabar. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     |     Validar Evento Completo SOM             VALOR_PESQUISA=somOrderId
    ...                                     |     ...                               TASK_NAME=T017 - Instalar Equipamento
    ...                                     |     ...                                ORDER_TYPE=Vtal Fibra Instalação
    ...                                     |     ...                               ORDER_STATE=In Progress
    ...                                     |     ...                               RETORNO_ESPERADO=${RETORNO}
    ...                                     |     ...                               XPATH_VALIDACOES=${LIST}
    ...                                     Biblioteca utilizada: [https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST%20On%20Session|RequestsLibrary >>]

    [Arguments]                             ${VALOR_PESQUISA}=somOrderId
    ...                                     ${TASK_NAME}=NULL
    ...                                     ${ORDER_TYPE}=NULL
    ...                                     ${ORDER_STATE}=NULL
    ...                                     ${TIPO_PESQUISA}=QUERY
    ...                                     ${XPATH_VALIDACOES}=NULL
    ...                                     ${RETORNO_ESPERADO}=NULL
    ...                                     ${TENTATIVAS_FOR}=15
    ...                                     ${plantaExterna}=True

    
    # Validar Evento Simples SOM              VALOR_PESQUISA=${VALOR_PESQUISA}
    # ...                                     TASK_NAME=${TASK_NAME}
    # ...                                     ORDER_TYPE=${ORDER_TYPE}
    # ...                                     ORDER_STATE=${ORDER_STATE}

    Login SOM
    
    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                ${VALOR_PESQUISA}                       Global

    IF    "${TIPO_PESQUISA}" == "QUERY"
        #PESQUISAR PELA QUERY
        Click Web Element Is Visible        ${SOM_btn_query}
        Input Text Web Element Is Visible   ${SOM_input_ref}                       ${VALOR_PESQUISA}
        Sleep                               3s
        Click Web Element Is Visible        ${SOM_btn_search}
    
    ELSE IF  "${TIPO_PESQUISA}" == "PREVIEW"
        #PESQUISAR PELO PREVIEW
        Click Web Element Is Visible        ${SOM_rb_Preview}
        Input Text Web Element Is Visible   ${SOM_Ref_Input}                      ${VALOR_PESQUISA}
        Sleep                               3s
        Click Web Element Is Visible        ${SOM_btn_refresh}

    END


    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}


    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="${ORDER_STATE}"])[1]    Visible    10
            IF    ${EXIST} == True
            
                # Take Screenshot Web Element is visible                              //tr[@class="context-menu-target"]/../..

                IF    "${ORDER_STATE}" != "NULL"
                    ${ORDER_STATE_SOM}=     Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order State"                           1
                    # Scroll To Element                                               ${ORDER_STATE_SOM}
                    # Take Screenshot Web Element is visible                          ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Browser.Get Text                        ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Strip String                            ${ORDER_STATE_SOM}

                    IF    "${ORDER_STATE}" != "${ORDER_STATE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder State está ${ORDER_STATE_SOM}, esperado é ${ORDER_STATE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END
                
                IF    "${ORDER_TYPE}" != "NULL"
                    ${ORDER_TYPE_SOM}=      Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order Type"                            1
                    # Scroll To Element                                               ${ORDER_TYPE_SOM}
                    # Take Screenshot Web Element is visible                          ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Browser.Get Text                        ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Strip String                            ${ORDER_TYPE_SOM}

                    IF    "${ORDER_TYPE}" != "${ORDER_TYPE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder Type está ${ORDER_TYPE_SOM}, esperado é ${ORDER_TYPE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    ELSE IF    "${ORDER_TYPE}" == "${ORDER_TYPE_SOM}" and "${TASK_NAME}" == "NULL"                       
                        BREAK
                    END
                END
                
                IF    "${TASK_NAME}" != "NULL"
                    ${TASK_NAME_SOM}=       Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Task Name"                             1
                    # Scroll To Element                                               ${TASK_NAME_SOM}
                    # Take Screenshot Web Element is visible                          ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Browser.Get Text                        ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Strip String                            ${TASK_NAME_SOM}

                    IF    "${TASK_NAME}" == "${TASK_NAME_SOM}"
                        BREAK
                    ELSE IF    "${TASK_NAME}" != "${TASK_NAME_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error             \n${TASK_NAME} não foi encontrado no SOM
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END

            ELSE
                Click Web Element Is Visible            ${SOM_btn_refresh}
                IF    ${x} == ${TENTATIVAS_FOR}-1
                    Fatal Error             \n${ORDER_STATE} não foi encontrado no SOM
                END
            END
    END


    Click Web Element Is Visible            ${SOM_rb_Preview}
    Sleep                                   3s
    Click Web Element Is Visible            (//input[contains(@name,'move')])[1]

    # VERIFICANDO O SOM ORDER ID E SA
    ${OrderExiste}    Run Keyword And Return Status    Ler Variavel na Planilha     somOrderId                              Global
    IF    "${OrderExiste}" == "True"
        ${OrderId}                              Ler Variavel na Planilha                somOrderId                            Global
        IF    "${OrderId}" == "None"
            ${OrderId}                          Browser.Get Text                        ${ValorOrderId}
            Escrever Variavel na Planilha       ${OrderId}                              somOrderId                            Global
        END
    END
    
    ${xpathSAExiste}    Run Keyword And Return Status    Wait for Elements State         ${SOM_Numero_BA}                        Visible                                 timeout=5
    IF    "${xpathSAExiste}" == "True"
        ${SAExiste}         Run Keyword And Return Status    Ler Variavel na Planilha        workOrderId                           Global
        IF    "${SAExiste}" == "True"
            ${NumeroSA}                             Ler Variavel na Planilha                workOrderId                           Global
            IF    "${NumeroSA}" == "None"
                Scroll To Element                   ${SOM_Numero_BA}
                ${NumeroSA}                         Browser.Get Text                        ${SOM_Numero_BA}
                Escrever Variavel na Planilha       ${NumeroSA}                             workOrderId                           Global
            END
        END
    END

    FOR    ${XPATH}    ${VALOR_PLANILHA}    IN ZIP    ${XPATH_VALIDACOES}    ${RETORNO_ESPERADO}
        ${TEXTO}=                           Browser.Get Text                        ${XPATH}
        ${TEXTO}                            Convert To String                       ${TEXTO}
        ${TEXTO}                            Strip String                            ${TEXTO}
        ${TEXTO}=                           Convert To Uppercase                    ${TEXTO}
        
        ${VALOR}=                           Ler Variavel na Planilha                ${VALOR_PLANILHA}                       Global
        ${VALOR}                            Convert To String                       ${VALOR}
        ${VALOR}                            Strip String                            ${VALOR}
        ${VALOR}=                           Convert To Uppercase                    ${VALOR}

        IF    "${TEXTO}" != "${VALOR}"
            Fatal Error                     \nValor Esperado: ${VALOR}, Valor no SOM: ${TEXTO}
        END
    END    

    IF    ${plantaExterna} == False
        Verificar se existe complemento e validar
    END

    Scroll To Element                       ${SOM_Ordem_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Ordem_Block} 
    
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    Close Browser                           CURRENT
#===================================================================================================================================================================
Validar Criação de Reparo SOM
    [Documentation]                         Função usada para validar um evento de reparo no SOM
    [Arguments]                             ${SomAgendamento}=T070 - Agendamento do Reparo

    Login SOM
    
    ${associatedDocument}                   Ler Variavel na Planilha                associatedDocument                      Global
    Set Global Variable                     ${associatedDocument}

    Wait For Elements State                 ${SOM_rb_Preview}                       visible                                 timeout=${TIMEOUT}
    Click Web Element Is Visible            ${SOM_rb_Preview}

    Wait For Elements State                 ${SOM_order_input}                      visible                                 timeout=${TIMEOUT}
    Input Text Web Element Is Visible       ${SOM_Ref_Input}                        ${associatedDocument}
    
    Click Web Element Is Visible            ${SOM_btn_refresh}

    #Valida o Task Name, esperado é "T070 - Agendamento do Reparo"
    ${taskname_SOM}=                         Get Text Element is Visible            xpath=//span[normalize-space()="Task Name"]/../../../../tr[3]/td[12]
    IF  "${taskname_SOM}" != "${SomAgendamento}"
        Fatal Error                         Task Name está diferente de "${SomAgendamento}"
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            xpath=//span[normalize-space()="Task Name"]/../../../../tr[3]/td[12]//..//td[contains(@class,'tableAction')]//input[contains(@name,'move')]
    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}
    
    #validações no SOM
    Scroll To Element                       xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="${SomAgendamento}"])

    ${Tarefa_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="${SomAgendamento}"])
    ${Status_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="${SomAgendamento}"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])

#===================================================================================================================================================================
Validar a pendencia TroubleTicket no SOM
    [Documentation]                         Função usada para validar um evento de reparo no SOM
    [Arguments]                             ${SomAgendamento}=T070 - Agendamento do Reparo

    Login SOM
    
    ${troubleTicket_id}                     Ler Variavel na Planilha                troubleTicketId                          Global
    Set Global Variable                     ${troubleTicket_id}

    Wait For Elements State                 ${SOM_rb_Preview}                       visible                                 timeout=${TIMEOUT}
    Click Web Element Is Visible            ${SOM_rb_Preview}

    Wait For Elements State                 ${SOM_order_input}                      visible                                 timeout=${TIMEOUT}
    Input Text Web Element Is Visible       ${SOM_order_input}                      ${troubleTicket_id}
    
    Click Web Element Is Visible            ${SOM_btn_refresh}

    #Valida o Task Name T088 - Executar BA Planta Externa Chamado Tecnico
    FOR         ${1}    IN RANGE    ${10}
        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1
    
        IF  ${row_count} != 4
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        ELSE    
            Exit For Loop
        END 
    END

    FOR     ${row}    IN RANGE    ${row_count}
    
        ${taskName}=                        Get Table Cell Element                  //*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Task Name"     ${row}
        ${value}=                           Get Text Element is Visible             ${taskName}

        IF  "${value}" == "T088 - Executar BA Planta Externa Chamado Tecnico"
            log to console                  "task name validado"
            Click Web Element Is Visible    xpath=(//input[@value='...'])[${row}]
            Exit For Loop
        END
    END
    
    #Validações no "T088 - Executar BA Planta Externa Chamado Tecnico"
    Scroll To Element                       xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="${SomAgendamento}"])
    ${Tarefa_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="${SomAgendamento}"])
    ${Status_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="${SomAgendamento}"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])

    Scroll To Element                       xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="Cancelar Chamado Tecnico"])
    ${Cancelar_Chamado}=                    Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="Cancelar Chamado Tecnico"])
    ${Cancelar_Chamado_Status}=             Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="Cancelar Chamado Tecnico"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])

    Scroll To Element                       xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T088 - Executar BA Planta Externa Chamado Tecnico"])
    ${Tarefa_T088}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T088 - Executar BA Planta Externa Chamado Tecnico"])
    ${Status_T088}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T088 - Executar BA Planta Externa Chamado Tecnico"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])

    Scroll To Element                       xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="Notificar Abertura de BA"])
    ${Notificar_Abertura_BA}=               Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="Notificar Abertura de BA"])
    ${Status_Abertura_BA}=                  Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="Notificar Abertura de BA"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])

    Close Browser                           CURRENT
#===========================================================================================================================================================================================================
Validar a pendencia Tenant 7111

    [Arguments]                             ${TASK_NAME}=T017 - Instalar Equipamento
    ...                                     ${ORDER_TYPE}=Vtal Bitstream Instalação
    ...                                     ${ORDER_STATE}=In Progress
    ...                                     ${TENTATIVAS_FOR}=15
    ...                                     ${VALIDACAO}=1

    [Documentation]                         Função usada para validar pendencia 7111
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``TASK_NAME`` | Task Name que espera que o pedido esteja. Exemplo: ``T017 - Instalar Equipamento ``. |
    ...                                     | ``ORDER_TYPE`` | Tipo de ordem que se quer pesquisar. Exemplo: ``Vtal Bitstream Instalação``. |
    ...                                     | ``ORDER_STATE`` | Estado do pedido que se espera. Exemplo: ``In progress``. |
    ...                                     | ``TENTATIVAS_FOR`` | Número de vezes que o for deve ser repetido antes do código acabar. |
    ...                                     | ``VALIDACAO`` | Usada para selecionar qual tipo de validação deve ser feita. 1: Usada para validação na Task Name "TA - Tratar Pendência Tenant", valida tarefas TA e T017. 2: Usada para validação na Task Name "T017 - Instalar Equipamento", valida tarefas T017, T046 e T037. |
    ...                                     Exemplos de como usar a função: 
    ...                                     |     Validar a pendencia Tenant 7111   TASK_NAME=TA - Tratar Pendência Tenant  VALIDACAO=1
    ...                                     |     ...                               TASK_NAME=T017 - Instalar Equipamento   VALIDACAO=2

    Login SOM
    
    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                somOrderId                              Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_OrderId}                    ${VALOR_PESQUISA}
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_search}

    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}

    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="${ORDER_STATE}"])[1]    Visible    10
            IF    ${EXIST} == True
            
                Take Screenshot Web Element is visible                              //tr[@class="context-menu-target"]/../..

                IF    "${ORDER_STATE}" != "NULL"
                    ${ORDER_STATE_SOM}=     Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order State"                           1
                    Scroll To Element                                               ${ORDER_STATE_SOM}
                    Take Screenshot Web Element is visible                          ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Browser.Get Text                        ${ORDER_STATE_SOM}
                    
                    IF    "${ORDER_STATE}" != "${ORDER_STATE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder State está ${ORDER_STATE_SOM}, esperado é ${ORDER_STATE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END
                
                IF    "${ORDER_TYPE}" != "NULL"
                    ${ORDER_TYPE_SOM}=      Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order Type"                            1
                    Scroll To Element                                               ${ORDER_TYPE_SOM}
                    Take Screenshot Web Element is visible                          ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Browser.Get Text                        ${ORDER_TYPE_SOM}

                    IF    "${ORDER_TYPE}" != "${ORDER_TYPE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder Type está ${ORDER_TYPE_SOM}, esperado é ${ORDER_TYPE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    ELSE IF    "${ORDER_TYPE}" == "${ORDER_TYPE_SOM}" and "${TASK_NAME}" == "NULL"                       
                        BREAK
                    END
                END
                
                IF    "${TASK_NAME}" != "NULL"
                    ${TASK_NAME_SOM}=       Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Task Name"                             1
                    Scroll To Element                                               ${TASK_NAME_SOM}
                    Take Screenshot Web Element is visible                          ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Browser.Get Text                        ${TASK_NAME_SOM}

                    IF    "${TASK_NAME}" == "${TASK_NAME_SOM}"
                        BREAK
                    ELSE IF    "${TASK_NAME}" != "${TASK_NAME_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error             \n${TASK_NAME} não foi encontrado no SOM
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END

            ELSE
                Click Web Element Is Visible            ${SOM_btn_refresh}
                IF    ${x} == ${TENTATIVAS_FOR}-1
                    Fatal Error             \n${ORDER_STATE} não foi encontrado no SOM
                END
            END
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Sleep                                   3s
    Click Web Element Is Visible            (//input[contains(@name,'move')])[1]
    Sleep                                   3s
    Wait For Elements State                 ${SOM_pendencia_observacoes}            visible                                 timeout=${TIMEOUT}

    IF    ${VALIDACAO} == 1

        ${NumeroBA}=                        Ler Variavel na Planilha                workOrderId                             Global
        ${ProcessoId}=                      Ler Variavel na Planilha                workOrderId                             Global

        ${pendencia}=                       Browser.Get Text                        ${SOM_pendencia}
        ${obs_encerramento}=                Browser.Get Text                        ${SOM_pendencia_observacoes}
        ${Classe_Produto}=                  Browser.Get Text                        ${SOM_Classe_Produto}
        ${Habilitado}=                      Browser.Get Text                        ${SOM_Habilitado}
        ${Codigo_Ativacao}=                 Browser.Get Text                        ${SOM_Codigo_Ativacao}
        ${SVLAN}=                           Browser.Get Text                        ${SOM_SVLAN}
        ${QVLAN}=                           Browser.Get Text                        ${SOM_QVLAN}
        ${Nome_Atividade}=                  Browser.Get Text                        ${SOM_Nome_Atividade}
        ${Numero_BA}=                       Browser.Get Text                        ${SOM_Numero_BA}
        ${Codigo_Encerrament}=              Browser.Get Text                        ${SOM_Codigo_Encerramento}
        ${BilheteAtividade_Observacoes}=    Browser.Get Text                        ${SOM_BilheteAtividade_Observacoes}
        ${Processo_Id}=                     Browser.Get Text                        ${SOM_Processo_Id}
        ${Processo_Nome}=                   Browser.Get Text                        ${SOM_Processo_Nome}
        ${Processo_Status}=                 Browser.Get Text                        ${SOM_Processo_Status}

        Should Be Equal As Strings          ${pendencia}                            7111 - VERIFICAR BACKBONE TENANT        ignore_case=true
        Should Be Equal As Strings          ${obs_encerramento}                     Encerramento Pendencia                  ignore_case=true
        Should Be Equal As Strings          ${Classe_Produto}                       BIT                                     ignore_case=true
        Should Be Equal As Strings          ${Habilitado}                           true                                    ignore_case=true
        Should Be Equal As Strings          ${Codigo_Ativacao}                      4929                                    ignore_case=true
        Should Be Equal As Strings          ${SVLAN}                                3641                                    ignore_case=true
        Should Be Equal As Strings          ${Nome_Atividade}                       T017 - Instalar Equipamento             ignore_case=true
        Should Be Equal As Strings          ${NumeroBA}                             ${Numero_BA}                            ignore_case=true
        Should Be Equal As Strings          ${Codigo_Encerrament}                   7111                                    ignore_case=true
        Should Be Equal As Strings          ${BilheteAtividade_Observacoes}         Encerramento Pendencia                  ignore_case=true
        Should Be Equal As Strings          ${ProcessoId}                           ${Processo_Id}                          ignore_case=true
        Should Be Equal As Strings          ${Processo_Nome}                        Instalação                              ignore_case=true
        Should Be Equal As Strings          ${Processo_Status}                      Em Tramitação                           ignore_case=true


        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[1]
        ${Tarefa_T017}=                     Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[1]
        ${Tarefa_T017_Status}=              Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[1]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])
        ${Tarefa_T017_Encerramento}=        Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[1]/../../../../../../../..//*[text()="Tipo de Encerramento"]/../../../../..//*[@value="Abrir Pendência Tenant"])

        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="TA - Tratar Pendência Tenant"])[1]
        ${Tarefa_TA}=                       Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="TA - Tratar Pendência Tenant"])[1]
        ${Tarefa_TA_Status}=                Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="TA - Tratar Pendência Tenant"])[1]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])
        ${Tarefa_TA_CodPendencia}=          Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="TA - Tratar Pendência Tenant"])[1]/../../../../../../../..//*[text()="Código de Pendência"]/../../../../..//*[@value="7111"])
        ${Tarefa_TA_GrupoPendencia}=        Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="TA - Tratar Pendência Tenant"])[1]/../../../../../../../..//*[text()="Grupo da Pendencia"]/../../../../..//*[@value="VERIFICAR BACKBONE TENANT"])
    
    ELSE IF    ${VALIDACAO} == 2

        ${NumeroBA}=                        Ler Variavel na Planilha                workOrderId                             Global
        ${ProcessoId}=                      Ler Variavel na Planilha                workOrderId                             Global

        ${Classe_Produto}=                  Browser.Get Text                        ${SOM_Classe_Produto}
        ${Habilitado}=                      Browser.Get Text                        ${SOM_Habilitado}
        ${Codigo_Ativacao}=                 Browser.Get Text                        ${SOM_Codigo_Ativacao}
        ${SVLAN}=                           Browser.Get Text                        ${SOM_SVLAN}
        ${QVLAN}=                           Browser.Get Text                        ${SOM_QVLAN}
        ${CVLAN2}=                          Browser.Get Text                        ${SOM_CVLAN2}
        ${SVLAN2}=                          Browser.Get Text                        ${SOM_SVLAN2}
        ${QVLAN2}=                          Browser.Get Text                        ${SOM_QVLAN2}
        ${Nome_Atividade}=                  Browser.Get Text                        ${SOM_Nome_Atividade}
        ${Numero_BA}=                       Browser.Get Text                        ${SOM_Numero_BA}
        ${Codigo_Encerrament}=              Browser.Get Text                        ${SOM_Codigo_Encerramento}
        ${BilheteAtividade_Observacoes}=    Browser.Get Text                        ${SOM_BilheteAtividade_Observacoes}
        ${Processo_Id}=                     Browser.Get Text                        ${SOM_Processo_Id}
        ${Processo_Nome}=                   Browser.Get Text                        ${SOM_Processo_Nome}
        ${Processo_Status}=                 Browser.Get Text                        ${SOM_Processo_Status}

        Should Be Equal As Strings          ${Classe_Produto}                       BIT                                     ignore_case=true
        Should Be Equal As Strings          ${Habilitado}                           true                                    ignore_case=true
        Should Be Equal As Strings          ${Codigo_Ativacao}                      4929                                    ignore_case=true
        Should Be Equal As Strings          ${SVLAN}                                3641                                    ignore_case=true
        Should Be Equal As Strings          ${CVLAN2}                               2                                       ignore_case=true
        Should Be Equal As Strings          ${SVLAN2}                               3641                                    ignore_case=true
        Should Be Equal As Strings          ${QVLAN2}                               2                                       ignore_case=true
        Should Be Equal As Strings          ${Nome_Atividade}                       T017 - Instalar Equipamento             ignore_case=true
        Should Be Equal As Strings          ${NumeroBA}                             ${Numero_BA}                            ignore_case=true
        Should Be Equal As Strings          ${Codigo_Encerrament}                   7111                                    ignore_case=true
        Should Be Equal As Strings          ${BilheteAtividade_Observacoes}         Encerramento Pendencia                  ignore_case=true
        Should Be Equal As Strings          ${ProcessoId}                           ${Processo_Id}                          ignore_case=true
        Should Be Equal As Strings          ${Processo_Nome}                        Instalação                              ignore_case=true
        Should Be Equal As Strings          ${Processo_Status}                      Em Tramitação                           ignore_case=true

        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[1]
        ${Tarefa_T017_1}=                   Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[1]
        ${Tarefa_T017_Status_1}=            Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[1]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])
        
        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[2]
        ${Tarefa_T017_2}=                   Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[2]
        ${Tarefa_T017_Status_2}=            Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[2]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])
        ${Tarefa_T017_Encerramento}=        Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"])[2]/../../../../../../../..//*[text()="Observação de Abertura"]/../../../../..//*[@value="Resolucao de pendencia de rede"]
        ${Tarefa_T017_Codigo}=              Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T017 - Instalar Equipamento"]/../../../../../../../..//*[text()="Código de Pendência"]/../../../../..//*[@value="7111"])
        
        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T046 - Associar Equipamento - Manual"])[1]
        ${Tarefa_T046_1}=                   Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T046 - Associar Equipamento - Manual"])[1]
        ${Tarefa_T046_Status_1}=            Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T046 - Associar Equipamento - Manual"])[1]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])
        
        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T046 - Associar Equipamento - Manual"])[2]
        ${Tarefa_T046_2}=                   Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T046 - Associar Equipamento - Manual"])[2]
        ${Tarefa_T046_Status_2}=            Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T046 - Associar Equipamento - Manual"])[2]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])

        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T037 - Solicitar Troca de CDOE"])[1]
        ${Tarefa_T037_1}=                   Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T037 - Solicitar Troca de CDOE"])[1]
        ${Tarefa_T037_Status_1}=            Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T037 - Solicitar Troca de CDOE"])[1]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])
        
        Scroll To Element                   xpath=(//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T037 - Solicitar Troca de CDOE"])[2]
        ${Tarefa_T037_2}=                   Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T037 - Solicitar Troca de CDOE"])[2]
        ${Tarefa_T037_Status_2}=            Browser.Get Text                        ((//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T037 - Solicitar Troca de CDOE"])[2]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])
        
    ELSE
        Fatal Error             \nValidação inválida. Escolha entre a validação 1 ou 2.
    END

#===========================================================================================================================================================================================================
Verificar se existe complemento e validar

    [Documentation]                         Verifica se existe complemento ou não, para depois validar

    ${EXIST}=                               Ler Variavel na Planilha                typeComplement1                         Global
        
        IF    "${EXIST}" != "None"
            ${TypeComplement1}=             Ler Variavel na Planilha                typeComplement1                         Global
            ${Value1}=                      Ler Variavel na Planilha                value1                                  Global

            ${SOM_Tipo_Complemento}=        Browser.Get Text                        ${SOM_Tipo_Complemento_1}
            ${SOM_Complemento}=             Browser.Get Text                        ${SOM_Complemento_1}

            Should Be Equal As Strings      ${TypeComplement1}                      ${SOM_Tipo_Complemento}                 ignore_case=true
            Should Be Equal As Strings      ${Value1}                               ${SOM_Complemento}                      ignore_case=true
        END

################################################################################################################################################################################
Tramitar Reparo SOM
    [Documentation]                         Tramitar no SOM o Reparo até o Encerramento
    [Arguments]                             ${VALOR_PESQUISA}=associatedDocument
    ...                                     ${TASK_NAME}=T052 - Analisar Chamado Tecnico
    ...                                     ${ORDER_TYPE}=Vtal Fibra Chamado Tecnico Ordem	
    ...                                     ${ORDER_STATE}=In Progress
    ...                                     ${TENTATIVAS_FOR}=15

    Login SOM
       
    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                ${VALOR_PESQUISA}                       Global
    
    #Pesquisa pela QUERY
    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                        ${VALOR_PESQUISA}
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_search}
  
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="${ORDER_STATE}"])[1]    Visible    10
            IF    ${EXIST} == True
            
                Take Screenshot Web Element is visible                              //tr[@class="context-menu-target"]/../..

                IF    "${ORDER_STATE}" != "NULL"
                    ${ORDER_STATE_SOM}=     Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order State"                           1
                    Scroll To Element                                               ${ORDER_STATE_SOM}
                    Take Screenshot Web Element is visible                          ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Browser.Get Text                        ${ORDER_STATE_SOM}
                    
                    IF    "${ORDER_STATE}" != "${ORDER_STATE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder State está ${ORDER_STATE_SOM}, esperado é ${ORDER_STATE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END
                
                IF    "${ORDER_TYPE}" != "NULL"
                    ${ORDER_TYPE_SOM}=      Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order Type"                            1
                    Scroll To Element                                               ${ORDER_TYPE_SOM}
                    Take Screenshot Web Element is visible                          ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Browser.Get Text                        ${ORDER_TYPE_SOM}

                    IF    "${ORDER_TYPE}" != "${ORDER_TYPE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder Type está ${ORDER_TYPE_SOM}, esperado é ${ORDER_TYPE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    ELSE IF    "${ORDER_TYPE}" == "${ORDER_TYPE_SOM}" and "${TASK_NAME}" == "NULL"                       
                        BREAK
                    END
                END
                
                IF    "${TASK_NAME}" != "NULL"
                    ${TASK_NAME_SOM}=       Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Task Name"                             1
                    Scroll To Element                                               ${TASK_NAME_SOM}
                    Take Screenshot Web Element is visible                          ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Browser.Get Text                        ${TASK_NAME_SOM}

                    IF    "${TASK_NAME}" == "${TASK_NAME_SOM}"
                        BREAK
                    ELSE IF    "${TASK_NAME}" != "${TASK_NAME_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error             \n${TASK_NAME} não foi encontrado no SOM
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END

            ELSE
                Click Web Element Is Visible            ${SOM_btn_refresh}
                IF    ${x} == ${TENTATIVAS_FOR}-1
                    Fatal Error             \n${ORDER_STATE} não foi encontrado no SOM
                END
            END
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}
    
    # Valida associatedDocument
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    
    ${Ordem_numeroPedido}=                  Browser.Get Text                        ${SOM_Ordem_numeroPedido}

    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true           

    #Processo de tramitação no SOM
    Click Web Element Is Visible            ${SOM_btn_edit_order}
    Select Options By                       ${SelectTipoMotivo}                     value                                   Resolução do Reparo                     
    Click Web Element Is Visible            ${LupaResultadoAnalise}    

    #Nova janela do SOM - Clicar no ONT - Desconfigurada/Divergente
    Switch Page                             NEW
    Sleep                                   3s
    Click Web Element Is Visible            ${ButtonONTDesconfigurada}

    #Preenchimento dos campos obrigatorios 
    Input Text Web Element Is Visible       ${SOM_observacao}                       Reparo com encerramento externo
    Sleep                                   3s
    Click Web Element Is Visible            ${LupaMotivo}
    
    #Nova janela do SOM - Clicar no Acao interna realizada na Vtal: Efetuada configuracao rede wi-fi (canal/criptografia/senha).
    Switch Page                             NEW
    Sleep                                   3s
    Click Web Element Is Visible            ${ButtonMotivoReparo}
    
    #Finalizar o processo de tramitação no SOM
    Select Element is Visible               ${SOM_Select_pendencia}                 Resolver reparo
    Click Web Element Is Visible            ${SOM_btnUpdate}
#===================================================================================================================================================================
Pesquisa Tarefa no SOM
    [Arguments]                             ${VALOR_PESQUISA}=associatedDocument
    ...                                     ${TASK_NAME}=T017 - Instalar Equipamento
    ...                                     ${TENTATIVAS_FOR}=15

    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                ${VALOR_PESQUISA}                       Global

    #PESQUISAR PELO REFERENCE
    Input Text Web Element Is Visible       ${SOM_Ref_Input}                        ${VALOR_PESQUISA}
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_refresh}

    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}

    # VALIDA SE A TAREFA ESTÁ CORRETA ANTES DE INICIAR A TRAMITAÇÃO
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="${TASK_NAME}"])      Visible    10
        IF    ${EXIST} == True
            BREAK
        ELSE
            Click Web Element Is Visible            ${SOM_btn_refresh}
            IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error             \n${TASK_NAME} não foi encontrado no SOM
            END
        END
    END

#===================================================================================================================================================================
Validar Criação de Reparo Voip no SOM
    [Documentation]                         Função usada para validar um evento de reparo Voip no SOM. Ao final, salva o número da ordem (SA) na planilha.

    [Arguments]                             ${VALOR_PESQUISA}=associatedDocument
    ...                                     ${TASK_NAME}=T039 - Executar BA de Planta Externa
    ...                                     ${ORDER_TYPE}=Vtal Fibra Reparo
    ...                                     ${ORDER_STATE}=In Progress
    ...                                     ${TENTATIVAS_FOR}=15


    Login SOM
    
    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                ${VALOR_PESQUISA}                       Global

    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_from}                       ${VALOR_PESQUISA}
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_search}

    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}


    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="${ORDER_STATE}"])[1]    Visible    10
            IF    ${EXIST} == True
            
                # Take Screenshot Web Element is visible                              //tr[@class="context-menu-target"]/../..

                IF    "${ORDER_STATE}" != "NULL"
                    ${ORDER_STATE_SOM}=     Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order State"                           1
                    # Scroll To Element                                               ${ORDER_STATE_SOM}
                    # Take Screenshot Web Element is visible                          ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Browser.Get Text                        ${ORDER_STATE_SOM}
                    ${ORDER_STATE_SOM}=     Strip String                            ${ORDER_STATE_SOM}

                    IF    "${ORDER_STATE}" != "${ORDER_STATE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder State está ${ORDER_STATE_SOM}, esperado é ${ORDER_STATE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END
                
                IF    "${ORDER_TYPE}" != "NULL"
                    ${ORDER_TYPE_SOM}=      Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order Type"                            1
                    # Scroll To Element                                               ${ORDER_TYPE_SOM}
                    # Take Screenshot Web Element is visible                          ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Browser.Get Text                        ${ORDER_TYPE_SOM}
                    ${ORDER_TYPE_SOM}=      Strip String                            ${ORDER_TYPE_SOM}

                    IF    "${ORDER_TYPE}" != "${ORDER_TYPE_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error     \nOrder Type está ${ORDER_TYPE_SOM}, esperado é ${ORDER_TYPE}
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    ELSE IF    "${ORDER_TYPE}" == "${ORDER_TYPE_SOM}" and "${TASK_NAME}" == "NULL"                       
                        BREAK
                    END
                END
                
                IF    "${TASK_NAME}" != "NULL"
                    ${TASK_NAME_SOM}=       Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Task Name"                             1
                    # Scroll To Element                                               ${TASK_NAME_SOM}
                    # Take Screenshot Web Element is visible                          ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Browser.Get Text                        ${TASK_NAME_SOM}
                    ${TASK_NAME_SOM}=       Strip String                            ${TASK_NAME_SOM}

                    IF    "${TASK_NAME}" == "${TASK_NAME_SOM}"
                        BREAK
                    ELSE IF    "${TASK_NAME}" != "${TASK_NAME_SOM}"
                        IF    ${x} == ${TENTATIVAS_FOR}-1
                            Fatal Error             \n${TASK_NAME} não foi encontrado no SOM
                        END
                        Sleep               10s
                        Click Web Element Is Visible                                ${SOM_btn_refresh}
                    END
                END

            ELSE
                Click Web Element Is Visible            ${SOM_btn_refresh}
                IF    ${x} == ${TENTATIVAS_FOR}-1
                    Fatal Error             \n${ORDER_STATE} não foi encontrado no SOM
                END
            END
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Sleep                                   3s
    Click Web Element Is Visible            (//input[contains(@name,'move')])[1]
    Sleep                                   3s
    Wait For Elements State                 ${SOM_Ordem_numeroCOM}                  visible                                 timeout=${TIMEOUT}

    ${WorkOrder_ID}=                        Browser.Get Text                        ${SOM_Numero_BA}
    Escrever Variavel na Planilha           ${WorkOrder_ID}                         workOrderId                             Global

    ${nomeAtividade}=                       Browser.Get Text                        ${SOM_Nome_Atividade}
    ${comOrderServiceSOM}=                  Browser.Get Text                        ${SOM_Ordem_numeroCOM}
    ${associatedDocumentSOM}=               Browser.Get Text                        ${SOM_Ordem_numeroPedido}
    ${TipoOrdemSOM}=                        Browser.Get Text                        ${SOM_Ordem_tipo}
    # ${clienteNomeSOM}=                      Browser.Get Text                        ${SOM_Cliente_nome}
    ${clienteEmpresaSOM}=                   Browser.Get Text                        ${SOM_Cliente_empresa}

    ${comOrderService}=                     Ler Variavel na Planilha                comOrderService                         Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global

    Should Be Equal As Strings              ${nomeAtividade}                        T039 - Executar BA de Planta Externa    ignore_case=true
    Should Be Equal As Strings              ${comOrderServiceSOM}                   ${comOrderService}                      ignore_case=true
    Should Be Equal As Strings              ${associatedDocumentSOM}                ${associatedDocument}                   ignore_case=true
    Should Be Equal As Strings              ${TipoOrdemSOM}                         Reparo                                  ignore_case=true
    # Should Be Equal As Strings              ${clienteNomeSOM}                       Voip Internet                           ignore_case=true
    Should Be Equal As Strings              ${clienteEmpresaSOM}                    Oi                                      ignore_case=true