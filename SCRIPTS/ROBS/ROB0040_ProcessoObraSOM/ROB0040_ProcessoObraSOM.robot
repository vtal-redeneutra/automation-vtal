*** Settings ***
Documentation                               Scripts relacionados ao Processo de Obra.

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ${DIR_SOM}/UTILS.robot

*** Keywords ***
Realizar Processo de Obra
    [Documentation]                         Realiza processo de obra no SOM.
    
    Login SOM
    Altera Filtro Consulta Order ID         associatedDocument

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            (//td[contains(text(),"${Associated_Document}")]/..)
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Quantidade de linhas da tabela está diferente do esperado.
    END

    Order Update SOM                        T073U01 - Projeto de Rede - Atendimento Solicitado                              Em elaboração                           Vtal Fibra Obra
    Order Update SOM                        T073U03 - Projeto de Rede - Em Elaboração                                       Cadastro                                Vtal Fibra Obra
    Order Update SOM                        T075U01 - Cadastro de Rede                                                      Cadastro de rede\xa0concluído           Vtal Fibra Obra

    # Valida o Order Type e Task Name
    FOR         ${1}    IN RANGE    ${30}
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
   
    #Validação Dados de Pendência
    ${Pendencia_Nome}=                      Browser.Get Text                        (//div[@class="windowTitle"]//*[text()="Dados de Pendência"]/../../../..//div[@class="windowContent"]//div[@class="oeGroupNode"]/*[1]//input)
    Should Be Equal As Strings              ${Pendencia_Nome}                       7029 - AGENDAMENTO DO PEDIDO    
    Scroll To Element                       (//div[@class="windowTitle"]//*[text()="Dados de Pendência"]/../../../..)                                
    Take Screenshot Web Element is visible  (//div[@class="windowTitle"]//*[text()="Dados de Pendência"]/../../../..)

    #Validação Histórico de Tramitação
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    ${Tarefa1}=                             Browser.Get Text                        (//*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"])[1]                        
    ${Status1}=                             Browser.Get Text                        (//*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])

    ${Tarefa2}=                             Browser.Get Text                        (//*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]//*[@value="Notificar Pendência"])
    ${Status2}=                             Browser.Get Text                        (//*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]//*[@value="Notificar Pendência"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])

    ${Tarefa3}=                             Browser.Get Text                        (//*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]//*[@value="I002 - Tratar Pendencia Cliente"])
    ${Status3}=                             Browser.Get Text                        (//*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]//*[@value="I002 - Tratar Pendencia Cliente"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])
    
    ${Code_Pendencia}=                      Browser.Get Text                        (//*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]//*[@value="I002 - Tratar Pendencia Cliente"]/../../../../../../../..//*[text()="Código de Pendência"]/../../../../..//input[@value="7029"])
    
    Close Browser                           CURRENT


#===================================================================================================================================================================
Realizar Processo de Obra FTTP
   [Documentation]                         Realiza processo de obra no SOM.
    
    Login SOM
    Altera Filtro Consulta Order ID         associatedDocument

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            (//td[contains(text(),"${Associated_Document}")]/..)
    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Quantidade de linhas da tabela está diferente do esperado.
    END

    Order Update SOM                        T073U01 - Projeto de Rede - Atendimento Solicitado                              Em elaboração                           Vtal Fibra Obra
    Order Update SOM                        T073U03 - Projeto de Rede - Em Elaboração                                       Cadastro                                Vtal Fibra Obra
    Order Update SOM                        T075U01 - Cadastro de Rede                                                      Cadastro de rede\xa0concluído           Vtal Fibra Obra
    Close Browser                           CURRENT



#===================================================================================================================================================================
Order Update SOM
    [Documentation]                         Seleciona o modo editor, atualiza a ordem no SOM e valida o tipo de ordem referente à Task Name desejada.
    ...                                     -> Exemplo de chamada:
    ...                                     -> Order Update SOM                     T075U01 - Cadastro de Rede              Cadastro de rede concluído              OI Fibra Obra
    [Arguments]                             ${TASK_NAME}                            ${UPDATE_VALUE}                         ${ORDER_TYPE}

    Click Web Element Is Visible            (//table[@class="buttonBar"]//input[@value="oe"])
    
    #Valida o Order Type e Task Name
    ${order_type_Des}=                      Get Text Element is Visible             //td[contains(text(),"${TASK_NAME}")]            
    ${order_task_Name}=                     Get Text Element is Visible             (//td[contains(text(),"${TASK_NAME}")]/..)       

    Click Web Element Is Visible            (//td[contains(text(),"${TASK_NAME}")]/..//input[@value="..."])
    Select Element is Visible               (//form[@name="orderEditorMenu"]//select[@id="completionStatusList"])           ${UPDATE_VALUE}
    Click Web Element Is Visible            ${SOM_btnUpdate}
    Sleep                                   3s
    Altera Filtro Consulta Order ID         associatedDocument
#===================================================================================================================================================================
Valida Executar Processo de Obra
    [Documentation]                         Validação do Task Name "T072 - Executar Processo de Obra" no SOM e clica nos 3 pontinhos e valida informações.                                   
    [Arguments]                             ${FTTH_ou_FTTP}=FTTH                    ${VELOCIDADE}=1000                       

    Login SOM
    Altera Filtro Consulta Order ID         associatedDocument

    #Obtem o valor do SOM_ORDER_ID no SOM e Salva na planilha
    ${order_id_SOM}=                        Get Text Element is Visible             xpath=//span[normalize-space()='Order ID']/../../../../tr[3]/td[4]
    Escrever Variavel na Planilha           ${order_id_SOM}                         somOrderId                              Global

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            (//td[contains(text(),"${Associated_Document}")]/..)

    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Quantidade de linhas da tabela está diferente do esperado.
    END

    #Valida o Task Name, esperado é "T072 - Executar Processo de Obra"
    ${taskname_SOM}=                        Get Text Element is Visible             xpath=//span[normalize-space()="Task Name"]/../../../../tr[3]/td[12]
    IF  "${taskname_SOM}" != "T072 - Executar Processo de Obra"
        Fatal Error                         Task Name está diferente de "T072 - Executar Processo de Obra"
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            xpath=//span[normalize-space()="Task Name"]/../../../../tr[3]/td[12]//..//td[contains(@class,'tableAction')]//input[contains(@name,'move')]
    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}
    
    #Informações lidas da planilha
    ${infraType}=                           Set Variable                            ${FTTH_ou_FTTP}
    ${OSOrderId}=                           Ler Variavel na Planilha                osOrderId                               Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    # ${customerName}=                        Ler Variavel na Planilha                Customer_Name                           Global
    # ${addressId}=                           Ler Variavel na Planilha                Address_Id                              Global
    # ${inventoryId}=                         Ler Variavel na Planilha                Inventory_Id                            Global
    ${tipoOrdem}=                           Set Variable                            Instalacao    
    # ${tpLogradouro}=                        Ler Variavel na Planilha                Type_Logradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                Address_Name                            Global
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
    # ${Abertura_Pedido}=                     Browser.Get Text                        ${SOM_Ordem_dtAberturaPedido}
    # ${Origem_Ordem}=                        Browser.Get Text                        ${SOM_Origem_Solicitacao}
    # ${Empresa_Name}=                        Browser.Get Text                        ${SOM_Cliente_empresa}
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    # ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    #Comparação se as informações estão iguais da planilha
    Should Be Equal As Strings              ${Ordem_numeroCOM}                      ${OSOrderId}                            ignore_case=true
    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true           
    Should Be Equal As Strings              ${SOM_infra}                            ${infraType}                            ignore_case=true           
    Should Be Equal As Strings              ${Ordem_tipo}                           ${tipoOrdem}                            ignore_case=true
    # Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    # Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    # Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    # Should Be Equal As Strings              ${Origem_Ordem}                         ${NomeEmpresa}
    # Should Be Equal As Strings              ${Empresa_Name}                         ${NomeEmpresa}          
    # Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}           
    # Should Be Equal As Strings              ${Endereco_numero}                      ${numero}
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}

    Scroll To Element                       ${SOM_NomeDoProdutoAdd}

    ${NomeDoProdutoAdd}=                    Browser.Get Text                        ${SOM_NomeDoProdutoAdd} 
    ${TecnologiaProdutoAdd}=                Browser.Get Text                        ${SOM_TecnologiaAdd}  
    ${TipoDeProdutoAdd}=                    Browser.Get Text                        ${SOM_TipoDeProdutoAdd} 
    ${AcaoAdd}=                             Browser.Get Text                        ${SOM_AcaoAdd}        
    
    Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE}MBPS
    Should Be Equal As Strings              ${TecnologiaProdutoAdd}                 ${infraType}
    Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    Should Be Equal As Strings              ${AcaoAdd}                              adicionar

    #Validação Histórico de Tramitação
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    ${Tarefa_T001}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T001 - Solicitar Designacao de Recursos"])
    ${Status_T001}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T001 - Solicitar Designacao de Recursos"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])

    ${Tarefa_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"])
    ${Status_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])
    
    Close Browser                           CURRENT

#===========================================================================================================================================================================================================
Valida Executar Processo de Obra FTTP
    [Documentation]                         Validação no SOM para processo de obra FTTP e clica nos 3 pontinhos e valida informações.                                   
    [Arguments]                             ${VELOCIDADE}=1000

    Login SOM

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       //input[@name="/]reference_number_0"]                 ${Associated_Document}
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_search}

    #Atualiza até order state estar completed

    FOR    ${x}      IN RANGE     20
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="Completed"])[1]    Visible    10
        IF    ${EXIST} == True
            Click Web Element Is Visible            ${SOM_rb_Preview}
            Click Web Element Is Visible            xpath=//input[@value="..."][1]
            Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}
            BREAK
        ELSE
            Click Web Element Is Visible            ${SOM_btn_refresh}
            IF    ${x} == 19
                Fatal Error             \nOrder State não está como completed!
            END
        END
    END

    

    #Informações lidas da planilha
    ${infraType}=                           Set Variable                            FTTP
    ${SOM_ID}=                              Ler Variavel na Planilha                somOrderId                              Global
    ${OSOrderId}=                           Ler Variavel na Planilha                osOrderId                               Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    # ${customerName}=                        Ler Variavel na Planilha                Customer_Name                           Global
    ${addressId}=                           Ler Variavel na Planilha                addressId                               Global
    ${inventoryId}=                         Ler Variavel na Planilha                inventoryId                             Global
    ${tipoOrdem}=                           Set Variable                            Instalacao    
    # ${tpLogradouro}=                        Ler Variavel na Planilha                Type_Logradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                Address_Name                            Global
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
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    # ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    #Comparação se as informações estão iguais da planilha
    Should Be Equal As Strings              ${Ordem_numeroCOM}                      ${OSOrderId}                            ignore_case=true
    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true           
    Should Be Equal As Strings              ${SOM_infra}                            ${infraType}                            ignore_case=true           
    Should Be Equal As Strings              ${Ordem_tipo}                           ${tipoOrdem}                            ignore_case=true
    # Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    # Should Be Equal As Strings              ${Origem_Ordem}                         TRGIBMFTTP
    # Should Be Equal As Strings              ${Empresa_Name}                         TRGIBMFTTP          
    # Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}           
    # Should Be Equal As Strings              ${Endereco_numero}                      ${numero}
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}

    Scroll To Element                       ${SOM_NomeDoProdutoAdd}

    ${NomeDoProdutoAdd}=                    Browser.Get Text                        ${SOM_NomeDoProdutoAdd} 
    ${TecnologiaProdutoAdd}=                Browser.Get Text                        ${SOM_TecnologiaAdd}  
    ${TipoDeProdutoAdd}=                    Browser.Get Text                        ${SOM_TipoDeProdutoAdd} 
    ${AcaoAdd}=                             Browser.Get Text                        ${SOM_AcaoAdd}        
    
    Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE}MBPS
    Should Be Equal As Strings              ${TecnologiaProdutoAdd}                 ${infraType}
    Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    Should Be Equal As Strings              ${AcaoAdd}                              adicionar

    #Validação Histórico de Tramitação
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    ${Tarefa_T001}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T001 - Solicitar Designacao de Recursos"])[1]
    ${Status_T001}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T001 - Solicitar Designacao de Recursos"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])[1]

    ${Tarefa_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"])[1]
    ${Status_T072}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])
    
    Close Browser                           CURRENT


#===========================================================================================================================================================================================================
Valida Projeto de Rede
    [Documentation]                         Validação do Task Name "T073U01 - Projeto de Rede - Atendimento Solicitado" no SOM e clica nos 3 pontinhos e valida informações.                                   
    [Arguments]                             ${VELOCIDADE}=1000                      

    Login SOM
    Altera Filtro Consulta Order ID         associatedDocument

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            (//td[contains(text(),"${Associated_Document}")]/..)

    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Quantidade de linhas da tabela está diferente do esperado.
    END

    #Valida o Task Name, esperado é "T073U01 - Projeto de Rede - Atendimento Solicitado"
    ${taskname_SOM}=                         Get Text Element is Visible            xpath=//span[normalize-space()="Task Name"]/../../../../tr[2]/td[12]
    IF  "${taskname_SOM}" != "T073U01 - Projeto de Rede - Atendimento Solicitado"
        Fatal Error                         Task Name está diferente de "T073U01 - Projeto de Rede - Atendimento Solicitado"
    END
        
    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            xpath=//span[normalize-space()="Task Name"]/../../../../tr[2]/td[12]//..//td[contains(@class,'tableAction')]//input[contains(@name,'move')]
    Wait For Elements State                 ${SOM_btn_edit_order}                   visible                                 timeout=${TIMEOUT}

    #Informações lidas da planilha
    ${OSOrderId}=                           Ler Variavel na Planilha                osOrderId                               Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    # ${customerName}=                        Ler Variavel na Planilha                Customer_Name                           Global
    ${addressId}=                           Ler Variavel na Planilha                addressId                               Global
    ${inventoryId}=                         Ler Variavel na Planilha                inventoryId                             Global
    ${tipoOrdem}=                           Set Variable                            obra    
    # ${tpLogradouro}=                        Ler Variavel na Planilha                Type_Logradouro                         Global                                       
    # ${logradouro}=                          Ler Variavel na Planilha                Address_Name                            Global
    # ${numero}=                              Ler Variavel na Planilha                Number                                  Global
    # ${bairro}=                              Ler Variavel na Planilha                Bairro                                  Global
    # ${cidade}=                              Ler Variavel na Planilha                Cidade                                  Global
    # ${uf}=                                  Ler Variavel na Planilha                UF                                      Global
    # ${cep}=                                 Ler Variavel na Planilha                Address                                 Global
    # ${ref}=                                 Ler Variavel na Planilha                Reference                               Global

    Scroll To Element                       ${SOM_Ordem_numeroCOM}

    ${Ordem_numeroCOM}=                     Browser.Get Text                        ${SOM_Ordem_numeroCOM}
    ${Ordem_numeroPedido}=                  Browser.Get Text                        ${SOM_Ordem_numeroPedido}
    ${Ordem_tipo}=                          Browser.Get Text                        ${SOM_Ordem_tipo}
    # ${Cliente_nome}=                        Browser.Get Text                        ${SOM_Cliente_nome}

    Scroll To Element                       ${SOM_Endereco_id}
    
    ${Endereco_id}=                         Browser.Get Text                        ${SOM_Endereco_id}
    ${Endereco_inventory}=                  Browser.Get Text                        ${SOM_Endereco_inventory}
    # ${Abertura_Pedido}=                     Browser.Get Text                        ${SOM_Ordem_dtAberturaPedido}
    # ${Origem_Ordem}=                        Browser.Get Text                        ${SOM_Origem_Solicitacao}
    # ${Empresa_Name}=                        Browser.Get Text                        ${SOM_Cliente_empresa}
    # ${Endereco_tpLogradouro}                Browser.Get Text                        ${SOM_Endereco_tpLogradouro}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}
    # ${Endereco_bairro}                      Browser.Get Text                        ${SOM_Endereco_bairro}
    # ${Endereco_cidade}                      Browser.Get Text                        ${SOM_Endereco_cidade}
    # ${Endereco_uf}                          Browser.Get Text                        ${SOM_Endereco_uf}
    # ${Endereco_cep}                         Browser.Get Text                        ${SOM_Endereco_cep}
    # ${Endereco_ref}                         Browser.Get Text                        ${Som_Endereco_ref}

    #Comparação se as informações estão iguais da planilha
    Should Be Equal As Strings              ${Ordem_numeroCOM}                      ${OSOrderId}                            ignore_case=true
    Should Be Equal As Strings              ${Ordem_numeroPedido}                   ${associatedDocument}                   ignore_case=true                    
    Should Be Equal As Strings              ${Ordem_tipo}                           ${tipoOrdem}                            ignore_case=true
    # Should Be Equal As Strings              ${Cliente_nome}                         ${customerName}                         ignore_case=true
    Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=true
    Should Be Equal As Strings              ${Endereco_inventory}                   ${inventoryId}                          ignore_case=true
    # Should Be Equal As Strings              ${Origem_Ordem}                         ${NomeEmpresa}
    # Should Be Equal As Strings              ${Empresa_Name}                         ${NomeEmpresa}          
    # Should Be Equal As Strings              ${Endereco_tpLogradouro}                ${tpLogradouro}
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${logradouro}           
    # Should Be Equal As Strings              ${Endereco_numero}                      ${numero}
    # Should Be Equal As Strings              ${Endereco_bairro}                      ${bairro}
    # Should Be Equal As Strings              ${Endereco_cidade}                      ${cidade}
    # Should Be Equal As Strings              ${Endereco_uf}                          ${uf}
    # Should Be Equal As Strings              ${Endereco_cep}                         ${cep}

    Scroll To Element                       ${SOM_NomeDoProdutoAdd}

    ${NomeDoProdutoAdd}=                    Browser.Get Text                        ${SOM_NomeDoProdutoAdd} 
    ${TipoDeProdutoAdd}=                    Browser.Get Text                        ${SOM_TipoDeProdutoAdd} 
    ${AcaoAdd}=                             Browser.Get Text                        ${SOM_AcaoAdd}        
    
    Should Be Equal As Strings              ${NomeDoProdutoAdd}                     VELOC_${VELOCIDADE}MBPS
    Should Be Equal As Strings              ${TipoDeProdutoAdd}                     Banda Larga
    Should Be Equal As Strings              ${AcaoAdd}                              adicionar
   
   #Validação Histórico de Tramitação
    Scroll To Element                       ${SOM_Tarefa_Block}                                
    Take Screenshot Web Element is visible  ${SOM_Tarefa_Block}

    ${Tarefa_T073U01}=                      Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T073U01 - Projeto de Rede - Atendimento Solicitado"])
    ${Status_T073U01}=                      Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T073U01 - Projeto de Rede - Atendimento Solicitado"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"])
    
    ${Tarefa_T076}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T076 - Notificar Abertura de Obra"])
    ${Status_T076}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T076 - Notificar Abertura de Obra"]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"])
  
    Close Browser                           CURRENT
#===========================================================================================================================================================================================================
Validar Pendencia Obra Tratada
    [Documentation]                         Validação do Task Name "T072 - Executar Processo de Obra" no SOM e clica nos 3 pontinhos e valida informações.                                                              

    Login SOM
    Altera Filtro Consulta Order ID         Associated_Document

    ${Associated_Document}=                 Ler Variavel na Planilha                Associated_Document                     Global
    ${SOM_Quantia_linha}=                   Get Element Count is Visible            (//td[contains(text(),"${Associated_Document}")]/..)

    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Quantidade de linhas da tabela está diferente do esperado.
    END

    #Valida o Task Name, esperado é "T073U01 - Projeto de Rede - Atendimento Solicitado"
    ${taskname_SOM}=                         Get Text Element is Visible            xpath=//span[normalize-space()="Task Name"]/../../../../tr[2]/td[12]
    IF  "${taskname_SOM}" != "T073U01 - Projeto de Rede - Atendimento Solicitado"
        Fatal Error                         Task Name está diferente de "T073U01 - Projeto de Rede - Atendimento Solicitado"
    END

    #VALIDACAO LINHA T073
    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            //td[normalize-space()="T073U01 - Projeto de Rede - Atendimento Solicitado"]/.././/td[1]/input

    ${Tarefa_I002}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="I002 - Tratar Pendencia Cliente"])[1]
    ${Status_I002}=                         Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="I002 - Tratar Pendencia Cliente"])[1]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Encerrado"]
    ${Tipo_Encerramento_I002}=              Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="I002 - Tratar Pendencia Cliente"])[1]/../../../../../../../..//*[text()="Tipo de Encerramento"]/../../../../..//*[@value="Fechar Pendência"]
    
    Take Screenshot Web Element is visible  (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="I002 - Tratar Pendencia Cliente"])[1]/../../../../../../..
    Close Browser


    #FECHA BROWSER E VALIDA A SEGUNDA LINHA
    Login SOM
    Altera Filtro Consulta Order ID         Associated_Document

    IF  "${SOM_Quantia_linha}" != "2"
        Fatal Error                         Quantidade de linhas da tabela está diferente do esperado.
    END

    #Valida o Task Name, esperado é "T072 - Executar Processo de Obra"
    ${taskname_SOM}=                         Get Text Element is Visible            xpath=//span[normalize-space()="Task Name"]/../../../../tr[3]/td[12]
    IF  "${taskname_SOM}" != "T072 - Executar Processo de Obra"
        Fatal Error                         Task Name está diferente de "T072 - Executar Processo de Obra"
    END

    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            //td[normalize-space()="T072 - Executar Processo de Obra"]/.././/td[1]/input

    ${Tarefa_T0072}=                        Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"])[1]
    ${Status_T0072}=                        Browser.Get Text                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"])[1]/../../../../../../../..//*[text()="Status"]/../../../../..//*[@value="Em Tramitação"]
    
    Take Screenshot Web Element is visible  (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="T072 - Executar Processo de Obra"])[1]/../../../../../../..
    Close Browser

