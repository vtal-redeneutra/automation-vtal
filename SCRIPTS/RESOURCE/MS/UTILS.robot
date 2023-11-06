*** Settings ***
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     Browser
Library                                     Dialogs
Library                                     ../../RESOURCE/COMMON/LIB/lib_geral.py


Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ./PAGE_OBJECTS.robot

*** Keywords ***


Login ao Portal de Microserviços
    ${user}=                                Ler Variavel Param Global         $.Logins.MS.Usuario                
    ${password}=                            Ler Variavel Param Global         $.Logins.MS.Senha                 
    ${urlMS}=                               Ler Variavel Param Global         $.Urls.MS                  
    
    Contexto para navegador                 ${urlMS}                chromium         

    Browser.Fill Text                       ${userInput}            ${user}
    Browser.Fill Text                       ${passInput}            ${password}
    Browser.Click                           ${loginButtonMS}
    Wait For Elements State                 xpath=//h3[text()="Filtro"]      visible
    
Acessar ${pagina} no menu do PORTAL de Microserviços
    [Documentation]                         Utilizar o nome que aparece ao lado dos ícones no menu do Portal de Microserviços.
    ...                                     Ex: API Gateway, SOA, Microserviços

    Browser.Click                           xpath=//span[text()="Auditoria"]
    Browser.Click                           xpath=//a[@aria-label="${pagina}"]/../..
    
Procurar por ${servico} referente ao ${documento}
    [Documentation]                         Pesquisa o evento relacionado ao dado existente na dat do cenário.
    ...                                     Ex: Appointment.CancelAppointment e associatedDocument
    
    ${termo}=                               Ler Variavel na Planilha                ${documento}                            Global
               
    Browser.Fill Text                       ${inputTermo}                           ${termo}
    Browser.Take Screenshot
    Browser.Click                           ${buttonSearch}
    Browser.Take Screenshot
    Browser.Click                           xpath=//div[text()="10"]
    Browser.Keyboard Key                    press                                   ArrowDown
    Browser.Keyboard Key                    press                                   ArrowDown
    Browser.Keyboard Key                    press                                   Enter
    
    ${success}=                             Run Keyword And Return Status           Browser.Click                           xpath=(//td[@data-label="Serviço"]//a[text()="${servico}"])[1]

    FOR    ${x}    IN RANGE      ${10}
        IF    "${success}" == "False"
            Browser.Click                   ${buttonSearch}
            Sleep                           2s
            ${success}=                     Run Keyword And Return Status           Browser.Click                           xpath=(//td[@data-label="Serviço"]//a[text()="${servico}"])[1]
        ELSE
            BREAK
        END
    END

    Browser.Switch Page                     NEW

Extrair dado do Bloco
    [Arguments]                             ${BLOCO}                                ${CAMPO-JSON}                           ${COLUNA-DAT}
    ${jsonBloco}=                           Browser.Get Text                        //span[text()="${BLOCO}"]/../../../../..//div[@class="accordion-collapse collapse"]//div
    ${jsonBloco}=                           Convert String To Json                  ${jsonBloco}
    ${Path}=                                Set Variable                            $..${CAMPO-JSON}
    ${jsonBloco}=                           Get Value From Json                     ${jsonBloco}                            ${Path}                           
    Escrever Variavel na Planilha           ${jsonBloco[0]}                         ${COLUNA-DAT}                           Global

Validar dado do Bloco com a DAT
    [Arguments]                             ${JSON-OU-XML}                         ${BLOCO}                                ${CAMPO}                           ${COLUNA-DAT}

    [Documentation]                         Valida campo do JSON referente ao bloco em questão de acordo com dado da planilha.
    ...                                     Argumento JSON ou XML indica o tipo do texto do bloco em questão.
                                            
    ${dado}=                                Ler Variavel na Planilha                ${COLUNA-DAT}                          Global
    ${jsonBloco}=                           Browser.Get Text                         //span[text()="${BLOCO}"]/../../../../..//div[@class="accordion-collapse collapse"]//div                            
    IF    "${JSON-OU-XML}" == "JSON"
        Should Contain                      ${jsonBloco}                            "${CAMPO}": "${dado}"        ignore_case=true                    msg=Validação do campo ${CAMPO} falhou!
    ELSE
        Should Contain                      ${jsonBloco}                            ${CAMPO}>${dado}<            ignore_case=true                    msg=Validação do campo ${CAMPO} falhou!
    END
Validar dado do Bloco com o Argumento
    [Arguments]                             ${JSON-OU-XML}                         ${BLOCO}                                ${CAMPO}                           ${VALOR}
    
    [Documentation]                         Valida campo do JSON referente ao bloco em questão de acordo com dado do argumento.
    ...                                     Argumento JSON ou XML indica o tipo do texto do bloco em questão.

    ${jsonBloco}=                           Browser.Get Text                        //span[text()="${BLOCO}"]/../../../../..//div[@class="accordion-collapse collapse"]//div                            
    IF    "${JSON-OU-XML}" == "JSON"
        Should Contain                      ${jsonBloco}                            "${CAMPO}": "${VALOR}"        ignore_case=true                    msg=Validação do campo ${CAMPO} falhou!
    ELSE
        Should Contain                      ${jsonBloco}                            ${CAMPO}>${VALOR}<            ignore_case=true                    msg=Validação do campo ${CAMPO} falhou!
    END
    
Validar texto do Bloco com o Argumento
    [Arguments]                             ${BLOCO}                                ${TEXTO-BLOCO}                          
    
    [Documentation]                         Utilizar essa keyword quando o dado do bloco não estiver em formato JSON.

    ${txtBloco}=                            Browser.Get Text                               //span[text()="${BLOCO}"]/../../../../..//div[@class="accordion-collapse collapse"]//div                            
    Should Contain                          ${txtBloco}                            ${TEXTO-BLOCO}                           ignore_case=true                    msg=Validação do TEXTO falhou!

Validar Mudanca de Estados no Portal de Microserviços
    [Arguments]                             ${coluna_dat}                             ${state_list}                             ${event}                   ${xmlField}
    [Documentation]                         Validação das mudanças de estado da SA. 
    ...                                     Exemplo de chamada:
    ...                                     #${state_list}=                                                     Create List                Não atribuído                                                         Atribuído 
    ...                                     #Validar Mudanças de Estados no Portal de Microserviços             ${state_list}              WorkOrderManagement.ListenerWorkOrderAttributeValueChangeEvent        lifeCycleStatus
    ...

    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços

    ${termo}=                               Ler Variavel na Planilha                ${coluna_dat}                          Global
               
    Browser.Fill Text                       ${inputTermo}                           ${termo}
    Browser.Take Screenshot
    Browser.Click                           ${buttonSearch}
    Browser.Take Screenshot
    Browser.Click                           xpath=//div[text()="10"]
    Browser.Keyboard Key                    press                                   ArrowDown
    Browser.Keyboard Key                    press                                   ArrowDown
    Browser.Keyboard Key                    press                                   Enter
    
    ${Query_Dat}=                           Ler Variavel na Planilha                ${coluna_dat}                           Global
    
    @{fsl_states}=                          Create List 
    ${row-count}=                           Browser.Get Element Count               xpath=//a[text()="${event}"]                                              
    FOR  ${x}  IN RANGE    ${row-count}
        ${x}=                               Evaluate                                 ${x}+1
        Browser.Click                       xpath=(//a[text()="${event}"])[${x}]
        Switch Page                         NEW                                                     
        
        ${text-area}=                       Browser.Get Text                         xpath=//span[contains(text(),"INVOKE")]/../../../../..//div[@class="accordion-collapse collapse"]//div
        ${auxtext}=                         Split String                             ${text-area}                         <${xmlField}>                        
        ${auxtext}=                         Split String                             ${auxtext[1]}                        </${xmlField}>
        
        Append To List                      ${fsl_states}                            ${auxtext[0]}   
        Close Page                          CURRENT                                  CURRENT
    END

    ${states}=                              Remove Duplicates                        ${fsl_states}
    List Should Contain Sub List            ${states}                                ${state_list}                          msg=Não foram encontrados todos os estados esperados.                                                
    Close Browser                           CURRENT 