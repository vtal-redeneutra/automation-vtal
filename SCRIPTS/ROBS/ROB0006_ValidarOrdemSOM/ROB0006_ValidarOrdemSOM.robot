*** Settings ***
Documentation                               Validar Ordem SOM
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/SOM/UTILS.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ../../RESOURCE/SOM/PAGE_OBJECTS.robot

Library                                     Browser
Library                                     String


*** Variables ***
# ${DAT_CENARIO}                            C:/IBM_VTAL/DATA/DAT013_RealizarAtivacaoCanceladaAntesAtividadeCampo.xlsx
${APPOINTMENTSTART}


# *** Test Cases ***
# cenario OS
#     Valida Campo OS

*** Keywords ***
Validar Ordem SOM Sucesso
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, alterar o filtro, consultar e validar uma Ordem no sistema SOM, através do Order ID
    ...                                     para cenários com sucesso.                 


    [Tags]                                  ValidaSOMSucesso
    Login SOM
    Altera Filtro Consulta Order ID
    Valida Campo Sucesso
    Close Browser                           CURRENT



Validar Ordem SOM Pendencia
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, alterar o filtro, consultar e validar uma Ordem no sistema SOM, através do Order ID
    ...                                     para cenários com pendência/tratamento.  

    [Tags]                                  ValidaSOMPendencia
    Login SOM
    Altera Filtro Consulta Order ID
    Valida Campo Pendencia
    Close Browser                           CURRENT



Valida Ordem SOM Finalizada com sucesso
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM, através do Associated_Document
    ...                                     para cenários com SA fechada com sucesso.

    [Tags]                                  ValidaSOMFinalizaSucesso
    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                      Global
    Set Global Variable                     ${Associated_Document}
    Login SOM
    Valida OS Completa
    Close Browser                           CURRENT

Valida Ordem SOM Bloqueada
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, verificar o argumento, consultar e validar uma Ordem no sistema SOM para cenários com bloqueio através do BlockId.
    ...                                     \n  Argumentos utilizados na velocidade (Ex.: 1000) e tipo de cenário (Ex.: FTTH) 
    [Tags]                                  ValidaSOMBloqueada
    [Arguments]                             ${VELOCIDADE}=1000                      ${FTTH_ou_FTTP}=FTTH

    Login SOM
    Valida OS Bloqueada                     ${VELOCIDADE}                           ${FTTH_ou_FTTP}
    Close Browser                           CURRENT

Valida Ordem SOM Desbloqueio
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM para cenários com Desbloqueio através do IdDesbloqueio.

    [Tags]                                  ValidaSOMDesbloqueada
    ${IdDesbloqueio}                        Ler Variavel na Planilha                IdDesbloqueio                           Global
    Set Global Variable                     ${IdDesbloqueio}
    Login SOM
    Valida OS Desbloqueio
    Close Browser                           CURRENT

Valida Ordem SOM Retirada
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM para cenários com retirada através do SOM_Order_Id .


    [Tags]                                  ValidaSOMRetirada
    Login SOM
    Valida OS Retirada
    Close Browser                           CURRENT

Valida Ordem SOM Retirada Cancelada
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do SOM_Order_Id para cenários com retirada cancelada.
    [Tags]                                  ValidaSOMRetirada
    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                          Global
    Set Global Variable                     ${Associated_Document}
    Login SOM
    Valida OS Retirada Cancelada
    Close Browser                           CURRENT

Validacao da OS Completa FTTP
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do SOM_Order_Id para cenários com OS Completa em FTTP.
    [Tags]                                  ValidaSOMCompletaFTTP

    Login SOM
    Valida OS Completa FTTP
    Close Browser                           CURRENT


Validacao da OS Bloqueada FTTP    
    [Arguments]                             ${VELOCIDADE}
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do BlockId para cenários com bloqueio em FTTP.
    [Tags]                                  ValidaSOMBloqueadaFTTP

    Login SOM
    Valida OS Bloqueada FTTP                ${VELOCIDADE}
    Close Browser                           CURRENT    
 

Valida Ordem SOM Desbloqueio FTTP
   
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do IdDesbloqueio para cenários com desbloqueio em FTTP.
    [Tags]                                  ValidaSOMDesbloqueada
    [Arguments]                             ${VELOCIDADE}=1000

    Login SOM
    Valida OS Desbloqueio em FTTP           ${VELOCIDADE}
    Close Browser                           CURRENT


Validar Ordem SOM Enriquecimento
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do SOM_Order_Id para cenários com enriquecimento.

    [Tags]                                  ValidarOrdemSOMEnriquecimento
    Login SOM
    Validar Enriquecimento SOM
    Close Browser                           CURRENT


Validar Ordem SOM Retirada Completa
    #Se nenhuma velocidade for passada como argumento, fica como 1000 e FTTH
   
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do SOM_Order_Id para cenários com retirada completa.
    ...                                     \n  Argumentos utilizados na velocidade (Ex.: 1000) e tipo de cenário (Ex.: FTTH) 

    [Tags]                                  ValidarOrdemSOMRetiradaCompleta
    [Arguments]                             ${FTTH_ou_FTTP}=FTTH                    ${VELOCIDADE}=1000                      ${bit_true_false}=false            
    Login SOM
    Validar Conclusao OS Retirada           ${FTTH_ou_FTTP}                         ${VELOCIDADE}                           ${bit_true_false}                  
    Close Browser                           CURRENT

Valida Cancelamento do chamado tecnico
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do TroubleTicket para cenários com 
    ...                                     cancelamento do chamado técnico.

    [Tags]                                  ValidaTroubleTicketCancelado
    ${TroubleTicket}=                       Ler Variavel na Planilha                troubleTicket                           Global
    Set Global Variable                     ${TroubleTicket}
    Login SOM
    Valida TroubleTicket Cancelado
    Close Browser                           CURRENT

Valida Encerramento Retirada troubleTicket
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para fazer login, consultar e validar uma Ordem no sistema SOM através do troubleTicket_id para cenários com 
    ...                                     encerramento retirada troubleTicket.
    [Tags]                                  ValidaTroubleTicketEncerramento
    ${troubleTicket_id}=                    Ler Variavel na Planilha                troubleTicketId                         Global
    Set Global Variable                     ${troubleTicket_id} 
    Login SOM
    Validar Conclusao OS Trouble Ticket
    Close Browser                           CURRENT

#===========================================================================================================================================================================================================
Valida Campo Sucesso 

    [Documentation]                         Função usada para mapear elementos, consultar e validar a mensagem "T017 - Instalar Equipamento" no sistema SOM para cenários com 
    ...                                     sucesso.
    

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

        IF  "${value}" == "T017 - Instalar Equipamento"
            log to console                  "task name validado"
            Click Web Element Is Visible    xpath=(//input[@value='...'])[${row}]
            Exit For Loop
        END
    END



#===========================================================================================================================================================================================================
Valida Campo Pendencia
    [Documentation]                         Função usada para mapear elementos, consultar e validar a mensagem "I002 - Tratar Pendncia Cliente" no sistema SOM para cenários com 
    ...                                     com pendência.

    FOR         ${1}    IN RANGE    ${10}

        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1

        ${taskName}=                        Get Table Cell Element                  //*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Task Name"     ${row}
        ${value}=                           Get Text Element is Visible             ${taskName}

        IF  "${value}" == "I002 - Tratar Pendencia Cliente"
             Click Web Element Is Visible    xpath=(//input[@value='...'])[${row}]
            Exit For Loop
        ELSE
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        END

    END

#===========================================================================================================================================================================================================
Valida Mudanca Velocidade SOM
    [Documentation]                         Função usada para logar, mapear elementos, consultar e validar a mudança de velocidade e produtos adicionas e removidos no sistema SOM.
   
    [Arguments]                             ${VELOCIDADE_ADD}                       ${VELOCIDADE_REMOVE}
   
    [Tags]                                  ValidaMudancaVelocidadeSOM

    ${correlationOrder}=                    Ler Variavel na Planilha                somOrderId                            Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                     Global
    ${infraType}=                           Ler Variavel na Planilha                infraType                               Global
    # ${customerName}=                        Ler Variavel na Planilha                customerName                           Global
    ${addressId}=                           Ler Variavel na Planilha                addressId                              Global
    ${inventoryId}=                         Ler Variavel na Planilha                inventoryId                            Global
    ${tipoOrdem}=                           Ler Variavel na Planilha                Type                                    Global    
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                           Global
    ${data_abertura}=                       Ler Variavel na Planilha                validateDate                            Global
    # ${tpLogradouro}=                        Ler Variavel na Planilha                typeLogradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                addressName                            Global
    # ${numero}=                              Ler Variavel na Planilha                Number                                  Global
    # ${bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    # ${cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    # ${uf}=                                  Ler Variavel na Planilha                UF                                      Global
    # ${cep}=                                 Ler Variavel na Planilha                Address                                 Global
    ${ref}=                                 Ler Variavel na Planilha                Reference                               Global

    Login SOM
    Valida Mudanca de Velocidade

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
    ${Origem_Ordem}=                        Browser.Get Text                        ${SOM_Origem_Solicitacao}
    ${Empresa_Name}=                        Browser.Get Text                        ${SOM_Cliente_empresa}
    ${Contrato_Id}=                         Browser.Get Text                        ${SOM_Cliente_idContrato}
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    
    # FOR    ${x}    IN RANGE    3
    #     ${n}=                               Evaluate                                ${x}+1
    #     ${type_comp}=                       Ler Variavel na Planilha                typeComplement${n}                      Global
        
    #     IF    "${type_comp}" != "None"
    #         ${comp_value}=                  Ler Variavel na Planilha                value${n}                               Global

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
    #Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    Should Be Equal As Strings              ${Abertura_Pedido}                      ${data_abertura}
    Should Be Equal As Strings              ${Origem_Ordem}                         TRGIBMFTTP
    Should Be Equal As Strings              ${Empresa_Name}                         TRGIBMFTTP
    Should Be Equal As Strings              ${Contrato_Id}                          ${subscriberId}            
    #Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}
    #Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}           
    #Should Be Equal As Strings              ${Endereco_numero}                      ${numero}
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}
    Should Be Equal As Strings              ${Endereco_ref}                         ${ref}

    Scroll To Element                       ${SOM_NomeDoProdutoAdd}

    ${NomeDoProdutoAdd}=                    Browser.Get Text                        ${SOM_NomeDoProdutoAdd}
    ${TecnologiaProdutoAdd}=                Browser.Get Text                        ${SOM_TecnologiaAdd}
    ${TipoDeProdutoAdd}=                    Browser.Get Text                        ${SOM_TipoDeProdutoAdd}
    ${IdDoCatalogoAdd}=                     Browser.Get Text                        ${SOM_IdCatalogAdd}
    ${AcaoAdd}=                             Browser.Get Text                        ${SOM_AcaoAdd}        

    Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE_ADD}MBPS
    Should Be Equal As Strings              ${TecnologiaProdutoAdd}                 ${infraType}
    Should Be Equal As Strings              ${IdDoCatalogoAdd}                      BL_${VELOCIDADE_ADD}MB
    Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    Should Be Equal As Strings              ${AcaoAdd}                              adicionar


    ## Validação dos Produtos Adicionados > Atributos
    @{productList}=                         Create List                             Velocidade    Download    Upload
    Set Global Variable                     ${productList}

    FOR    ${x}    IN RANGE    3
        ${xpathPosition}=                   Evaluate                                ${x}+1

        ${nomeAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[2]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input     
        ${valorAtributoXPATH}               Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[2]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Valor"]/../../../../..//input
        ${acaoAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[2]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Ação"]/../../../../..//input
    
        Scroll To Element                   //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input

        ${nomeAtributo}=                    Browser.Get Text                        ${nomeAtributoXPATH}
        ${valorAtributo}=                   Browser.Get Text                        ${valorAtributoXPATH}
        ${acaoAtributo}=                    Browser.Get Text                        ${acaoAtributoXPATH}

        IF    "${productList[${x}]}" == "Upload"

            ${uploadVelocity}=              Evaluate                                ${VELOCIDADE_ADD}/2
            Should Be Equal As Strings      ${valorAtributo}.0                      ${uploadVelocity}

        ELSE IF    "${productList[${x}]}" == "Velocidade"    
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE_ADD} MBPS
        
        ELSE IF    "${productList[${x}]}" == "Upload"
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE_ADD}
        END 

        Should Be Equal As Strings          ${productList[${x}]}                    ${nomeAtributo}                                                                  
        Should Be Equal As Strings          ${acaoAtributo}                         adicionar
    END
    

    Scroll To Element                       ${SOM_NomeDoProdutoRemove}

    ${NomeDoProdutoRemove}=                 Browser.Get Text                        ${SOM_NomeDoProdutoRemove}
    ${TecnologiaProdutoRemove}=             Browser.Get Text                        ${SOM_TecnologiaRemove}
    ${TipoDeProdutoRemove}=                 Browser.Get Text                        ${SOM_TipoDeProdutoRemove}
    ${IdDoCatalogoRemove}=                  Browser.Get Text                        ${SOM_IdCatalogRemove}
    ${AcaoRemove}=                          Browser.Get Text                        ${SOM_AcaoRemove}        

    Should Be Equal As Strings              ${NomeDoProdutoRemove}                  VELOC_${VELOCIDADE_REMOVE}MBPS
    Should Be Equal As Strings              ${TecnologiaProdutoRemove}              ${infraType}
    Should Be Equal As Strings              ${IdDoCatalogoRemove}                   BL_${VELOCIDADE_REMOVE}MB
    Should Be Equal As Strings              ${TipoDeProdutoRemove}                  Banda Larga
    Should Be Equal As Strings              ${AcaoRemove}                           remover


    ## Validação dos Produtos Removidos > Atributos
    @{productList}=                         Create List                             Velocidade    Download    Upload
    Set Global Variable                     ${productList}

    FOR    ${x}    IN RANGE    3
        ${xpathPosition}=                   Evaluate                                ${x}+1

        ${nomeAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input     
        ${valorAtributoXPATH}               Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Valor"]/../../../../..//input
        ${acaoAtributoXPATH}                Set Variable                            //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Ação"]/../../../../..//input
    
        Scroll To Element                   //*[text()="Produto"]/../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[2]//*[text()="Atributo"]/../../../../../../.././div/div[${xpathPosition}]//*[text()="Nome"]/../../../../..//input

        ${nomeAtributo}=                    Browser.Get Text                        ${nomeAtributoXPATH}
        ${valorAtributo}=                   Browser.Get Text                        ${valorAtributoXPATH}
        ${acaoAtributo}=                    Browser.Get Text                        ${acaoAtributoXPATH}

        IF    "${productList[${x}]}" == "Upload"

            ${uploadVelocity}=              Evaluate                                ${VELOCIDADE_REMOVE}/2
            Should Be Equal As Strings      ${valorAtributo}.0                      ${uploadVelocity}

        ELSE IF    "${productList[${x}]}" == "Velocidade"    
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE_REMOVE} MBPS
        
        ELSE IF    "${productList[${x}]}" == "Upload"
            Should Be Equal As Strings      ${valorAtributo}                        ${VELOCIDADE_REMOVE}
        END 

        Should Be Equal As Strings          ${productList[${x}]}                    ${nomeAtributo}                                                                  
        Should Be Equal As Strings          ${acaoAtributo}                         remover
    END

    Scroll To Element                       ${SOM_Ordem_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Ordem_Block} 
    
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    Close Browser                           CURRENT
#===========================================================================================================================================================================================================
Valida Abertura de reparo
    [Documentation]                         Função usada para consultar e validar a mensagem "P12 - Chamado Tecnico" no sistema SOM para cenários com 
    ...                                     abertura de reparo.

    [Tags]                                  ValidaMudancaVelocidadeSOM

    Login SOM

    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    ${infraType}=                           Ler Variavel na Planilha                infraType                               Global
    ${Type}=                                Ler Variavel na Planilha                Type                                    Global
    # ${customerName}=                        Ler Variavel na Planilha                customerName                           Global
    ${troubleTicket_id}=                    Ler Variavel na Planilha                troubleTicketId                         Global

    
    Input Text Web Element Is Visible       ${SOM_order_input}                      ${troubleTicket_id}
    Click Web Element Is Visible            ${SOM_btn_search}

    ${order_state}=                         Get Text Element is Visible             ${SOM_order_state_reparo}
    IF  "${order_state}" != "P12 - Chamado Tecnico"
        Fatal Error                         Order State está diferente de P12 - Chamado Tecnico
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Get Text Element is Visible Valida      ${SOM_Ordem_numeroPedido}               ==                                      ${associatedDocument}
    Get Text Element is Visible Valida      ${SOM_infraType}                        ==                                      ${infraType}                                       
    Get Text Element is Visible Valida      ${SOM_Ordem_tipo}                       ==                                      ${Type}                                 
    # Get Text Element is Visible Valida      ${SOM_Cliente_nome}                     ==                                      ${customerName}                            

    Close Browser                           CURRENT
#===========================================================================================================================================================================================================
Validar Abertura de reparo com Pendencia 

    [Documentation]                         Função usada para fazer login, alterar o filtro, consultar e validar a mensagem "T070 - Agendamento do Reparo" no sistema SOM
    ...                                     para cenários com abertura de reparo com pendência.  
    Login SOM
    Altera Filtro Consulta Order ID

    FOR         ${1}    IN RANGE    ${10}
        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1
    
        IF  ${row_count} != 3
            Click Web Element Is Visible    ${SOM_btn_refresh}
            Sleep                           10s
        ELSE    
            Exit For Loop
        END 
    END


    FOR     ${row}    IN RANGE    ${row_count}
    
        ${taskName}=                        Get Table Cell Element                  //*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Task Name"     ${row}
        ${value}=                           Get Text Element is Visible             ${taskName}

        IF  "${value}" == "T070 - Agendamento do Reparo"
            log to console                  "task name validado"
            Exit For Loop
        END
    END

#===========================================================================================================================================================================================================
Valida Tratamento Pendencia Reparo
    [Documentation]                         Função usada para fazer login, alterar o filtro, consultar e validar a mensagem "T088 - Executar BA Planta Externa Chamado Tecnico" no sistema SOM
    ...                                     para cenários com abertura de reparo com pendência.     
    Login SOM
    Altera Filtro Consulta Order ID
    
    FOR         ${1}    IN RANGE    ${10}
        ${row_count}=                       Get Element Count is Visible            xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}=                             Set Variable                            1
    
        IF  ${row_count} != 3
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
            Exit For Loop
        END
    END

#===========================================================================================================================================================================================================