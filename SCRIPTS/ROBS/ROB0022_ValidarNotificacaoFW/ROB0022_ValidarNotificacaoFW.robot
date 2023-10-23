*** Settings ***
Documentation                               Validação a Notificacao de criação da ordem no FW
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ../../RESOURCE/FW/UTILS.robot
  

*** Variables ***
#${DAT_CENARIO}                             C:/IBM_VTAL/DATA/DAT012_RealizarAtivacaoSemPendencia.xlsx

${correlationOrder}
${associatedDocument}


#*** Test Cases ***
#Validando a notificacao da ordem
    #Valida Notificacao FW


*** Keywords ***
Preenche o Work_Order_Id
    [Documentation]                         Lê o campo Work_Order_Id na planilha e salva como variável global
    [Tags]                                  ValidarAgendamentoBAFW
    ${WORKORDERID}=                         Ler Variavel na Planilha                workOrderId                 	        Global
    Set Global Variable                     ${WORKORDERID}

#===================================================================================================================================================================
Verificar mudanca de Velocidade
    [Documentation]                         Verifica o registro de mudança de velocidade
    ...                                     \nAcessa o FW Console (sem a necessidade de fazer login)
    ...                                     \nLê o campo "Associated_Document" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ProductOrdering.PostProductOrder" e valida os retornos dos campos "START" e "END", por exemplo:
    ...                                     \n - START: <type>Modificacao de Velocidade</type>
    ...                                     \n - END: <tns:code>201</tns:code>
    ...                                     \nSeleciona o evento "ProductOrdering.ListenerProductOrderStateChangeEvent" e valida os retornos do campo "INVOKE", por exemplo:
    ...                                     \n - INVOKE: <tns:description>Ordem Encerrada com Sucesso</tns:description>
    [Tags]                                  VerificaMudancaVelocidade

    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F

    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global

    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.PostProductOrder.v2.5
    ${target_event}=                        Run Keyword And Return Status           Click Web Element Is Visible            ${post_product_orderV25}

    IF    "${target_event}" == "True"
        Click Web Element Is Visible            //a[text()="ProductOrdering.PostProductOrder.v2.5"]
        Close Page                              CURRENT                                 CURRENT                                 CURRENT
        Sleep    3                              #Tempo de loading dos elementos

    ELSE
        Close Browser                           CURRENT
        Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.PostProductOrder.v2
        Click Web Element Is Visible            //a[text()="ProductOrdering.PostProductOrder.v2"]
        Close Page                              CURRENT                                 CURRENT                                 CURRENT
        Sleep    3
    END
    
    Wait for Elements State                 //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]                     Visible                                 15
    Click Web Element Is visible            //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]   
    Highlight Elements                      //*[text()="START - Inicialização do serviço"]/../..//textarea                  duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    ${xmlStart}=                            Get Text Element Is Visible             //*[text()="START - Inicialização do serviço"]/../..//textarea                                         
    
    Click Web Element Is visible            //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]   
    Highlight Elements                      //*[text()="END - Finalização do serviço"]/../..//textarea                  duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    ${xmlEnd}=                              Get Text Element Is Visible             //*[text()="END - Finalização do serviço"]/../..//textarea

    # ${correlationOrder}=                    Ler Variavel na Planilha                CorrelationOrder                        Global
    ${infraType}=                           Ler Variavel na Planilha                infraType                               Global
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global
    ${SOM_Order_Id}=                        Ler Variavel na Planilha                somOrderId                              Global

    # Should Contain                          ${xmlStart}                             <correlationOrder>${correlationOrder}</correlationOrder>
    Should Contain                          ${xmlStart}                             <associatedDocument>${associatedDocument}</associatedDocument>
    Should Contain                          ${xmlStart}                             <type>Modificacao de Velocidade</type>
    Should Contain                          ${xmlStart}                             <infraType>${infraType}</infraType>
    Should Contain                          ${xmlStart}                             <subscriberId>${subscriberId}</subscriberId>
    
    Should Contain                          ${xmlEnd}                               <tns:type>S</tns:type>
    Should Contain                          ${xmlEnd}                               <tns:code>200</tns:code>
    Should Contain                          ${xmlEnd}                               <tns:message>Sucesso</tns:message>                        

    Close Browser                           CURRENT

    ########################################

    #ListenerProductOrderStateChangeEvent Validation
        
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.ListenerProductOrderStateChangeEvent
    
    Click Web Element Is Visible            //a[text()="ProductOrdering.ListenerProductOrderStateChangeEvent"]
    Close Page                              CURRENT                                 CURRENT
    
    Wait for Elements State                 //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea/../../..//*[@data-action="collapse"]                     Visible                                 15
    Click Web Element Is visible            //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea/../../..//*[@data-action="collapse"]   
    Highlight Elements                      //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea                  duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    ${xmlInvoke}=                           Get Text Element Is Visible             //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea            

    Should Contain                          ${xmlInvoke}                            <tns:subscriberId>${subscriberId}</tns:subscriberId>
    # Should Contain                          ${xmlInvoke}                            <tns:correlationOrder>${correlationOrder}</tns:correlationOrder>
    Should Contain                          ${xmlInvoke}                            <tns:associatedDocument>${associatedDocument}</tns:associatedDocument>
    Should Contain                          ${xmlInvoke}                            <tns:type>Encerramento</tns:type>
    Should Contain                          ${xmlInvoke}                            <tns:code>0</tns:code>
    Should Contain                          ${xmlInvoke}                            <tns:description>Ordem Encerrada com Sucesso</tns:description>

    Close Browser                           CURRENT

#===================================================================================================================================================================
Validacao do FTTP no FW
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Associated_Document" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ProductOrdering.PostProductOrder" e valida os retornos dos campos "START" e "END", por exemplo:
    ...                                     \n - START: <infraType>FTTP</infraType>
    ...                                     \n - END: <tns:code>201</tns:code>
    [Tags]                                  ValidacaoProductOrder
   
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    Set Global Variable                     ${Associated_Document}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+08%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.PostProductOrder.v2.5
    
    Validar Criacao da Ordem FTTP           
    Close Browser                           CURRENT

#===================================================================================================================================================================
Valida StateChangeEvent FTTP
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Associated_Document" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ProductOrdering.ListenerProductOrderStateChangeEvent"
    ...                                     \nSeleciona o campo "INVOKE" e valida o retorno <tns:description>Ordem Encerrada com Sucesso</tns:description>
    
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global 
    Set Global Variable                     ${Associated_Document}
    Valida Recebimento de Atividade FTTP
    Close Browser                           CURRENT

#===================================================================================================================================================================
Valida Notificacao Pre Diagnostico no FW
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "PreDiag_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceTestManagement.ListenerServiceTestResultEvent" e valida os retornos dos campos (Todos passados como argumento)
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``EVENTO_FW`` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | ``BLOCK_XML`` | Elementos do XML que devem ser validados. Ex: ssid, wifiIndex, code, frequencyBand, state, etc. |
    ...                                     | ``DADOS_XML`` | Valor que deverá ser validado. |
    [Tags]                                  ValidaPreDiagnostico
    [Arguments]                             ${EVENTO_FW}                            ${BLOCK_XML}                            ${DADOS_XML}        

  
    
    ${preDiagID}=                           Ler Variavel na Planilha                preDiagId                               Global
    Set Global Variable                     ${preDiagID}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${preDiagID}
    
    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Validar Dados XML no FW         ${BLOCK_XML}                            ${DADOS_XML}
         
            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
    END

#===================================================================================================================================================================
Valida Notificacao Diagnostico no FW 
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Diag_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceTestManagement.ListenerServiceTestResultEvent" e valida os retornos dos campos (Todos passados como argumento)
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``EVENTO_FW`` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | ``BLOCK_XML`` | Elementos do XML que devem ser validados. Ex: ssid, wifiIndex, code, frequencyBand, state, etc. |
    ...                                     | ``DADOS_XML`` | Valor que deverá ser validado. |
    [Tags]                                  ValidaDiagnostico
    [Arguments]                             ${EVENTO_FW}                            ${BLOCK_XML}                            ${DADOS_XML}        

  
    ${diagID}=                              Ler Variavel na Planilha                diagId                                  Global
    Set Global Variable                     ${diagID}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${diagID}
    
    FOR    ${z}    IN RANGE    10
    
       ${numLinhas}=                        Get Element Count is Visible            xpath=//table//td//a[text()="ServiceTestManagement.ListenerServiceTestResultEvent"]
       
        IF    ${numLinhas} != 1
        
            Reload
            IF    ${z} == 9
                Fatal Error                     \n -> Existe apenas um evento, o esperado são dois eventos.
            END
            
        ELSE
            BREAK
        END

    END

    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Validar Dados XML no FW         ${BLOCK_XML}                            ${DADOS_XML}
         
            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
    END


#===================================================================================================================================================================
Realizar Validação da desabilitação de SSID no FW
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Desabilitacao_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento e valida o retorno dos campos
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``EVENTO_FW`` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | ``RETORNO_ESPERADO`` | Valor que deverá ser validado. |
    [Tags]                                  ValidaDesabilitaçãoFWConsole
    [Arguments]                             ${EVENTO_FW}                            ${RETORNO_ESPERADO}        

  
    
    ${Desabilitacao_Id}=                    Ler Variavel na Planilha                desabilitacaoId                         Global
    Set Global Variable                     ${Desabilitacao_Id}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${Desabilitacao_Id}
    
        FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()='${EVENTO_FW}'][1]    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()='${EVENTO_FW}'][1]
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT
            ${STATUS}=                              Browser.Get Text                ${xml_retorno}                          *=                                   ${RETORNO_ESPERADO}     
            
            Click Web Element Is Visible    //*[@id="itens"]/div[4]/div[2]/div[1]/span[2]/a                
            ${INVOKE_XML}=                  Get Text Element is Visible             //*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea
            
            Should Contain                  ${INVOKE_XML}                           <type>HGW_WIFI_CONFIGURATION</type>    
            Should Contain                  ${INVOKE_XML}                           <id>${Desabilitacao_Id}</id>
            Should Contain                  ${INVOKE_XML}                           <state>FINISHED</state>

            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
    END
#===================================================================================================================================================================
Realizar Validação da habilitação de SSID no FW
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Habilitacao_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento e valida o retorno dos campos
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``EVENTO_FW`` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | ``RETORNO_ESPERADO`` | Valor que deverá ser validado. |
    [Tags]                                  ValidaDesabilitaçãoFWConsole
    [Arguments]                             ${EVENTO_FW}                            ${RETORNO_ESPERADO}        

  
    
    ${Habilitacao_Id}=                      Ler Variavel na Planilha                habilitacaoId                           Global
    Set Global Variable                     ${Habilitacao_Id}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${Habilitacao_Id}
    
        FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()='${EVENTO_FW}'][1]    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()='${EVENTO_FW}'][1]
            Sleep                           2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT
            ${STATUS}=                      Browser.Get Text                        ${xml_retorno}                          *=                                      ${RETORNO_ESPERADO}     
            Close Browser                   CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
    END
#===================================================================================================================================================================



Valida Notificacao Diagnostico no FW_1
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Diag_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceTestManagement.ListenerServiceTestResultEvent" e valida os retornos dos campos (Todos passados como argumento)
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``EVENTO_FW`` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | ``BLOCK_XML`` | Elementos do XML que devem ser validados. Ex: ssid, wifiIndex, code, frequencyBand, state, etc. |
    ...                                     | ``DADOS_XML`` | Valor que deverá ser validado. |
    [Tags]                                  ValidaDiagnostico
    [Arguments]                             ${EVENTO_FW}                            ${BLOCK_XML}                            ${DADOS_XML}        

  
    ${diagID}=                              Ler Variavel na Planilha                diagId                                  Global
    Set Global Variable                     ${diagID}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${diagID}
    
    # Pode aparecer um ou dois eventos, então estou retirando
    # FOR    ${z}    IN RANGE    10
    
    #    ${numLinhas}=                        Get Element Count is Visible            xpath=//table//td//a[text()="ServiceTestManagement.ListenerServiceTestResultEvent"]
           
    #     IF    ${numLinhas} != 2
        
    #         Reload
    #         IF    ${z} == 9
    #             Fatal Error                     \n -> Existe apenas um evento, o esperado são dois eventos.
    #         END
            
    #     ELSE
    #         BREAK
    #     END

    # END

    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Validar Dados XML no FW         ${BLOCK_XML}                            ${DADOS_XML}
         
            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
    END
#===================================================================================================================================================================
Valida Notificacao Diagnostico no FW_2
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Diag_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceTestManagement.ListenerServiceTestResultEvent" e valida os retornos dos campos (Todos passados como argumento)
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``EVENTO_FW`` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | ``BLOCK_XML`` | Elementos do XML que devem ser validados. Ex: ssid, wifiIndex, code, frequencyBand, state, etc. |
    ...                                     | ``DADOS_XML`` | Valor que deverá ser validado. |
    [Tags]                                  ValidaDiagnostico
    [Arguments]                             ${EVENTO_FW}                            ${BLOCK_XML}                            ${DADOS_XML}        

    
    ${diagID}=                              Ler Variavel na Planilha                diagId                                  Global
    Set Global Variable                     ${diagID}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${diagID}
    
    # FOR    ${z}    IN RANGE    40
    
    #    ${numLinhas}=                        Get Element Count is Visible            xpath=//table//td//a[text()="ServiceTestManagement.ListenerServiceTestResultEvent"]
       
    #     IF    ${numLinhas} != 2
    #         Sleep                           6s
    #         Reload
    #         IF    ${z} == 41
    #             Fatal Error                     \n -> Existe apenas um evento, o esperado são dois eventos.
    #         END
            
    #     ELSE
    #         BREAK
    #     END

    # END

    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Validar Dados XML no FW         ${BLOCK_XML}                            ${DADOS_XML}
         
            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
    END




#===================================================================================================================================================================
Valida Notificacao Encerramento Diagnostico no FW
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login) passando a data na URL
    ...                                     \nLê o campo "troubleTicket_id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento e valida os retornos dos campos (Todos passados como argumento)
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``EVENTO_FW`` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | ``BLOCK_XML`` | Elementos do XML que devem ser validados. Ex: ssid, wifiIndex, code, frequencyBand, state, etc. |
    ...                                     | ``DADOS_XML`` | Valor que deverá ser validado. |
    [Tags]                                  ValidaDiagnostico
    [Arguments]                             ${EVENTO_FW}                            ${BLOCK_XML}                            ${DADOS_XML}        

  
    
    ${troubleTicket_id}=                    Ler Variavel na Planilha                troubleTicketId                         Global
    Set Global Variable                     ${troubleTicket_id}

    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    Contexto para navegador                   ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+08%3A00&date2=${Data_FW}+23%3A59&queryText=${troubleTicket_id}

    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="${EVENTO_FW}"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Validar Dados XML Encerramento reparo no FW                             ${BLOCK_XML}                            ${DADOS_XML}
         
            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
    END

#===================================================================================================================================================================
Valida Troca de Senha WiFi
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Configuration_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "erviceActivationConfiguration.ListenerConfigurationResultEvent" e valida os retornos dos campos
    ...                                     \nSeleciona o campo "INVOKE" e valida o retorno dos campos:
    ...                                     \n- <id>(Configuration_Id)</id>
    ...                                     \n- <type>HGW_WIFI_SET_PASSWD</type>
    ...                                     \n- <state>FINISHED</state>

    
    ${configId}=                            Ler Variavel na Planilha                configurationId                         Global
    Set Global Variable                     ${configId}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${configId}
    
    FOR    ${x}      IN RANGE     10
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Click Web Element Is Visible                                            xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//i[@class="ace-icon fa fa-chevron-down"]
            ${xml_invoke}=                  Browser.Get Text                        xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea

            Should Contain                  ${xml_invoke}                           <id>${configId}</id>                    Id não encontrado.
            Should Contain                  ${xml_invoke}                           <type>HGW_WIFI_SET_PASSWD</type>        Type diferente do esperado.
            Should Contain                  ${xml_invoke}                           <state>FINISHED</state>                 O state não está como FINISHED.


            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 9
                Fatal Error                 \nEvento ServiceActivationConfiguration.ListenerConfigurationResultEvent não foi encontrado no FW
            END
        END
    END
#===================================================================================================================================================================
Valida troca de SSID no FW
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Configuration_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceActivationConfiguration.ListenerConfigurationResultEvent" e valida os retornos dos campos
    ...                                     \nSeleciona o campo "INVOKE" e valida o retorno dos campos:
    ...                                     \n- <id>(Configuration_Id)</id>
    ...                                     \n- <type>HGW_WIFI_CONFIGURATION</type>
    ...                                     \n- <state>FINISHED</state>

    
    ${configId}=                            Ler Variavel na Planilha                configurationId                         Global
    Set Global Variable                     ${configId}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${configId}
    
    FOR    ${x}      IN RANGE     10
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Click Web Element Is Visible                                            xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//i[@class="ace-icon fa fa-chevron-down"]
            ${xml_invoke}=                  Browser.Get Text                        xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea

            Should Contain                  ${xml_invoke}                           <id>${configId}</id>                    Id não encontrado.
            Should Contain                  ${xml_invoke}                           <type>HGW_WIFI_CONFIGURATION</type>     Type diferente do esperado.
            Should Contain                  ${xml_invoke}                           <state>FINISHED</state>


            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ServiceActivationConfiguration.ListenerConfigurationResultEvent não foi encontrado no FW
            END
        END
    END
#===================================================================================================================================================================
Valida Configuracao Remota
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Configuration_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceActivationConfiguration.ListenerConfigurationResultEvent" e valida os retornos dos campos
    ...                                     \nSeleciona o campo "INVOKE" e valida o retorno dos campos:
    ...                                     \n- <id>(Configuration_Id)</id>
    ...                                     \n- <type>$(CONFIG_TYPE)</type>
    ...                                     \n- <state>FINISHED</state>
    ...                                     \n- <code>OK</code>
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``CONFIG_TYPE`` | Tipo do parâmetro que será validado |
	[Arguments]                             ${CONFIG_TYPE}

    
    ${configId}=                            Ler Variavel na Planilha                configurationId                         Global
    Set Global Variable                     ${configId}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${configId}
    
    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Click Web Element Is Visible                                            xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//i[@class="ace-icon fa fa-chevron-down"]
            ${xml_invoke}=                  Browser.Get Text                        xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea

            Should Contain                  ${xml_invoke}                           <id>${configId}</id>                    Id não encontrado.
            Should Contain                  ${xml_invoke}                           <type>${CONFIG_TYPE}</type>             Type diferente do esperado.
            Should Contain                  ${xml_invoke}                           <state>FINISHED</state>
            Should Contain                  ${xml_invoke}                           <code>OK</code>


            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ServiceActivationConfiguration.ListenerConfigurationResultEvent não foi encontrado no FW
            END
        END
    END
 
#===================================================================================================================================================================
Valida Solicitação de Reboot ONT/CPE no FW
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Reboot_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceActivationConfiguration.ListenerConfigurationResultEvent" e valida os retornos dos campos
    ...                                     \nSeleciona o campo "INVOKE" e valida o retorno dos campos:
    ...                                     \n- <id>(Configuration_Id)</id>
    ...                                     \n- <type>$(CONFIG_TYPE)</type>
    ...                                     \n- <state>FINISHED</state>
    ...                                     \n- <code>OK</code>
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``CONFIG_TYPE`` | Tipo do parâmetro que deverá ser validado |
    ...                                     | ``STATE`` | Estado da requisição validada |
    ...                                     | ``CODE`` | Valor do código que deverá ser validado. |
	[Arguments]                             ${CONFIG_TYPE}                          ${STATE}                                ${CODE}=NULL


    ${Reboot_Id}=                           Ler Variavel na Planilha                rebootId                                Global
    Set Global Variable                     ${Reboot_Id}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${Reboot_Id}
    
    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT

            Click Web Element Is Visible                                            xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//i[@class="ace-icon fa fa-chevron-down"]
            ${xml_invoke}=                   Browser.Get Text                       xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea

            Should Contain                  ${xml_invoke}                           <id>${Reboot_Id}</id>                   Id não encontrado.
            Should Contain                  ${xml_invoke}                           <type>${CONFIG_TYPE}</type>             Type diferente do esperado.
            Should Contain                  ${xml_invoke}                           <state>${STATE}</state>
            IF    "${CODE}"!="NULL"
                Should Contain              ${xml_invoke}                           <code>${CODE}</code>
            END

            Close Browser                   CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ServiceActivationConfiguration.ListenerConfigurationResultEvent não foi encontrado no FW
            END
        END
    END
 
#===================================================================================================================================================================
Valida Configuracao Remota Rejeitada
    [Documentation]                         Acessa o FW Console (sem necessidade de fazer login)
    ...                                     \nLê o campo "Configuration_Id" na planilha e preenche o valor como parâmetro na busca
    ...                                     \nSeleciona o evento "ServiceActivationConfiguration.ListenerConfigurationResultEvent" e valida os retornos dos campos
    ...                                     \nSeleciona o campo "INVOKE" e valida o retorno dos campos:
    ...                                     \n- <id>(Configuration_Id)</id>
    ...                                     \n- <type>$(CONFIG_TYPE)</type>
    ...                                     \n- <state>REJECTED</state>
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``CONFIG_TYPE`` | Tipo do parâmetro que será validado |
	[Arguments]                             ${CONFIG_TYPE}


    ${configId}=                            Ler Variavel na Planilha                configurationId                         Global
    Set Global Variable                     ${configId}
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${configId}
    
    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()="ServiceActivationConfiguration.ListenerConfigurationResultEvent"]/../../..//tr[1]//a
            Sleep                                   2s
            Close Page                              CURRENT                         CURRENT                                 CURRENT

            Click Web Element Is Visible                                            xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//i[@class="ace-icon fa fa-chevron-down"]
            ${xml_invoke}=                   Browser.Get Text                       xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea

            Should Contain                  ${xml_invoke}                           <id>${configId}</id>                    Id não encontrado.
            Should Contain                  ${xml_invoke}                           <type>${CONFIG_TYPE}</type>     Type diferente do esperado.
            Should Contain                  ${xml_invoke}                           <state>REJECTED</state>


            Close Browser                           CURRENT
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ServiceActivationConfiguration.ListenerConfigurationResultEvent não foi encontrado no FW
            END
        END
    END
#===================================================================================================================================================================
Buscar OS Start XML
    [Arguments]                             ${VALOR_BUSCA}                          ${XPATH_EVENTO}
    
    ${TEXTO_BUSCA}=                         Ler Variavel na Planilha                ${VALOR_BUSCA}                          Global                            
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    #ABRIR NAVEGADOR
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${TEXTO_BUSCA}
    
    Click Web Element Is visible            ${XPATH_EVENTO}
    Sleep                                   2s
    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    
    ${XMLTEXT}=                             Browser.Get Text                        //h5[text()="START - Inicialização do serviço"]/../..//textarea
    ${OSID}=                                Split String                            ${XMLTEXT}                              <tns:id>
    ${OSID}=                                Split String                            ${OSID[1]}                              </tns:id>

    Escrever Variavel na Planilha           ${OSID[0]}                              somOrderId                              Global

    Close Browser                           CURRENT      


#===================================================================================================================================================================
