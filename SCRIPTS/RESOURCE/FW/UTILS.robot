*** Settings ***

Library                                     Browser
Library                                     Collections
Library                                     ExcelLibrary
Library                                     XML                                     use_lxml=True
# Library                                     Dialogs
Library                                     String
Library                                     AppiumLibrary

Resource                                    VARIABLES.robot
Resource                                    PAGE_OBJETCS.robot
Resource                                    ../COMMON/RES_EXCEL.robot
Resource                                    ../COMMON/RES_UTIL.robot



*** Keywords ***

Login FWConsole
    [Documentation]                         Acessar URL do FW e fazer login com usuário e senha presentes na planilha.
    ...                                     \nNavegador abre nas medidas 1890x900

    ${USER_FW}=                             Ler Variavel Param Global               Usuario_FW                              Global
    ${PASSWORD_FW}=                         Ler Variavel Param Global               Senha_FW                                Global

    Contexto para navegador                ${URL_FW}

    Input Text Web Element Is Visible       xpath=${input_userFW}                   ${USER_FW}
    Input Text Web Element Is Visible       xpath=${input_passFW}                   ${PASSWORD_FW}
    Click Web Element Is Visible            xpath=${login_button}




Validar Evento FW
    [Arguments]                             ${VALOR_BUSCA}                          
    ...                                     ${XPATH_EVENTO}
    ...                                     ${RETORNO_ESPERADO}=None
    ...                                     ${XPATH_XML}=//*[text()="END - Finalização do serviço"]/../..//textarea
    ...                                     ${DADOS_XML}=None
    ...                                     ${TENTATIVAS_FOR}=20

    [Documentation]                         Valida Evento no FW
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VALOR_BUSCA` | Valor que será buscado. Ex: PreDiag_ID, Diag_ID, Configuration_Id, Associated_Document, etc. Argumento obrigatório. |
    ...                                     | `XPATH_EVENTO` | Evento que deve ser validado. Modelo: (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]. Argumento obrigatório. |
    ...                                     | `RETORNO_ESPERADO` | Retorno que deve ser validado, validação simples. Ex: >201<, >200<, >404<, Operação realizada com sucesso, etc. Se não for passado argumento, por padrão, será usado " None " |
    ...                                     | `XPATH_XML` | Passo do Framework que deve ser acessado para validação. Modelo: //*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]. Se não for passado argumento, será usado o caminho, por padrão " END - Finalização do serviço " |
    ...                                     | `DADOS_XML` | Dados XML que devem ser validados, pode validar vários elementos. Se não for passado argumento, por padrão, será usado " None " |
    ...                                     | `TENTATIVAS_FOR` | Quantas tentativas devem ser realizadas. Se não for passado argumento, por padrão, será usado " 10 " |
    ...                                     \nAcessa o FW, filtrando pela data atual e pelo VALOR_BUSCA. Recarrega a página até que dois eventos sejam exibidos, caso atinja o número de tentativas de carregamento e não apareça, é exibido o erro "Existe apenas um evento, o esperado são dois eventos".
    ...                                     \nClica no evento que deve ser validado, seleciona e expande o XPATH_XML específico, e tiram um screenshot.
    ...                                     \nCaso seja passado apenas o RETORNO_ESPERADO é feita uma validação simples, se o retorno esperado não estiver presente, ocorre Fatal Error informando que o valor no FW está diferente.
    ...                                     \nCaso seja passado apenas o DADOS_XML, é feita a validação de cada elemento.
    ...                                     \nCaso os dois ou nenhum argumento sejam passados, apresenta o erro "Argumentos passados de maneira incorreta".
    ...                                     \nSe alguma validação não for bem sucedida, ocorre Fatal Error de Evento não encontrado no FW.

    #MODELO XPATH XML:                      (//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    #MODELO XPATH EVENTO:                   (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]

    #PREENCHER VARIAVEIS
    ${TEXTO_BUSCA}=                         Ler Variavel na Planilha                ${VALOR_BUSCA}                          Global                            
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y                  increment=- 3 hours
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    ${bitState}=                            Ler Variavel Param Global               Credencial                              Global

    #ABRIR NAVEGADOR
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${TEXTO_BUSCA}
    

    # IF    "${VALOR_BUSCA}" == "Diag_ID"
    #     ${XPATH_EVENTO_DIAG}=               Remove String Using Regexp              ${XPATH_EVENTO}                         .{3}$
    #     FOR    ${X}     IN RANGE    ${TENTATIVAS_FOR}
    #         ${QTD_LINHAS}=                  Get Element Count is Visible            xpath=${XPATH_EVENTO_DIAG}
    #         IF    ${QTD_LINHAS} != 2
    #             Reload
    #             Sleep                       5s
    #         ELSE
    #             BREAK
    #         END

    #         IF    ${X} == ${TENTATIVAS_FOR}-1
    #             Fatal Error                     \n -> Existe apenas um evento, o esperado são dois eventos.
    #         END
    #     END
    # END


    
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${present}=  Run Keyword And Return Status    Wait for Elements State    ${XPATH_EVENTO}    Visible    10
        IF    ${present} == True
            Click Web Element Is visible    ${XPATH_EVENTO}
            Sleep                           2s
            Close Page                      CURRENT                         CURRENT                                 CURRENT
            Click Web Element Is visible    ${XPATH_XML}/../../..//*[@data-action="collapse"]
            Wait for Elements State         ${XPATH_XML}                            Visible                                 15
            Scroll To Element               ${XPATH_XML}
            Highlight Elements              ${XPATH_XML}                            duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
                     
            
            IF    "${DADOS_XML}" == "None" and "${RETORNO_ESPERADO}" != "None"
                #VALIDAÇAO SIMPLES FW
                ${STATUS}=                  Run Keyword And Return Status           Browser.Get Text                        ${XPATH_XML}                            *=                                      ${RETORNO_ESPERADO}
                IF    ${STATUS} == False
                    Fatal Error             \nValor no FW está diferente de ${RETORNO_ESPERADO}!
                END

                Close Browser               CURRENT
                BREAK
                
            ELSE IF    "${DADOS_XML}" != "None" and "${RETORNO_ESPERADO}" == "None"
                #VALIDACAO XML
                @{VALIDAR_XML}=             Split String                            ${DADOS_XML}                            ,                               
                ${TEXTO_XML}=               Get Text Element is Visible             xpath=${XPATH_XML}

                #VERIFICA SE EXISTE ERROR CODE
                ${ErrorCodeExist}=          Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            .//errorCode
                IF    ${ErrorCodeExist} == True
                    ${erroPlanilha}=        Ler Variavel na Planilha                errorCode                               Global
                    ${errorCode}=           XML.Get Element Text                    ${TEXTO_XML}                            .//errorCode
                    IF    "${errorCode}" != "${erroPlanilha}"
                        Fatal Error             \nError Code diferente no FW!
                    END
                END

                #FOR PARA CADA ELEMENTO QUE FOR VALIDAR
                FOR    ${ELEMENTO_XML}  IN  @{VALIDAR_XML}
                    
                    ${RETORNO_ESPERADO}=    Ler Variavel na Planilha                ${ELEMENTO_XML}                         Global

                    #TENTA LER FREQUENCY BAND
                    ${EXIST_FREQUENCY_BAND}=    Run Keyword And Return Status       Ler Variavel na Planilha                frequencyBand                           Global

                    IF    ${EXIST_FREQUENCY_BAND} == True and "${VALOR_BUSCA}" == "Diag_ID" and "${bitState}" != "Bitstream"
                        ${FREQUENCY_BAND}=  Ler Variavel na Planilha                frequencyBand                           Global
                        IF    "${FREQUENCY_BAND}" == "2.4GHz"
                            ${target_data}=         XML.Get Element Text            ${TEXTO_XML}                            .//frequencyBand[text()="2.4GHz"]/..//${ELEMENTO_XML}
                        ELSE IF     "${FREQUENCY_BAND}" == "5GHz"
                            ${target_data}=         XML.Get Element Text            ${TEXTO_XML}                            .//frequencyBand[text()="5GHz"]/..//${ELEMENTO_XML}                            
                        END
                    ELSE  
                        ${target_data}=     XML.Get Element Text                    ${TEXTO_XML}                            .//${ELEMENTO_XML}
                    END

                    IF    "${RETORNO_ESPERADO}" != "${target_data}"
                        Fatal Error         \nValor no FW está diferente de ${RETORNO_ESPERADO}!
                    END

                END

                BREAK
            ELSE
                Fatal Error                 \nArgumentos passados de maneira incorreta!
            END
        ELSE
            Reload
            IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END

    END
    Close Browser                           CURRENT

#===================================================================================================================================================================  
Validar Evento Cancelamento FW
    [Arguments]                             ${EVENTO_FW}                            ${RETORNO_ESPERADO}
    [Documentation]                         Valida evento de cancelamento no FW
    ...                                     | =Arguments= | =Description= |
    ...                                     | `EVENTO_FW` | Evento que deve ser validado. Argumento obrigatório |
    ...                                     | `RETORNO_ESPERADO` | Retorno que deve ser validado, validação simples. Argumento obrigatório |
    ...                                     Exemplo de utilização:
    ...                                     - Validar Evento Cancelamento FW    Appointment.CancelAppointment    code>406<  
    ...                                     Acessa o FW filtrando pela data atual e Work_Order_Id. Seleciona o evento especificado, acessa o passo "END - Finalização do serviço" do Framework, e valida se o retorno esperado está presente.
    ...                                     \nSe a validação não for bem sucedida, ocorre Fatal Error de Evento não encontrado no FW.

   
    ${Work_Order_Id}=                       Ler Variavel na Planilha                workOrderId                     Global
    Set Global Variable                     ${Work_Order_Id}

    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+08%3A00&date2=${Data_FW}+23%3A59&queryText=${Work_Order_Id}
    
    FOR    ${x}      IN RANGE     5
        ${present}=  Run Keyword And Return Status    Wait for Elements State    //a[text()='${EVENTO_FW}'][1]    Visible    10

        IF    ${present} == True
            Click Web Element Is visible    //a[text()='${EVENTO_FW}'][1]
            Sleep                           2s
            Close Page                      CURRENT                         CURRENT                                 CURRENT
            Click Web Element Is visible    //h5[text()="END - Finalização do serviço"]/..//span[2]
            Wait for Elements State         ${xml_retorno}                          Visible                                 15
            Scroll To Element               ${xml_retorno}
            Highlight Elements              ${xml_retorno}                          duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
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
Validar Confirmacao de Agendamento da BA
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Work_Order_Id, acessa o evento Appointment.PostAppointment. Valida, no passo "END - Finalização do serviço", se contém o código >201<.

    Click Web Element Is Visible            ${btn_auditoria_ELK}
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${Work_Order_Id}
    Click Web Element Is Visible            ${refresh_button}
    Click Web Element Is Visible            ${appointment_post}
    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    Sleep                                   2s
    ${STATUS}=                              Browser.Get Text                        ${xml_retorno}                          *=                                      code>201<
#===================================================================================================================================================================  
Validar a Notificação de Agendamento
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Work_Order_Id, acessa o evento Appointment.PostAppointment. Valida, se os passos "START" e "INVOKE", contém o código da atividade 4927.

    ${valor_pesquisa}=                      Ler Variavel na Planilha                associatedDocument                      Global
    
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F

    #ABRIR NAVEGADOR
    Contexto para navegador                  ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${valor_pesquisa}&idService=Appointment.PostAppointment

    FOR    ${x}      IN RANGE     5
    ${present}=  Run Keyword And Return Status    Wait for Elements State       ${appointment_post}    Visible    10
        IF    ${present} == True
            Click Web Element Is visible    ${appointment_post}
            Sleep                           2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT
            Click Web Element Is visible    //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            ${STATUS1}=                     Browser.Get Text                        ${xml_start}                            *=                                      activityType>4927<
            
            Scroll To Element               ${ClienteOperacaoTextInvoke}/../..//textarea/../../..//*[@data-action="collapse"]
            Click Web Element Is visible    ${ClienteOperacaoTextInvoke}/../..//textarea/../../..//*[@data-action="collapse"]
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            ${STATUS2}=                     Browser.Get Text                        ${ClienteOperacaoTextInvoke}            *=                                      tipoAtividade>4929<
            
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${appointment_post} não foi encontrado no FW
            END
        END
    END

#===================================================================================================================================================================  
Validar Abertura Agendamento de Retirada
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Work_Order_Id, acessa o evento ClienteOperacao.ConfirmarSlotAgendamentoFibra. Valida, no passo "END - Finalização do serviço", se contém "<ns2:numeroBA> WORK_ORDER_ID </ns2:numeroBA>".

    Click Web Element Is Visible            ${btn_auditoria_ELK}
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${Work_Order_Id}
    Click Web Element Is Visible            ${refresh_button}
    Click Web Element Is Visible            ${ConfirmarSlotAgendamento}
    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    Sleep                                   2s
    ${STATUS}=                              Browser.Get Text                        ${xml_retorno}                                                               
    Should Contain                          ${STATUS}                               <ns2:numeroBA>${WORK_ORDER_ID}</ns2:numeroBA>   

#===================================================================================================================================================================  
Validar Criação da Ordem
    [Arguments]                             ${COLUNA_PESQUISA}=associatedDocument   ${valor_xml}=code>200<                  ${order_type}=Instalacao
    [Documentation]                         Acessa a Auditoria ELK, acessa o evento ProductOrdering.PostProductOrder. Valida, no passo "END - Finalização do serviço", se contém o código >201<.

    ${valor_pesquisa}=                      Ler Variavel na Planilha                ${COLUNA_PESQUISA}                      Global
    ${XPATH_XML}=                           Set Variable                            //*[text()="END - Finalização do serviço"]/../..//textarea
    
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    #ABRIR NAVEGADOR
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${valor_pesquisa}
    
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${valor_pesquisa}
    Click Web Element Is Visible            ${refresh_button}
    Select Options By                       ${select_number}                        value                                   50

    ${target_event25}=                        Run Keyword And Return Status         Click Web Element Is Visible            ${post_product_orderV25}

    IF    "${target_event25}" == "False"

        ${valor_xml}=                       Evaluate                               code>201<
        Input Text Web Element Is Visible   ${input_texto_consulta}                 ${valor_pesquisa}
        Click Web Element Is Visible        ${refresh_button}
        Select Options By                   ${select_number}                        value                                 50
        ${target_eventv1}=                  Run Keyword And Return Status           Click Web Element Is Visible            ${post_product_order}
       
        IF    "${target_eventv1}" == "False"
            Input Text Web Element Is Visible   ${input_texto_consulta}                 ${valor_pesquisa}
            Click Web Element Is Visible        ${refresh_button}
            Select Options By                   ${select_number}                        value                                 50
            Click Web Element Is Visible        ${post_product_orderV25}
        END 
    END

    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    Sleep                                   2s
    ${STATUS}=                              Browser.Get Text                        ${xml_retorno}                          *=                                      ${valor_xml}
    
    Click Web Element Is visible            (//h5[contains(text(),"INVOKE - Request enviado para o SOM")]/../..//i[@class="ace-icon fa fa-chevron-down"])
    Scroll To Element                       (//h5[contains(text(),"INVOKE - Request enviado para o SOM")]/../..//textarea)
    Highlight Elements                      (//h5[contains(text(),"INVOKE - Request enviado para o SOM")]/../..//textarea)                                          duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                                                                     fileType=jpeg                           timeout=${TIMEOUT}
    ${invoke_xml}=                          Get Text Element is Visible             (//h5[contains(text(),"INVOKE - Request enviado para o SOM")]/../..//textarea)
    Should Contain                          ${invoke_xml}                           <order_type>${order_type}</order_type>
    Should Contain                          ${invoke_xml}                           ${valor_pesquisa}

    Click Web Element Is visible            ${XPATH_XML}/../../..//*[@data-action="collapse"]
    Wait for Elements State                 ${XPATH_XML}                            Visible                                 15
    Scroll To Element                       ${XPATH_XML}
    Highlight Elements                      ${XPATH_XML}                            duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    Close Browser                           CURRENT
#===================================================================================================================================================================  
Validar Cancelamento
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Work_Order_Id, acessa o evento Appointment.CancelAppointment. Valida, no passo "END - Finalização do serviço", se contém o código >200<.

    Click Web Element Is Visible            ${btn_auditoria_ELK}
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${Work_Order_Id}
    Click Web Element Is Visible            ${refresh_button}
    Click Web Element Is Visible            ${CancelAppointment}
    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    Sleep                                   2s
    ${STATUS}=                              Browser.Get Text                        ${xml_retorno}                          *=                                      code>200<

#===================================================================================================================================================================
Validar GetSearchTimeSlot 
    [Arguments]                             ${ADDRESS_ID}
    [Documentation]                         | =Arguments= | =Description= |
    ...                                     | `ADDRESS_ID` | ID do endereço para consulta |
    ...                                     Acessa a Auditoria ELK, busca o ID do endereço e filtra pelo evento Appointment.GetSearchTimeSlot. Valida, no passo "END - Finalização do serviço", se contém o código >404<.

    Click Web Element Is Visible            ${btn_auditoria_ELK}
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${ADDRESS_ID}
    Fill Text                               ${service_filter}                       Appointment.GetSearchTimeSlot
    Click Web Element Is Visible            ${refresh_button}
    Click Web Element Is Visible            ${GetSearchTimeSlot}
    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    Sleep                                   2s
    ${STATUS}=                              Browser.Get Text                        ${xml_retorno}                          *=                                      code>404<

#===================================================================================================================================================================
Validar ChangeEvent
    [Arguments]                             ${WORK_ORDER_ID}
    [Documentation]                         | =Arguments= | =Description= |
    ...                                     | `WORK_ORDER_ID` | ID Work Order |
    ...                                     Acessa a Auditoria ELK, busca pelo Work_Order_Id, acessa o evento Appointment.GetAppointment. Valida, no passo "END - Finalização do serviço", se contém "<ns2:numeroBA> WORK_ORDER_ID </ns2:numeroBA>".

    Click Web Element Is Visible            ${btn_auditoria_ELK}
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${WORK_ORDER_ID}
    Sleep    2
    
    Click Web Element Is Visible            ${refresh_button}
    Click Web Element Is Visible            ${GetAppointment}
    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    Sleep                                   2s
    ${STATUS}=                              Browser.Get Text                                ${xml_retorno}
    
    Should Contain                          ${STATUS}                               <ns2:workOrderID>${WORK_ORDER_ID}</ns2:workOrderID>   

#===================================================================================================================================================================
Validar Criacao da Ordem FTTP
    [Documentation]                         Acessa o evento ProductOrdering.PostProductOrder, pega os seguintes dados na planilha para validação: associatedDocument, correlationOrder, customerName, associatedDocumentDate, subscriberId e somOrderId.
    ...                                     \nRetornos esperados que serão validados no FW:\n
    ...                                     - type >S<
    ...                                     - code >201<
    ...                                     - message >Created<
    ...                                     - id > SOM_Id <

    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    ${present}=  Run Keyword And Return Status    Wait for Elements State       ${post_product_orderV25}    Visible    10

    IF    ${present} == True
        Click Web Element Is visible    ${post_product_orderV25}
        Sleep                           2s
        Close Page                      CURRENT                                 CURRENT                                 CURRENT
    ELSE
        Close Browser                           CURRENT
        Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+08%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.PostProductOrder.v2
        Click Web Element Is Visible            //a[text()="ProductOrdering.PostProductOrder.v2"]
        Sleep                           2s
        Close Page                              CURRENT                                 CURRENT                                 CURRENT
    END
        
    Click Web Element Is Visible            //*[@id="itens"]/div[1]/div[2]/div[1]/span[2]/a
    ${START_XML}=                           Get Text Element is Visible             ${xml_start}                                        
    
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${correlationOrder}=                    Ler Variavel na Planilha                osOrderId                               Global
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global

    Should Contain                          ${START_XML}                            <infraType>FTTP</infraType>
    Should Contain                          ${START_XML}                            <type>Retirada</type>
    Should Contain                          ${START_XML}                            <subscriberId>${subscriberId}</subscriberId>
    Should Contain                          ${START_XML}                            <associatedDocument>${Associated_Document}</associatedDocument>
    Should Contain                          ${START_XML}                            <correlationOrder>${correlationOrder}</correlationOrder>

    Click Web Element Is Visible            //*[@id="itens"]/div[4]/div[2]/div[1]/span[2]/a
    ${END_XML}=                             Get Text Element is Visible             ${xml_retorno}

    Should Contain                          ${END_XML}                              <tns:type>S</tns:type>
    Should Contain                          ${END_XML}                              <tns:code>200</tns:code>
    Should Contain                          ${END_XML}                              <tns:message>Sucesso</tns:message>

#===================================================================================================================================================================
Validar Recebimento de Atividade
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Associated_Document, e filtra pelo evento ProductOrdering.ListenerProductOrderStateChangeEvent. Valida, no passo "END - Finalização do serviço", se contém o código >200<.
    
    Click Web Element Is Visible            ${btn_auditoria_ELK}
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${Associated_Document}
    Fill Text                               ${service_filter}                       ProductOrdering.ListenerProductOrderStateChangeEvent
    Click Web Element Is Visible            ${refresh_button}
    Click Web Element Is Visible            ${ListenerProductOrder}     
    Close Page                              CURRENT                                 CURRENT 
    Sleep                                   2s

    ${STATUS}=                              Browser.Get Text                        ${xml_retorno}                          *=                                      type>200<
#===================================================================================================================================================================
Valida Recebimento de Atividade FTTP
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Associated_Document, e filtra pelo evento ProductOrdering.ListenerProductOrderStateChangeEvent. Pega os seguintes dados na planilha para validação: Associated_Document, correlationOrder, subscriberId e somOrderId.
    ...                                     \nRetornos esperados que serão validados no FW:\n
    ...                                     - associatedDocument > deve ser igual ao da planilha <
    ...                                     - correlationOrder > deve ser igual ao da planilha <
    ...                                     - subscriberId > deve ser igual ao da planilha <
    ...                                     - id > SOM_Id <
    ...                                     - type >Encerramento<
    ...                                     - code >0<
    ...                                     - description > Ordem Encerrada com Sucesso <
    
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    Set Global Variable                     ${Associated_Document}

    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+08%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.ListenerProductOrderStateChangeEvent

    Click Web Element Is Visible            ${ListenerProductOrder}     
    Close Page                              CURRENT                                 CURRENT 
    Sleep                                   2s

    Click Web Element Is Visible            //*[@id="itens"]/div[4]/div[2]/div[1]/span[2]/a
    
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${correlationOrder}=                    Ler Variavel na Planilha                osOrderId                               Global
    ${Subscriber_Id}=                       Ler Variavel na Planilha                subscriberId                            Global
    

    ${INVOKE_XML_CHANGE}=                   Get Text Element is Visible             //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea                     

    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:associatedDocument>${Associated_Document}</tns:associatedDocument>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:correlationOrder>${correlationOrder}</tns:correlationOrder>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:subscriberId>${Subscriber_Id}</tns:subscriberId>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:type>Encerramento</tns:type>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:code>0</tns:code>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:description>Ordem Encerrada com Sucesso</tns:description>
    
#===================================================================================================================================================================
Validar Atualizacao FW
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Work_Order_Id, e filtra pelo evento Appointment.PatchAppointment. Valida, no passo "END - Finalização do serviço", se contém o código >200<.
    
    Click Web Element Is Visible            ${btn_auditoria_ELK}
    Input Text Web Element Is Visible       ${input_texto_consulta}                 ${Work_Order_Id}
    Fill Text                               ${service_filter}                       Appointment.PatchAppointment
    Click Web Element Is Visible            ${refresh_button}
    Click Web Element Is Visible            ${PatchAppointment}     
    Close Page                              CURRENT                                 CURRENT 
    Sleep                                   2s

    ${STATUS}=                              Browser.Get Text                        ${xml_retorno}                          *=                                      code>200<

#===================================================================================================================================================================
Validar ListenerProductOrderCreateEvent
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Work_Order_Id, e filtra pelo evento ProductOrdering.ListenerProductOrderCreateEvent. Valida, no passo "END - Finalização do serviço", se contém o código >200<.
    [Arguments]                             ${DADO_CONSULTA}=associatedDocument


    ${dado}=                                Ler Variavel na Planilha                ${DADO_CONSULTA}                        Global
    Set Global Variable                     ${dado}

    ${associatedDocument}=                  Run Keyword And Return Status           Ler Variavel na Planilha                associatedDocument            Global
    IF    "${associatedDocument}" == "True"
        ${associatedDocument}=              Ler Variavel na Planilha                associatedDocument            Global
        ${associatedDocument}=              Convert To String                       ${associatedDocument}
    ELSE
        ${associatedDocument}=              Ler Variavel na Planilha                associatedDocument             Global
        ${associatedDocument}=              Convert To String                       ${associatedDocument}
    END

    ${correlationOrder}=                    Ler Variavel na Planilha               correlationOrder               Global
    ${correlationOrder}=                    Convert To String                      ${correlationOrder}
    ${somId}=                               Ler Variavel na Planilha               somOrderId                      Global
    ${somId}=                               Convert To String                      ${somId}

    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=&date2=&queryText=${dado}

    Click Web Element Is Visible            ${ProductOrderCreateEvent}
    Close Page                              CURRENT                                 CURRENT                                 CURRENT
    Sleep                                   2s
    Click Web Element Is Visible            (//h5[contains(text(),"INVOKE - Request enviado ao API Gateway")]/../..//i[@class="ace-icon fa fa-chevron-down"])
    ${xmlInvoke}=                          Get Text Element is Visible             (//h5[contains(text(),"INVOKE - Request enviado ao API Gateway")]/../..//textarea)
    Set Global Variable                    ${xmlInvoke}

    Should Contain                          ${xmlInvoke}                           ${associatedDocument}
    Should Contain                          ${xmlInvoke}                           ${correlationOrder}
    Should Contain                          ${xmlInvoke}                           ${somId}
    
    Close Browser                           CURRENT

#===================================================================================================================================================================
Validar SSID no FW
    [Documentation]                         Acessa o passo INVOKE - Request enviado para a ClienteCo. Pega e armazena os seguintes dadosa: ssid, frequencyBand, e wifiIndex. Retorna sucesso "SSID validado e dados armazenados na planilha".
    
    ${invokeText}=                          Get Text Element is Visible             xpath=//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea
    
    Click Web Element Is Visible            xpath=//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//i[@class="ace-icon fa fa-chevron-down"]

    @{SSID_XML}=                            Split String                            ${invokeText}                           <ssid>                                  1                                                   
    @{SSID_XML}=                            Split String                            ${SSID_XML[1]}                          </ssid>                                 1                                                   
    Escrever Variavel na Planilha           ${SSID_XML[0]}                          SSID                                    Global
    
    @{FREQUENCY_XML}=                       Split String                            ${invokeText}                           <frequencyBand>                         1
    @{FREQUENCY_XML}=                       Split String                            ${FREQUENCY_XML[1]}                     GHz                                     1
    Escrever Variavel na Planilha           ${FREQUENCY_XML[0]}                     Frequency_Band                          Global

    @{wifiINDEX_XML}=                       Split String                            ${invokeText}                           <wifiIndex>                             1
    @{wifiINDEX_XML}=                       Split String                            ${wifiINDEX_XML[1]}                     </wifiIndex>                            1
    Escrever Variavel na Planilha           ${wifiINDEX_XML[0]}                     Wifi_Index                              Global

    Log to Console   \n SSID validado e dados armazenados na planilha.

#===================================================================================================================================================================
Validar Dados XML no FW
    [Arguments]                             ${session}                              ${target_xml}
    [Documentation]                         | =Arguments= | =Description= |
    ...                                     | `session` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | `target_xml` | Elementos do XML que devem ser validados. Ex: ssid, wifiIndex, code, frequencyBand, state, etc |
    ...                                     Valida os elementos pedidos e em caso de estarem diferentes do esperado, retorna Fatal Error informando o problema.

    Run Keyword If                          "${session}" == "START"    Retornando XML  [text()="START - Inicialização do serviço"]/../..//textarea
    Run Keyword If                          "${session}" == "INVOKE"    Retornando XML  [text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea
    Run Keyword If                          "${session}" == "RESPONSE"    Retornando XML  [text()="RESPONSE - Resposta recebida da ClientCo"]/../..//textarea
    Run Keyword If                          "${session}" == "END"    Retornando XML  [text()="END - Finalização do serviço"]/../..//textarea

    @{tagsXML}=                             Split String                            ${target_xml}                           ,                               
    
    ${frequency}=                           Ler Variavel na Planilha                frequencyBand                           Global         

    FOR    ${elementOut}  IN  @{tagsXML}
    
        @{target_data}=                     Get Elements Texts                      ${invokeText}                              .//${elementOut}
        Set Global Variable                 ${elementOut}
        
        IF    "${elementOut}" == "subscriberId"
            ${subId}=                       Ler Variavel na Planilha                subscriberId                            Global
            
            IF    "${target_data[0]}" != "${subId}"
                Fatal Error    Subscriber Id diferente do que foi enviado na API.
            END
            
        END

        ${length}=                          Get length                              ${target_data}


        IF    "${elementOut}" == "order"    

            ${str}=      Replace String Using Regexp     ${target_data[0]}      [^0-9a-zA-Z]+       ${EMPTY}
            ${length}= 	Get length 	${str}      
            ${order} =	Get Substring	${str}	0	5
            ${id} =		Get Substring	${str}	5	${length}
            ${target_data[0]}               Catenate    SEPARATOR=-   ${order}		${id}
        END       

        IF    "${elementOut}" == "wlanConfiguration"    

            ${str}=      Replace String Using Regexp     ${target_data[0]}      [^0-9a-zA-Z]+       ${EMPTY}
            ${length}= 	Get length 	${str}      
            ${wlanConfiguration} =	Get Substring	${str}	0	4
            ${enable} =		Get Substring	${str}	4	6
            ${target_data[0]}               Catenate    SEPARATOR=-   ${wlanConfiguration}		${enable}
            IF    "${target_data[0]}" != "true-Up"
                Fatal Error    wlanConfiguration diferente do que esperado.
            END 

        END       

        IF    "${elementOut}" == "promisseDate"    

            
            ${promisseDate}=                Set Variable                            @{target_data}    
            Escrever Variavel na Planilha      ${promisseDate}                      promisseDate                            Global
            BREAK   
            
        END       

        IF    ${length} > 1
            IF    "${frequency}" == "2.4GHz"
                Escrever Variavel na Planilha   ${target_data[0]}                       ${elementOut}                       Global
            ELSE
                Escrever Variavel na Planilha   ${target_data[1]}                       ${elementOut}                       Global

            END
        ELSE
            Escrever Variavel na Planilha   ${target_data[0]}                       ${elementOut}                           Global

        END   


        
        
    END
                                    
    

#===================================================================================================================================================================
Validar Dados XML Encerramento reparo no FW
    [Arguments]                             ${session}                              ${target_xml}
    [Documentation]                         | =Arguments= | =Description= |
    ...                                     | `session` | Passo do framework que deverá ser acessado. Ex: STAR, INVOKE, RESPONSE, END |
    ...                                     | `target_xml` | Elementos do XML que devem ser validados. Ex: ssid, wifiIndex, code, frequencyBand, state, etc |
    ...                                     Valida os elementos pedidos e em caso de estarem diferentes do esperado, retorna Fatal Error informando o problema.

    Run Keyword If                          "${session}" == "START"    Retornando XML  [text()="START - Inicialização do serviço"]/../..//textarea
    Run Keyword If                          "${session}" == "INVOKE"    Retornando XML  [text()="INVOKE - Request enviado ao API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea
    Run Keyword If                          "${session}" == "RESPONSE"    Retornando XML  [text()="RESPONSE - Resposta recebida do API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea
    Run Keyword If                          "${session}" == "END"    Retornando XML  [text()="END - Finalização do serviço"]/../..//textarea

    @{tagsXML}=                             Split String                            ${target_xml}                           ,                               
    
    ${frequency}=                           Ler Variavel na Planilha                frequencyBand                           Global         

    FOR    ${elementOut}  IN  @{tagsXML}
    
        @{target_data}=                     Get Elements Texts                      ${invokeText}                              .//${elementOut}
        Set Global Variable                 ${elementOut}
        
        IF    "${elementOut}" == "subscriberId"
            ${subId}=                       Ler Variavel na Planilha                subscriberId                           Global
            
            IF    "${target_data[0]}" != "${subId}"
                Fatal Error    Subscriber Id diferente do que foi enviado na API.
            END
            
        END

        ${length}=                          Get length                              ${target_data}


        IF    "${elementOut}" == "order"    

            ${str}=      Replace String Using Regexp     ${target_data[0]}      [^0-9a-zA-Z]+       ${EMPTY}
            ${length}= 	Get length 	${str}      
            ${order} =	Get Substring	${str}	0	5
            ${id} =		Get Substring	${str}	5	${length}
            ${target_data[0]}               Catenate    SEPARATOR=-   ${order}		${id}
        END       

        IF    "${elementOut}" == "wlanConfiguration"    

            ${str}=      Replace String Using Regexp     ${target_data[0]}      [^0-9a-zA-Z]+       ${EMPTY}
            ${length}= 	Get length 	${str}      
            ${wlanConfiguration} =	Get Substring	${str}	0	4
            ${enable} =		Get Substring	${str}	4	6
            ${target_data[0]}               Catenate    SEPARATOR=-   ${wlanConfiguration}		${enable}
            IF    "${target_data[0]}" != "true-Up"
                Fatal Error    wlanConfiguration diferente do que esperado.
            END 

        END       

        IF    ${length} > 1
            IF    "${frequency}" == "2.4GHz"
                Escrever Variavel na Planilha   ${target_data[0]}                       ${elementOut}                       Global
            ELSE
                Escrever Variavel na Planilha   ${target_data[1]}                       ${elementOut}                       Global

            END
        ELSE
                Escrever Variavel na Planilha   ${target_data[0]}                       ${elementOut}                           Global

        END   


        
        
    END
                                    
    

#===================================================================================================================================================================
Retornando XML
    [Arguments]                             ${event}
    [Documentation]                         | =Arguments= | =Description= |
    ...                                     | `event` | Caminho do xpath, referênte ao passo do framework que deverá ser acessado, e que deve ser armazenado como variável. Ex: " [text()="START - Inicialização do serviço"]/../..//textarea " para o passo START - Inicialização do serviço |

    ${invokeText}=                          Get Text Element is Visible             xpath=//*${event}
    Set Global Variable                     ${invokeText}

#===================================================================================================================================================================
Validar Mudancas de Estado FW
    [Arguments]                             ${coluna_dat}                             ${state_list}                             ${event}                   ${xmlField}
    [Documentation]                         Validação das mudanças de estado da SA. 
    ...                                     Exemplo de chamada:
    ...                                     #${state_list}=                            Create List                Não atribuído                                                         Atribuído 
    ...                                     #Validar Mudancas de Estado FW             ${state_list}              WorkOrderManagement.ListenerWorkOrderAttributeValueChangeEvent        lifeCycleStatus
    ...


    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F

    ${Query_Dat}=                           Ler Variavel na Planilha                ${coluna_dat}                           Global
    ${SA}=                                  Ler Variavel na Planilha                workOrderId                             Global

    ${trueUnsucess}=                        Run Keyword And Return Status           List Should Not Contain Value           ${state_list}          ACTIVITY_CONCLUDED_UNSUCESSFULLY

    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Query_Dat}&idService=${event}
 
    @{fsl_states}=                          Create List 
    Wait For Elements State                 xpath=//table[@id="sample-table-2"]      visible
    ${row-count}=                           Browser.Get Element Count                xpath=//a[text()="${event}"]                                              
    FOR  ${x}  IN RANGE    ${row-count}
        ${x}=                               Evaluate                                 ${x}+1
        Click Web Element Is Visible        ELEMENT=(//a[text()="${event}"])[${x}]
        Switch Page                         NEW
        Click Web Element Is Visible        ELEMENT=//h5[contains(text(),"INVOKE - Request enviado à fila do SOA")]/../..//i[@class="ace-icon fa fa-chevron-down"]                                                               
        
        ${text-area}=                       Get Text Element is Visible              ${WorkOrderTextInvoke}
        ${auxtext}=                         Split String                             ${text-area}                         <${xmlField}>                        
        ${auxtext}=                         Split String                             ${auxtext[1]}                        </${xmlField}>
        
        ${Atribuir_tecnico}                 Ler Variavel na Planilha                atribuirTecnico                         Global  
        Set Global Variable                 ${Atribuir_tecnico}
        
        ${tecStatus}=                       Fetch from left                         ${Atribuir_tecnico}                     " - "
        ${tecStatus}=                       Run Keyword And Return Status           Should Contain                          ${text-area}                            <tns:name>${Atribuir_tecnico}</tns:name>

        Append To List                      ${fsl_states}                            ${auxtext[0]}   

        IF    "${trueUnsucess}" != "False"
            Should Contain                  ${text-area}                             <tns:id>${SA}</tns:id>
        END

        Close Page                          CURRENT                                  CURRENT
    END

    ${states}=                              Remove Duplicates                        ${fsl_states}
    List Should Contain Sub List            ${states}                                ${state_list}                          msg=Não foram encontrados todos os estados esperados.                                                
    Close Browser                           CURRENT    
#===================================================================================================================================================================
Validar FW Ordem CPOi
    [Arguments]                             ${VALOR_BUSCA}                          
    ...                                     ${XPATH_EVENTO}
    ...                                     ${TENTATIVAS_FOR}=10

    [Documentation]                         Valida Evento no FW em cenários de ativação CPOi   *** Essa keyword extrai o valor do argmuento DADOS_XML
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VALOR_BUSCA` | Valor que será buscado. Ex: PreDiag_ID, Diag_ID, Configuration_Id, Associated_Document, etc. Argumento obrigatório. |
    ...                                     | `XPATH_EVENTO` | Evento que deve ser validado. Modelo: (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]. Argumento obrigatório. |
    ...                                     | `TENTATIVAS_FOR` | Quantas tentativas devem ser realizadas. Se não for passado argumento, por padrão, será usado " 10 " |
    ...                                     \nAcessa o FW, filtrando pela data atual e pelo VALOR_BUSCA. Recarrega a página até que dois eventos sejam exibidos, caso atinja o número de tentativas de carregamento e não apareça, é exibido o erro "Existe apenas um evento, o esperado são dois eventos".
    ...                                     \nClica no evento que deve ser validado, seleciona e expande o XPATH_XML específico, e tiram um screenshot.
    ...                                     \nCaso os dois ou nenhum argumento sejam passados, apresenta o erro "Argumentos passados de maneira incorreta".
    ...                                     \nSe alguma validação não for bem sucedida, ocorre Fatal Error de Evento não encontrado no FW.

    #MODELO XPATH EVENTO:                   (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]

    #PREENCHER VARIAVEIS
    ${TEXTO_BUSCA}=                         Ler Variavel na Planilha                ${VALOR_BUSCA}                          Global                            
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    #ABRIR NAVEGADOR
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${TEXTO_BUSCA}
    
    
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${present}=  Run Keyword And Return Status    Wait for Elements State    ${XPATH_EVENTO}    Visible    10
        IF    ${present} == True
            Click Web Element Is visible    ${XPATH_EVENTO}
            Sleep                           2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT
            Click Web Element Is visible    //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Wait for Elements State         //*[text()="START - Inicialização do serviço"]/../..//textarea                  Visible                                 15
            Scroll To Element               //*[text()="START - Inicialização do serviço"]/../..//textarea
            Highlight Elements              //*[text()="START - Inicialização do serviço"]/../..//textarea                  duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            

            # BUSCA O ORDER ID NO START
            ${TEXTO_XML}=                   Get Text Element is Visible             xpath=//*[text()="START - Inicialização do serviço"]/../..//textarea
            ${TEXTO_XML}=                   Set Variable                            <XML>${TEXTO_XML}</XML>
            ${TEXTO_XML}=                   Parse XML                               ${TEXTO_XML}                           

            
            ${OrderIdExist}=                Run Keyword And Return Status           XML.Get Element                         ${TEXTO_XML}                            /*/*/*/*/*/id
            IF    ${OrderIdExist} == True
                ${OrderId}=                 XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/*/id
                Escrever Variavel na Planilha                                       ${OrderId}                              somOrderId                              Global
            ELSE
                Fatal Error                 \nOrder Id não existe no FW
            END
        
            
            # VALIDA O SUCESSO NO END
            Click Web Element Is visible    //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Wait for Elements State         //*[text()="END - Finalização do serviço"]/../..//textarea                      Visible                                 15
            Scroll To Element               //*[text()="END - Finalização do serviço"]/../..//textarea
            Highlight Elements              //*[text()="END - Finalização do serviço"]/../..//textarea                      duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            
            ${TEXTO_XML}=                   Get Text Element is Visible             xpath=//*[text()="END - Finalização do serviço"]/../..//textarea
            ${TEXTO_XML}=                   Set Variable                            <XML>${TEXTO_XML}</XML>
            ${TEXTO_XML}=                   Parse XML                               ${TEXTO_XML}

            ${TypeExist}=                   Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/type
            ${CodeExist}=                   Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/code
            ${MessageExist}=                Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/message

            IF    ${TypeExist} != True or ${CodeExist} != True or ${MessageExist} != True
                Fatal Error                 \nNão existe mensagem de sucesso no XML END
            ELSE
                ${Type}=                    XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/type
                ${Code}=                    XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/code
                ${Message}=                 XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/message

                IF    "${Type}" != "200" or "${Code}" != "OK" or "${Message}" != "Sucesso"
                    Fatal Error             \nValidação no END diferente do esperado 
                END
            END
                
            BREAK

        ELSE
            Reload
            IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
        

    END
    Close Browser                           CURRENT

#===================================================================================================================================================================
Validar FW Ordem Bitstream
    [Arguments]                             ${VALOR_BUSCA}                          
    ...                                     ${XPATH_EVENTO}
    ...                                     ${TENTATIVAS_FOR}=10

    [Documentation]                         Valida Evento no FW em cenários de ativação CPOi   *** Essa keyword extrai o valor do argmuento DADOS_XML
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VALOR_BUSCA` | Valor que será buscado. Ex: PreDiag_ID, Diag_ID, Configuration_Id, Associated_Document, etc. Argumento obrigatório. |
    ...                                     | `XPATH_EVENTO` | Evento que deve ser validado. Modelo: (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]. Argumento obrigatório. |
    ...                                     | `TENTATIVAS_FOR` | Quantas tentativas devem ser realizadas. Se não for passado argumento, por padrão, será usado " 10 " |
    ...                                     \nAcessa o FW, filtrando pela data atual e pelo VALOR_BUSCA. Recarrega a página até que dois eventos sejam exibidos, caso atinja o número de tentativas de carregamento e não apareça, é exibido o erro "Existe apenas um evento, o esperado são dois eventos".
    ...                                     \nClica no evento que deve ser validado, seleciona e expande o XPATH_XML específico, e tiram um screenshot.
    ...                                     \nCaso os dois ou nenhum argumento sejam passados, apresenta o erro "Argumentos passados de maneira incorreta".
    ...                                     \nSe alguma validação não for bem sucedida, ocorre Fatal Error de Evento não encontrado no FW.

    #MODELO XPATH EVENTO:                   (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]

    #PREENCHER VARIAVEIS
    ${TEXTO_BUSCA}=                         Ler Variavel na Planilha                ${VALOR_BUSCA}                          Global
    ${OrderId}=                             Ler Variavel na Planilha                somOrderId                              Global
    ${OSOrderId}=                           Ler Variavel na Planilha                osOrderId                               Global
    ${AssociatedDoc}=                       Ler Variavel na Planilha                associatedDocument                      Global

    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    #ABRIR NAVEGADOR
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${TEXTO_BUSCA}
    
    
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${present}=  Run Keyword And Return Status    Wait for Elements State    ${XPATH_EVENTO}    Visible    10
        IF    ${present} == True
            Click Web Element Is visible    ${XPATH_EVENTO}
            Sleep                           2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT
            Click Web Element Is visible    //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderInProvisioning]"]/../..//textarea/../../..//*[@data-action="collapse"]
            Wait for Elements State         //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderInProvisioning]"]/../..//textarea                  Visible                                 15
            Scroll To Element               //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderInProvisioning]"]/../..//textarea
            Highlight Elements              //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderInProvisioning]"]/../..//textarea                  duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            

            # BUSCA O ORDER ID, CORRELATION ORDER E ASSOCIATED DOCUMENT NO INVOKE
            ${TEXTO_XML}=                   Get Text Element is Visible             xpath=//*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderInProvisioning]"]/../..//textarea
            ${TEXTO_XML}=                   Set Variable                            <XML>${TEXTO_XML}</XML>
            ${TEXTO_XML}=                   Parse XML                               ${TEXTO_XML}                           

            ${OrderIdExist}=                Run Keyword And Return Status           XML.Get Element                         ${TEXTO_XML}                            /*/*/*/*/order/id
            ${OSOrderIdExist}=              Run Keyword And Return Status           XML.Get Element                         ${TEXTO_XML}                            /*/*/*/*/order/correlationOrder
            ${AssociatedDocExist}=          Run Keyword And Return Status           XML.Get Element                         ${TEXTO_XML}                            /*/*/*/*/order/associatedDocument
           
           IF    ${OrderIdExist} == True
                ${OrderId}=                 XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/*/id
                Escrever Variavel na Planilha                                       ${OrderId}                              somOrderId                              Global
            ELSE
                Fatal Error                 \nOrder Id não existe no FW
            END

            IF    ${OrderIdExist} != True or ${OSOrderIdExist} != True or ${AssociatedDocExist} != True
                Fatal Error                 \nOs campos OrderID, OSOrderId ou AssociatedDocument não existem no FW
            ELSE
                ${SOMOrderId}               XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/order/id
                ${SOMOSOrderId}             XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/order/correlationOrder
                ${AssociatedDocument}       XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/order/associatedDocument

                IF    "${SOMOrderId}" != "${OrderId}" or "${SOMOSOrderId}" != "${OSOrderId}" or "${AssociatedDocument}" != "${AssociatedDoc}"
                    Fatal Error             \nDados no INVOKE diferentes do esperado
                END
            END

            # BUSCA O TASK ID E TYPE                     

            ${TaskIdExist}=                 Run Keyword And Return Status           XML.Get Element                         ${TEXTO_XML}                            /*/*/*/*/*/task/id
            ${TaskTypeExist}=               Run Keyword And Return Status           XML.Get Element                         ${TEXTO_XML}                            /*/*/*/*/*/task/type
           
            IF    ${TaskIdExist} != True or ${TaskTypeExist} != True
                Fatal Error                 \nOs campos Task ID ou Task Type não existem no FW
            ELSE
                ${TaskId}                   XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/*/task/id
                ${TaskType}                 XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/*/task/type

                Escrever Variavel na Planilha                                       ${TaskId}                               taskId                                  Global

                IF    "${TaskType}" != "CONFIGURACAO_NAAS_ACS"
                    Fatal Error             \nTask Type no INVOKE diferentes do esperado
                END
            END
           
           
           
            # VALIDA O SUCESSO NO END
            Click Web Element Is visible    //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Wait for Elements State         //*[text()="END - Finalização do serviço"]/../..//textarea                      Visible                                 15
            Scroll To Element               //*[text()="END - Finalização do serviço"]/../..//textarea
            Highlight Elements              //*[text()="END - Finalização do serviço"]/../..//textarea                      duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            
            ${TEXTO_XML}=                   Get Text Element is Visible             xpath=//*[text()="END - Finalização do serviço"]/../..//textarea
            ${TEXTO_XML}=                   Set Variable                            <XML>${TEXTO_XML}</XML>
            ${TEXTO_XML}=                   Parse XML                               ${TEXTO_XML}

            ${TypeExist}=                   Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/type
            ${CodeExist}=                   Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/code
            ${MessageExist}=                Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/message

            IF    ${TypeExist} != True or ${CodeExist} != True or ${MessageExist} != True
                Fatal Error                 \nNão existe mensagem de sucesso no XML END
            ELSE
                ${Type}=                    XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/type
                ${Code}=                    XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/code
                ${Message}=                 XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/message

                IF    "${Type}" != "OK" or "${Code}" != "200" or "${Message}" != "Sucesso"
                    Fatal Error             \nValidação no END diferente do esperado 
                END
            END
                
            BREAK

        ELSE
            Reload
            IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
        
    END
    Close Browser                           CURRENT

#===================================================================================================================================================================
Validar Notificação de resolução de tarefa
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Work_Order_Id, acessa o evento ProductOrdering.PatchProductOrder e valida os passos "START" e "INVOKE".

    ${valor_pesquisa}=                      Ler Variavel na Planilha                associatedDocument                     Global
    ${coOrder}=                             Ler Variavel na Planilha                correlationOrder                       Global
    
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F

    #ABRIR NAVEGADOR
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${valor_pesquisa}&idService=ProductOrdering.PatchProductOrder

    FOR    ${x}      IN RANGE     5
    ${present}=  Run Keyword And Return Status    Wait for Elements State       ${PatchProductOrder}    Visible    10
        IF    ${present} == True
            Click Web Element Is visible    ${PatchProductOrder}
            Sleep                           2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT
            Click Web Element Is visible    //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            ${STATUS1}=                     Browser.Get Text                        ${xml_start}                            *=                                      observation>Resolucao de pendencia de rede<
            ${STATUS2}=                     Browser.Get Text                        ${xml_start}                            *=                                      code>7111<
            ${STATUS3}=                     Browser.Get Text                        ${xml_start}                            *=                                      correlationOrder>${coOrder}<
            ${STATUS4}=                     Browser.Get Text                        ${xml_start}                            *=                                      associatedDocument>${valor_pesquisa}<
            
            Scroll To Element               ${xml_retorno}/../..//textarea/../../..//*[@data-action="collapse"]
            Click Web Element Is visible    ${xml_retorno}/../..//textarea/../../..//*[@data-action="collapse"]
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            ${STATUS5}=                     Browser.Get Text                        ${xml_retorno}                          *=                                      code>200<
            
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ${PatchProductOrder} não foi encontrado no FW
            END
        END
    END

#===================================================================================================================================================================
Validar Associação de ONT
    [Documentation]                         Acessa a Auditoria ELK, busca pelo Associated_Document, acessa o evento ProductOrdering.ListenerProductOrderStateChangeEvent. Valida, se o passo "INVOKE", contém o código 0 e descrição de Sucesso.

    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    ${OS_Order_Id}=                         Ler Variavel na Planilha                osOrderId                               Global
    ${Subscriber_Id}=                       Ler Variavel na Planilha                subscriberId                            Global
    
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F

    Contexto para navegador                  ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.ListenerProductOrderStateChangeEvent

    FOR    ${x}      IN RANGE     5
    ${present}=  Run Keyword And Return Status    Wait for Elements State       ${ListenerProductOrder}    Visible    10
        IF    ${present} == True
            Click Web Element Is visible    ${ListenerProductOrder}
            Sleep                           2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT
            Click Web Element Is visible    //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea/../../..//*[@data-action="collapse"]
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            
            ${INVOKE_XML}=                  Get Text Element is Visible             ${WorkOrderStateChange}
            Should Contain                  ${INVOKE_XML}                           <tns:associatedDocument>${Associated_Document}</tns:associatedDocument>
            Should Contain                  ${INVOKE_XML}                           <tns:correlationOrder>${OS_Order_Id}</tns:correlationOrder>
            Should Contain                  ${INVOKE_XML}                           <tns:subscriberId>${Subscriber_Id}</tns:subscriberId>
            Should Contain                  ${INVOKE_XML}                           <tns:type>Encerramento</tns:type>
            Should Contain                  ${INVOKE_XML}                           <tns:code>0</tns:code>
            Should Contain                  ${INVOKE_XML}                           <tns:description>SUCESSO</tns:description>

            Scroll To Element               //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Click Web Element Is visible    //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            ${STATUS1}=                     Browser.Get Text                        ${xml_retorno}                          *=                                      type>204<
            ${STATUS2}=                     Browser.Get Text                        ${xml_retorno}                          *=                                      code>OK<
            ${STATUS3}=                     Browser.Get Text                        ${xml_retorno}                          *=                                      message>Sucesso<
            
            BREAK
        ELSE
            Reload
            IF    ${x} == 4
                Fatal Error                 \nEvento ProductOrdering.ListenerProductOrderStateChangeEvent não foi encontrado no FW
            END
        END
    END  
#===================================================================================================================================================================
Valida Notificação Criação Order
    [Arguments]                             ${VALOR_BUSCA}                          
    ...                                     ${XPATH_EVENTO}
    ...                                     ${TENTATIVAS_FOR}=10

    [Documentation]                         Valida Evento no FW em cenários de ativação CPOi   *** Essa keyword extrai o valor do argmuento DADOS_XML
    ...                                     | =Arguments= | =Description= |
    ...                                     | `VALOR_BUSCA` | Valor que será buscado. Ex: PreDiag_ID, Diag_ID, Configuration_Id, Associated_Document, etc. Argumento obrigatório. |
    ...                                     | `XPATH_EVENTO` | Evento que deve ser validado. Modelo: (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]. Argumento obrigatório. |
    ...                                     | `TENTATIVAS_FOR` | Quantas tentativas devem ser realizadas. Se não for passado argumento, por padrão, será usado " 10 " |
    ...                                     \nAcessa o FW, filtrando pela data atual e pelo VALOR_BUSCA. Recarrega a página até que dois eventos sejam exibidos, caso atinja o número de tentativas de carregamento e não apareça, é exibido o erro "Existe apenas um evento, o esperado são dois eventos".
    ...                                     \nClica no evento que deve ser validado, seleciona e expande o XPATH_XML específico, e tiram um screenshot.
    ...                                     \nCaso os dois ou nenhum argumento sejam passados, apresenta o erro "Argumentos passados de maneira incorreta".
    ...                                     \nSe alguma validação não for bem sucedida, ocorre Fatal Error de Evento não encontrado no FW.

    #MODELO XPATH EVENTO:                   (//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]

    #PREENCHER VARIAVEIS
    ${TEXTO_BUSCA}=                         Ler Variavel na Planilha                ${VALOR_BUSCA}                          Global                            
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    #ABRIR NAVEGADOR
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${TEXTO_BUSCA}
    
    
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${present}=  Run Keyword And Return Status    Wait for Elements State    ${XPATH_EVENTO}    Visible    10
        IF    ${present} == True
            Click Web Element Is visible    ${XPATH_EVENTO}
            Sleep                           2s
            Close Page                      CURRENT                                 CURRENT                                 CURRENT
            Click Web Element Is visible    //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Wait for Elements State         //*[text()="START - Inicialização do serviço"]/../..//textarea                  Visible                                 15
            Scroll To Element               //*[text()="START - Inicialização do serviço"]/../..//textarea
            Highlight Elements              //*[text()="START - Inicialização do serviço"]/../..//textarea                  duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            

            # BUSCA O ORDER ID NO START
            ${TEXTO_XML}=                   Get Text Element is Visible             xpath=//*[text()="START - Inicialização do serviço"]/../..//textarea
            ${TEXTO_XML}=                   Set Variable                            <XML>${TEXTO_XML}</XML>
            ${TEXTO_XML}=                   Parse XML                               ${TEXTO_XML}                           

            
            ${OrderIdExist}=                Run Keyword And Return Status           XML.Get Element                         ${TEXTO_XML}                            /*/*/*/*/*/id
            IF    ${OrderIdExist} == True
                ${OrderId}=                 XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/*/id
                ${OrderIdPlanilha}=         Ler Variavel na Planilha                somOrderId                              Global
                IF    "${OrderIdPlanilha}" == "None"
                    Escrever Variavel na Planilha                                   ${OrderId}                              somOrderId                              Global
                ELSE
                    Should Be Equal As Strings                                      ${OrderIdPlanilha}                      ${OrderId}
                END
            ELSE
                Fatal Error                 \nOrder Id não existe no FW
            END
        
            
            # VALIDA O SUCESSO NO END
            Click Web Element Is visible    //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
            Wait for Elements State         //*[text()="END - Finalização do serviço"]/../..//textarea                      Visible                                 15
            Scroll To Element               //*[text()="END - Finalização do serviço"]/../..//textarea
            Highlight Elements              //*[text()="END - Finalização do serviço"]/../..//textarea                      duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
            Take Screenshot                 filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
            
            ${TEXTO_XML}=                   Get Text Element is Visible             xpath=//*[text()="END - Finalização do serviço"]/../..//textarea
            ${TEXTO_XML}=                   Set Variable                            <XML>${TEXTO_XML}</XML>
            ${TEXTO_XML}=                   Parse XML                               ${TEXTO_XML}

            ${TypeExist}=                   Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/type
            ${CodeExist}=                   Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/code
            ${MessageExist}=                Run Keyword And Return Status           XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/message

            IF    ${TypeExist} != True or ${CodeExist} != True or ${MessageExist} != True
                Fatal Error                 \nNão existe mensagem de sucesso no XML END
            ELSE
                ${Type}=                    XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/type
                ${Code}=                    XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/code
                ${Message}=                 XML.Get Element Text                    ${TEXTO_XML}                            /*/*/*/*/message

                IF    "${Type}" != "200" or "${Code}" != "SUCCESS" or "${Message}" != "Sucesso"
                    Fatal Error             \nValidação no END diferente do esperado 
                END
            END
                
            BREAK

        ELSE
            Reload
            IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error                 \nEvento ${EVENTO_FW} não foi encontrado no FW
            END
        END
        
    END 
    Close Browser                           CURRENT
    
#===================================================================================================================================================================
Validar Confirmacao de Bloqueio ou Desbloqueio Total ou Parcial FW
    [Arguments]                             ${TYPE}                          
    ...                                     ${ACTION}
    ...                                     ${CODE}
    [Documentation]                         Busca pelo Associated_Document, e valida os eventos ProductOrdering.ListenerProductOrderStateChangeEven e ProductOrdering.PostProductOrder. Valida, os passos START, END e INVOKE.
    ...                                     \nArgumentos: ACTION = Bloqueio ou Desbloqueio | TOTAL_PARCIAL = bloquear total, desbloquear total, bloquear parcial, desbloquear parcial | CODE = 200 ou 201
                       
    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F
    
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global
    
    # Validação ProductOrdering.PostProductOrder
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.PostProductOrder.v2.5
    ${present1}=  Run Keyword And Return Status    Wait for Elements State          ${post_product_orderV25}                Visible    10

    IF    "${present1}" == "True"
        Click Web Element Is visible        //a[text()="ProductOrdering.PostProductOrder.v2.5"]
        Sleep                               2s
        Close Page                          CURRENT                                 CURRENT                                 CURRENT
    ELSE
        Close Page                          CURRENT                                 CURRENT                                 CURRENT
        Contexto para navegador             ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.PostProductOrder.v2
        ${present2}=                        Run Keyword And Return Status           Wait for Elements State                 ${post_product_orderV2}                 Visible    10
        IF    "${present2}" != "True"
            Fatal Error             \nEvento ProductOrdering.PostProductOrder não foi encontrado no FW
        END
        Click Web Element Is visible        //a[text()="ProductOrdering.PostProductOrder.v2"]
        Sleep                               2s
        Close Page                          CURRENT                                 CURRENT                                 CURRENT
    END
    
    Wait for Elements State                 //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]                     Visible                                 15
    Click Web Element Is visible            //*[text()="START - Inicialização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]   
    Highlight Elements                      //*[text()="START - Inicialização do serviço"]/../..//textarea                  duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    ${STATUS_type}=                         Browser.Get Text                        ${xml_start}                            *=                                      type>${TYPE}<
    ${STATUS_action}=                       Browser.Get Text                        ${xml_start}                            *=                                      action>${ACTION}<
    
    Scroll To Element                       //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
    Click Web Element Is visible            //*[text()="END - Finalização do serviço"]/../..//textarea/../../..//*[@data-action="collapse"]
    Highlight Elements                      //*[text()="END - Finalização do serviço"]/../..//textarea                      duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    ${STATUS_code}=                         Browser.Get Text                        ${xml_retorno}                          *=                                      code>${CODE}<
    ${STATUS_type}=                         Browser.Get Text                        ${xml_retorno}                          *=                                      type>S<
    ${STATUS_message}=                      Browser.Get Text                        ${xml_retorno}                          *=                                      message>Sucesso<
    
    Close Page

    # Validação ProductOrdering.ListenerProductOrderStateChangeEven
    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Associated_Document}&idService=ProductOrdering.ListenerProductOrderStateChangeEvent
    Click Web Element Is Visible            ${ListenerProductOrder}     
    Close Page                              CURRENT                                 CURRENT 
    Sleep                                   2s

    Wait for Elements State                 //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea/../../..//*[@data-action="collapse"]                      Visible                                 15
    
    #${correlationOrder}=                    Ler Variavel na Planilha                Correlation_Order                       Global
    ${Subscriber_Id}=                       Ler Variavel na Planilha                subscriberId                            Global
    
    Scroll To Element                       //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea/../../..//*[@data-action="collapse"]
    Click Web Element Is visible            //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea/../../..//*[@data-action="collapse"]
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    
    ${INVOKE_XML_CHANGE}=                   Get Text Element is Visible             //*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea                     

    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:associatedDocument>${Associated_Document}</tns:associatedDocument>
    # Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:correlationOrder>${correlationOrder}</tns:correlationOrder>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:subscriberId>${Subscriber_Id}</tns:subscriberId>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:type>Encerramento</tns:type>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:code>0</tns:code>
    Should Contain                          ${INVOKE_XML_CHANGE}                    <tns:description>Ordem Encerrada com Sucesso</tns:description>

#===================================================================================================================================================================
Validar Mudancas de Estado FW Voip
    [Arguments]                             ${coluna_dat}                             ${state_list}                             ${event}                   ${xmlField}
    [Documentation]                         Validação das mudanças de estado da SA Voip. 
    ...                                     Exemplo de chamada:
    ...                                     #${state_list}=                            Create List                Não atribuído                                                         Atribuído 
    ...                                     #Validar Mudancas de Estado FW             ${state_list}              WorkOrderManagement.ListenerWorkOrderAttributeValueChangeEvent        lifeCycleStatus
    ...


    ${Data_FW}=                             Get Current Date                        result_format=%d/%m/%Y
    ${Data_FW}=                             Replace String                          ${Data_FW}                              /                                       %2F

    ${Query_Dat}=                           Ler Variavel na Planilha                ${coluna_dat}                           Global
    ${SA}=                                  Ler Variavel na Planilha                workOrderId                             Global

    ${trueUnsucess}=                        Run Keyword And Return Status           List Should Not Contain Value           ${state_list}          ACTIVITY_CONCLUDED_UNSUCESSFULLY

    Contexto para navegador                 ${URL_FW_SEM_LOGIN}?date1=${Data_FW}+01%3A00&date2=${Data_FW}+23%3A59&queryText=${Query_Dat}&idService=${event}
 
    @{fsl_states}=                          Create List 
    Wait For Elements State                 xpath=//table[@id="sample-table-2"]      visible
    ${row-count}=                           Browser.Get Element Count                xpath=//a[text()="${event}"]                                              
    FOR  ${x}  IN RANGE    ${row-count}
        ${x}=                               Evaluate                                 ${x}+1
        Click Web Element Is Visible        ELEMENT=(//a[text()="${event}"])[${x}]
        Switch Page                         NEW
        Click Web Element Is Visible        ELEMENT=//h5[contains(text(),"INVOKE - Request enviado à fila do SOA")]/../..//i[@class="ace-icon fa fa-chevron-down"]                                                               
        
        ${text-area}=                       Get Text Element is Visible              ${WorkOrderTextInvoke}
        ${auxtext}=                         Split String                             ${text-area}                         <${xmlField}>                        
        ${auxtext}=                         Split String                             ${auxtext[1]}                        </${xmlField}>
        
        ${Atribuir_tecnico}                 Ler Variavel na Planilha                atribuirTecnico                         Global  
        Set Global Variable                 ${Atribuir_tecnico}
        
        ${tecStatus}=                       Fetch from left                         ${Atribuir_tecnico}                     " - "
        ${tecStatus}=                       Run Keyword And Return Status           Should Contain                          ${text-area}                            <tns:name>${Atribuir_tecnico}</tns:name>

        Append To List                      ${fsl_states}                            ${auxtext[0]}   

        Close Page                          CURRENT                                  CURRENT
    END

    ${states}=                              Remove Duplicates                        ${fsl_states}
    List Should Contain Sub List            ${states}                                ${state_list}                          msg=Não foram encontrados todos os estados esperados.                                                
    Close Browser                           CURRENT    