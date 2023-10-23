*** Settings ***
Documentation                               Validação de pendência
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ../../RESOURCE/SOM/UTILS.robot
Resource                                    ../../RESOURCE/SOM/PAGE_OBJECTS.robot
          

*** Variables ***

${date}
${correlationOrder}
${associatedDocument}
${observation}
${action}
${userId}


*** Keywords ***
Validando Pendência
    [Tags]                                  ValidarPendência
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nValidação de Pendência

    Retornar Token Vtal
    Validação da Pendência

#===================================================================================================================================================================
Validação da Pendência
    [Tags]                                  ValidaPedencia
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nConsulta Order ID no SOM e Valida a Pendência

    Login SOM
    Altera Filtro Consulta Order ID         AssociatedDocument_OR_SomID=associatedDocument
    Validar Dados SOM com Pendencia

#===================================================================================================================================================================
Validar Dados SOM com Pendencia
    [Tags]                                  ValidarSOM
    [Documentation]                         Seleciona a task "T017 - Instalar Equipamento". Localiza os objetos no SOM e compara com os dados da planilha:
    ...                                     \n- Cliente_nome
    ...                                     \n- Cliente_tel1
    ...                                     \n- Ordem_numeroCOM
    ...                                     \n- Ordem_numeroPedido
    ...                                     \n- address
    ...                                     \n- number
    ...                                     \n- addressId
    ...                                     \n- typeLogradouro
    ...                                     \nValida pendência: Notificar Pendência, I002 - Tratar Pendencia Cliente, Encerrado , Fechar Pendência.
    
    #Seleciona o item da lista que contém o T017
    ${row_count}=                           Browser.Get element count               xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
    ${row}                                  Set Variable                            0

    FOR                                     ${row}                                  IN RANGE                                ${row_count}
        ${taskName}=                        Get Table Cell Element                  //*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Task Name"     ${row}
        ${value}=                           Browser.Get Text                        ${taskName}

        IF  "${value}" == "T017 - Instalar Equipamento"
            Click                           xpath=(//input[@value='...'])[${row}]
            Exit For Loop
        END
    END



    #Carrega valores da dat
    # ${dat_Customer_Name}                    Ler Variavel na Planilha                Customer_Name                           Global
    # ${dat_Phone_Number}                     Ler Variavel na Planilha                Phone_Number                            Global
    # ${date}=                                Ler Variavel na Planilha                Associated_Document_Date                Global
    ${OSOrderId}=                           Ler Variavel na Planilha                osOrderId                               Global
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global       
    # ${SOM_Id}=                              Ler Variavel na Planilha                SOM_Order_Id                            Global
    # ${address}=                             Ler Variavel na Planilha                Address_Name                            Global
    # ${number}=                              Ler Variavel na Planilha                Number                                  Global
    # ${addressId}=                           Ler Variavel na Planilha                Address_Id                              Global
    # ${inventoryId}=                         Ler Variavel na Planilha                Inventory_Id                            Global
    # ${typeLogradouro}=                      Ler Variavel na Planilha                Type_Logradouro                         Global 

    Wait For Elements State                 ${SOM_atividade}                        visible                                 55
    
    #Set Browser Timeout    1m 30 seconds

    #Carrega valores SOM
    # ${Cliente_nome}                         Browser.Get Text                        ${SOM_Cliente_nome}                     message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Dados do Cliente > Nome]
    # ${Cliente_tel1}                         Browser.Get Text                        ${SOM_Cliente_tel1}                     message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Dados do Cliente > Telefone de Contato 1]
    ${Ordem_numeroCOM}                      Browser.Get Text                        ${SOM_Ordem_numeroCOM}                  message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Número da Ordem do COM]
    ${Ordem_numeroPedido}                   Browser.Get Text                        ${SOM_Ordem_numeroPedido}               message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Número do Pedido]
    # ${Ordem_dtAberturaPedido}               Browser.Get Text                        ${SOM_Ordem_dtAberturaPedido}
    # ${Endereco_logradouro}                  Browser.Get Text                        ${SOM_Endereco_logradouro}              message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Dados dos Endereços > Endereço List > Endereço > Nome do Logradouro]
    # ${Endereco_numero}                      Browser.Get Text                        ${SOM_Endereco_numero}                  message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Dados dos Endereços > Endereço List > Endereço > Número da Porta]
    # ${Endereco_id}                          Browser.Get Text                        ${SOM_Endereco_id}                      message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Dados dos Endereços > Endereço List > Endereço > Id do Endereço]
    ${notificarPendencia}                   Browser.Get Text                        xpath=//a[text()="Tarefas"]/../../../..//*[@value='Notificar Pendência']
    ${tratarPendencia}                      Browser.Get Text                        xpath=//a[text()="Tarefas"]/../../../..//*[@value="I002 - Tratar Pendencia Cliente"]
    ${tratarEncerrado}                      Browser.Get Text                        xpath=//a[text()="Tarefas"]/../../../..//*[@value="I002 - Tratar Pendencia Cliente"]/../../../../../../..//*[@value="Encerrado"]
    ${tratarTipo}                           Browser.Get Text                        xpath=//a[text()="Tarefas"]/../../../..//*[@value="Fechar Pendência"]
    # ${typeAddress}                          Browser.Get Text                        xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Tipo de Logradouro']/../../../../..//input
                
        

    #Validações
    # Should Be Equal As Strings              ${dat_Customer_Name}                    ${Cliente_nome}                         Dados do Cliente: Nome não apresenta valor esperado
    # Should Be Equal As Strings              ${dat_Phone_Number}                     ${Cliente_tel1}                         Dados do Cliente: Telefone1 não apresenta valor esperado
    Should Be Equal As Strings              ${OSOrderId}                            ${Ordem_numeroCOM}                      ignore_case=True
    Should Be Equal As Strings              ${associatedDocument}                   ${Ordem_numeroPedido}                   ignore_case=True
    # Should Be Equal As Strings              ${Endereco_logradouro}                  ${address}                              ignore_case=True
    # Should Be Equal As Strings              ${Endereco_numero}                      ${number}                               ignore_case=True
    # Should Be Equal As Strings              ${Endereco_id}                          ${addressId}                            ignore_case=True
    # Should Be Equal As Strings              ${typeAddress}                          ${typeLogradouro}                       ignore_case=True
    Should Be Equal As Strings              ${notificarPendencia}                   Notificar Pendência                     ignore_case=True
    Should Be Equal As Strings              ${tratarPendencia}                      I002 - Tratar Pendencia Cliente         ignore_case=True
    Should Be Equal As Strings              ${tratarEncerrado}                      Encerrado                               ignore_case=True
    Should Be Equal As Strings              ${tratarTipo}                           Fechar Pendência                        ignore_case=True
    
    
    #Obs: As datas não estão sendo validadas.

    Sleep                                   10

    Close Browser                           CURRENT

#===================================================================================================================================================================
Validacao SOM sem Pendencia
    [Documentation]                         Faz login no SOM, Consulta Order ID e Valida sem Pendência.
    ...                                     \nAtualiza SOM até que a row_count seja igual a 4. Seleciona a task "T017 - Instalar Equipamento". Localiza os objetos no SOM e compara com os dados da planilha:
    ...                                     \n- Cliente_nome
    ...                                     \n- Cliente_tel1
    ...                                     \n- Ordem_numeroCOM
    ...                                     \n- Ordem_numeroPedido
    ...                                     \n- addressId

    Login SOM
    Altera Filtro Consulta Order ID
    
    FOR                                     ${1}                                    IN RANGE                                ${10}
        ${row_count}=                       Browser.Get element count               xpath=//*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table/tbody/tr
        ${row}                              Set Variable                            1
    
        IF  ${row_count} != 4
            Click                           ${SOM_btn_refresh}
            Sleep                           10
        ELSE    
            Exit For Loop
        END 
    END


    FOR                                     ${row}                                  IN RANGE                                ${row_count}
    
        ${taskName}=                        Get Table Cell Element                  //*[@id="aazone.worklist"]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/table/tbody/tr/td/table        "Task Name"     ${row}
        ${value}=                           Browser.Get Text                        ${taskName}

        IF  "${value}" == "T017 - Instalar Equipamento"
            log to console                  "task name validado"
            Click                           xpath=(//input[@value='...'])[${row}]
            Exit For Loop
        END
    END

    Sleep    2
    
    # ${dat_Customer_Name}                    Ler Variavel na Planilha                customerName                            Global
    # ${dat_Phone_Number}                     Ler Variavel na Planilha                phoneNumber                             Global
    ${correlationOrder}=                    Ler Variavel na Planilha                osOrderId                               Global    
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global       
    ${SOM_Id}=                              Ler Variavel na Planilha                somOrderId                              Global
    # ${addressId}=                           Ler Variavel na Planilha                addressId                               Global

    
    Wait For Elements State                 ${SOM_atividade}                        visible                                 55

    # ${Cliente_nome}                         Browser.Get Text                        ${SOM_Cliente_nome}                     message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Dados do Cliente > Nome]                                        
    # ${Cliente_tel1}                         Browser.Get Text                        ${SOM_Cliente_tel1}                     message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Dados do Cliente > Telefone de Contato 1]
    ${Ordem_numeroCOM}                      Browser.Get Text                        ${SOM_Ordem_numeroCOM}                  message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Número da Ordem do COM]
    ${Ordem_numeroPedido}                   Browser.Get Text                        ${SOM_Ordem_numeroPedido}               message=Erro ao localizar o objeto. Posição: [Dados da Ordem > Número do Pedido] 
    # ${Endereco_id}                          Browser.Get Text                        ${SOM_Endereco_id}                      message=Erro ao localizar o objeto. Posição: [Dados dos Endereços > Endereço List > Endereço > Id do Endereço]
    

    # Should Be Equal As Strings              ${dat_Customer_Name}                    ${Cliente_nome}                         Dados do Cliente: Nome não apresenta valor esperado
    # Should Be Equal As Strings              ${dat_Phone_Number}                     ${Cliente_tel1}                         Dados do Cliente: Telefone1 não apresenta valor esperado
    Should Be Equal As Strings              ${correlationOrder}                     ${Ordem_numeroCOM}
    Should Be Equal As Strings              ${associatedDocument}                   ${Ordem_numeroPedido}
    # Should Be Equal As Strings              ${Endereco_id}                          ${addressId}

    Close Browser                           CURRENT

#===================================================================================================================================================================