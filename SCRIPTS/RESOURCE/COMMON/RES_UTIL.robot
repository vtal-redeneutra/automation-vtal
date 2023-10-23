*** Settings ***
Documentation                               Resource com características em comum entre ambientes/sistemas


*** Settings ***
Library                                     JSONLibrary

Resource                                    ./RES_EXCEL.robot
# Library                                     ./LIB/lib_geral.py
# Resource                                    ./RES_LOG.robot


*** Variable ***
${DIR_VTAL}                                 ${/}robot${/}test
# ${DIR_VTAL}                                 C:${/}IBM_VTAL
${DIR_DAT}                                  ${DIR_VTAL}${/}DATA
${DIR_API}                                  ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}API
${DIR_COMMON}                               ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}COMMON
${DIR_FSL}                                  ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}FSL
${DIR_FW}                                   ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}FW
${DIR_OPM}                                  ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}OPM
${DIR_SFCRM}                                ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}SFCRM
${DIR_SOM}                                  ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}SOM
${DIR_NETQ}                                 ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}NETQ
${DIR_CEMOBILE}                             ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}CE_MOBILE
${DIR_NETWIN}                               ${DIR_VTAL}${/}SCRIPTS${/}RESOURCE${/}NETWIN
${DIR_ROBS}                                 ${DIR_VTAL}${/}SCRIPTS${/}ROBS
${DIR_TRG}                                  ${DIR_VTAL}${/}SCRIPTS${/}TRG
${DIR_MOBS}                                 ${DIR_VTAL}${/}SCRIPTS${/}MOBS
${PRM_GLOBAL}                               ${DIR_DAT}${/}Param_Global.xlsx
${API_BASEPATH}                             https://apitrg.vtal.com.br
${API_AUTH}                                 ${API_BASEPATH}/auth/oauth/v2/token
${API_BASEAPPOINTMENT}                      ${API_BASEPATH}/api/appointment/v1
${API_BASEAPPOINTMENT_V2}                   ${API_BASEPATH}/api/appointment/v2
${API_BASEGEOGRAPHICADDRES}                 ${API_BASEPATH}/api/geographicAddressManagement/v1
${API_BASERESOURCEPOOL_V1}                  ${API_BASEPATH}/api/resourcePoolManagement/v1
${API_BASERESOURCEPOOL_V2}                  ${API_BASEPATH}/api/resourcePoolManagement/v2
${API_BASEPRODUCTORDERING}                  ${API_BASEPATH}/api/productOrdering/v2
${API_BASEPRODUCTORDERING_V1}               ${API_BASEPATH}/api/productOrdering/v1
${API_BASESERVICETEST}                      ${API_BASEPATH}/api/serviceTestManagement/v1
${API_BASECONFIGURATION}                    ${API_BASEPATH}/api/serviceActivationAndConfiguration/v1
${API_BASETROUBLETICKET}                    ${API_BASEPATH}/api/troubleTicket/v1/troubleTicket
${API_BASECANCELTROUBLETICKET}              ${API_BASEPATH}/api/troubleTicket/v1
${API_BASECPOI}                             ${API_BASEPATH}/api/productOrdering/v1
${Keyword_Cenario_Comparar}                 A


*** Keywords ***
    [Documentation]                         São separadas primeiro as Keywords para funções gerais como click e depois funções mais especificas como login

Input Text Web Element Is Visible
    [Documentation]                         Função que insere uma informação num elemento da tela.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    ...                                     | ``VALUE`` | Valor a ser adicionado ao campo. |
    ...                                     Abaixo alguns exemplos de como usar a função, seja como uma variavel ou com o xpath:
    ...                                     | ${input_login}                        //input[contains(@id,'username')]
    ...                                     | Input Text Web Element Is Visible     ${input_login}                          admin        
    ...                                     Biblioteca ultilizada: [https://marketsquare.github.io/robotframework-browser/Browser.html#Fill%20Text|Browser >>]
    [Arguments]                             ${ELEMENT}                              ${VALUE} 
    Wait for Elements State                 ${ELEMENT}                              Visible                                 timeout=${TIMEOUT}
    Fill Text                               ${ELEMENT}                              ${VALUE}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=3.5px                             color=/#dd00dd                          style=solid      
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}

#=========================================================================================================================================================================================================================
Click Web Element Is Visible
    [Documentation]                         Função que clica com o botão do mouse num elemento da tela.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    ...                                     Abaixo alguns exemplos de como usar a função, seja como uma variavel ou com o xpath:
    ...                                     | ${btn_login}                          //input[contains(@id,'Login')]
    ...                                     | Click Web Element Is Visible          ${btn_login}       
    ...                                     Biblioteca ultilizada: [https://marketsquare.github.io/robotframework-browser/Browser.html#Fill%20Text|Browser >>]
    [Arguments]                             ${ELEMENT}  
    Wait for Elements State                 ${ELEMENT}                              Visible                                 timeout=${TIMEOUT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                 
    Browser.Click                           ${ELEMENT}
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}
    
#=========================================================================================================================================================================================================================
Right Click Web Element Is Visible
    [Documentation]                         Função que clica com o botão direito do mouse num elemento da tela.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    ...                                     Abaixo alguns exemplos de como usar a função, seja como uma variavel ou com o xpath:
    ...                                     | ${btn_login}                          //input[contains(@id,'Login')]
    ...                                     | Right Click Web Element Is Visible          ${btn_login}
    [Arguments]                             ${ELEMENT}  
    Wait for Elements State                 ${ELEMENT}                              Visible                                 timeout=${TIMEOUT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                 
    Click                                   ${ELEMENT}                              right
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}

#=========================================================================================================================================================================================================================
Get Text Element is Visible
    [Documentation]                         Busca o elemento passado como argumento e retorna a STR na variável Return_ELEMENT
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    [Arguments]                             ${ELEMENT}
    Sleep                                   3s
    ${Return_ELEMENT}=                      Browser.Get Text                        ${ELEMENT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}
    [Return]                                ${Return_ELEMENT}

#=========================================================================================================================================================================================================================
Get Property With Specific Element is Visible
    [Documentation]                         Busca o elemento passado como argumento e retorna a STR na variável Return_ELEMENT
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    [Arguments]                             ${ELEMENT}                              ${SPECIFIC_PROPERTY}
    Sleep                                   3s
    ${Return_ELEMENT}=                      Browser.Get Property                    ${ELEMENT}                              ${SPECIFIC_PROPERTY}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}
    [Return]                                ${Return_ELEMENT}

#=========================================================================================================================================================================================================================
Get Class Element is Visible
    [Documentation]                         Busca o elemento passado como argumento e retorna uma lista com as classes desse elemento
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    [Arguments]                             ${ELEMENT}
    Sleep                                   3s
    ${Return_ELEMENT}=                      Browser.Get Classes                     ${ELEMENT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}
    [Return]                                ${Return_ELEMENT}

#=========================================================================================================================================================================================================================
Get Element Count is Visible
    [Documentation]                         Busca o elemento passado como argumento e retorna um INT (com a quantidade de vezes que o elemento aparece) na variável Return_ELEMENT
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    [Arguments]                             ${ELEMENT}
    Sleep                                   3s
    ${Return_ELEMENT}=                      Browser.Get Element Count               ${ELEMENT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}
    [Return]                                ${Return_ELEMENT}

#=========================================================================================================================================================================================================================
Get Text Element is Visible Valida
    [Documentation]                         Busca o elemento passado como argumento, compara com o resultado esperado e retorna a STR na variável Return_ELEMENT
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    [Arguments]                             ${ELEMENT}                              ${Tipo_validacao}                       ${Resultado_esperado}
    Wait for Elements State                 ${ELEMENT}                              Visible                                 timeout=${TIMEOUT}
    Sleep                                   3s
    ${Return_ELEMENT}=                      Browser.Get Text                        ${ELEMENT}                              ${Tipo_validacao}                       ${Resultado_esperado}
    Highlight Elements                      ${ELEMENT}                              duration=300ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}
    [Return]                                ${Return_ELEMENT}

#=========================================================================================================================================================================================================================
Check CheckBox Element is Visible
    [Documentation]                         Clica no checkbox passado como argumento
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    [Arguments]                             ${ELEMENT}
    Wait for Elements State                 ${ELEMENT}                              Visible                                 timeout=${TIMEOUT}
    Check Checkbox                          ${ELEMENT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                 
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}

#=========================================================================================================================================================================================================================
Select Element is Visible
    [Documentation]                         Retorna uma lista de elementos que foram selecionados de acordo com o parâmetro passado
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    ...                                     | ``ELEMENT_SELECT`` | Critério que será usado para selecionar os elementos. Pode ser valor, texto ou índice. |
    [Arguments]                             ${ELEMENT}                              ${ELEMENT_SELECT}
    Wait for Elements State                 ${ELEMENT}                              Visible                                 timeout=${TIMEOUT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                 
    Select Options By                       ${ELEMENT}                              text                                    ${ELEMENT_SELECT}
    BuiltIn.Sleep                           0.5
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}

#=========================================================================================================================================================================================================================
Take Screenshot Web Element is visible
    [Documentation]                         Tira um Print da tela quando o elemento passado como argumento for identificado
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ELEMENT`` | Variavel do Elemento HTML ou XPath. |
    [Arguments]                             ${ELEMENT}
    Wait for Elements State                 ${ELEMENT}                              Visible                                 timeout=${TIMEOUT}
    Scroll To Element                       ${ELEMENT}
    Highlight Elements                      ${ELEMENT}                              duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    Wait Until Keyword Succeeds             ${TIMEOUT}                              5s                                      Take Screenshot                         selector=${ELEMENT}                     filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    # Validar o Nome da Keyword
    # Write Image in Doc File Evidencia       ${PATH_RESULTS}

#=========================================================================================================================================================================================================================
Validar o Nome da Keyword
    [Documentation]                         Escreve o nome da Keyword no documento de evidência
    ${Keyword_Cenario_image}=               keyword name
    ${Keyword_Cenario_image}=               Split String                            ${Keyword_Cenario_image}                .
    ${Keyword_Cenario_image}=               Set Variable                            ${Keyword_Cenario_image}[1]   

    IF  "${Keyword_Cenario_image}"!="${Keyword_Cenario_Comparar}"
        ${Keyword_Cenario_Comparar}=        Set Variable                            ${Keyword_Cenario_image}
        Set Global Variable                 ${Keyword_Cenario_Comparar}
        Break page Evidencia
        Inserir no Documento Evidencia      Script: ${Keyword_Cenario_image}
    END
               
#=========================================================================================================================================================================================================================
Gerar Nr de Serie
    ${letras}=                              Generate Random String                  3                                       ABCDEFGHIJKLMNOPQRSTUVWXYZ
    ${numeros}=                             Generate Random String                  5                                       1234567890
    ${nr_serie}=                            Set Variable                            ${letras}${numeros}
    Set Global Variable                     ${nr_serie}

#=========================================================================================================================================================================================================================
Pegar porta Appium
    [Documentation]                         Keyword responsável por retornar a porta que o appium está sendo executado.
    
    ${File}=                                Get File                                C:\\ProgramData\\BlueStacks_nxt\\bluestacks.conf
    @{list}=                                Split to lines                          ${File}     
    FOR    ${line}  IN  @{list}
        ${Value}=                           Get Variable Value                      ${line}
        ${Value}=                           Split String                            ${Value}                                =
        ${ExistePorta}=                     Run Keyword And Return Status           Should contain                          ${Value[0]}                             .status.adb_port
        IF    ${ExistePorta}
            ${Value[1]}=                    Replace String                          ${Value[1]}                             "                                       ${EMPTY}  
            ${PortaAppium}=                 Set Variable                            ${Value[1]}
        END
    END

    [Return]                                ${PortaAppium}

#=========================================================================================================================================================================================================================
Contexto para navegador
    [Documentation]                         Keyword responsável por Criar contextos padrões para navegadores
    [Arguments]                             ${url_Sistema}                          ${Navegador}=chromium
    # ${har}=                                 Create Dictionary                       path=${PATH_RESULTS}/har.json           omitContent=False                       #mode=minimal
    
    # ${height}=                              Get Viewport Height
    # ${width}=                               Get Viewport Width
    
    New Browser                             ${Navegador}                                
    ...                                     True
    ...                                     devtools=False
    ...                                     timeout=01:00

    # New Context
    # ...                                     viewport={'width': ${width}, 'height': ${height}}
    # ...                                     colorScheme=dark
    # ...                                     recordHar=${har}
    # ...                                     recordVideo={'dir':'videos', 'size':{'width': ${width}, 'height': ${height}}}
    # ...                                     reducedMotion=reduce
    
    Set Browser Timeout                     1m 30 seconds
    New Page                                ${url_Sistema}

#=========================================================================================================================================================================================================================
Contexto para navegador com arquivo
    [Documentation]                         Keyword responsável por Criar contextos padrões para navegadores
    [Arguments]                             ${url_Sistema}                          ${Navegador}=chromium
    ${har}=                                 Create Dictionary                       path=${PATH_RESULTS}/har.json           omitContent=False                       #mode=minimal

    ${height}=                              Get Viewport Height
    ${width}=                               Get Viewport Width

    New Browser                             ${Navegador}                                
    ...                                     False
    ...                                     devtools=False
    ...                                     timeout=01:00
    
    New Context
    ...                                     viewport={'width': ${width}, 'height': ${height}}
    ...                                     colorScheme=dark
    ...                                     storageState=${PATH_AUTENTICACAO}
    ...                                     recordHar=${har}
    ...                                     recordVideo={'dir':'videos', 'size':{'width': ${width}, 'height': ${height}}}
    ...                                     reducedMotion=reduce
    

    Set Browser Timeout                     1m 30 seconds
    New Page                                ${url_Sistema}

#=========================================================================================================================================================================================================================
Setup cenario
    [Arguments]                             ${Credencial}

    Criar Documento LOG
    Salvar Crendencial na Planilha          ${Credencial}                     