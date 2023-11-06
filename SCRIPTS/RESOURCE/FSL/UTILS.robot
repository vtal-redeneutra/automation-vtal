*** Settings ***
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     Browser
Library                                     Dialogs
Library                                     ../../RESOURCE/COMMON/LIB/lib_geral.py

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/FSL/PAGE_OBJECTS.robot
Resource                                    ../../RESOURCE/FSL/VARIABLES.robot


*** Variables ***
${URL_CONSULTA_SA}


*** Keywords ***
Logar no FSL
    [TAGS]                                  LoginSFL
    [Documentation]                         Faz login no FSL.
    ...                                     \nVerifica se o navegador já está aberto, se tiver, ele segue. Valida se existe o arquivo de Cookies e permissões dentro da pasta, e verifica se o Token ainda está ativo.
    ...                                     Se estiver ok, entra direto e não precisa fazer a autenticação de dois fatores. Se não, é feito o Login colocando a autenticação de dois fatores.

    #Enche as variaveis de Work_Order_id e as datas do inicio e fim do agendamento
    Preencher o Work_Order_Id e data do agendamento

    #Valida se tem um navegador aberto
    ${navegador}=                           Get Browser Ids
    ${navegador_length}=                    Get length                              ${navegador}
   
   #Valida Se o navegador está aberto, se estiver ele segue
    IF  "${navegador_length}" == "0"
        Abrir site e Logar no FSL
        Consultar SA e pegar URL
    ELSE
        Close Browser                       CURRENT
        Logar no FSL
    END

#===========================================================================================================================================================================================================
Abrir site e Logar no FSL
    [Documentation]                         Faz Login colocando a autenticação de dois fatores.
    ...                                     \nPreenche dados de login com usuário e senha da planilha, faz a autenticação de dois fatores, e ao final salva o arquivo com os coockies e permissões.

    ${Usuario_FSL}=                         Ler Variavel Param Global               $.Logins.FSL.Usuario                             
    ${Senha_FSL}=                           Ler Variavel Param Global               $.Logins.FSL.Senha                                 
    ${URL_FSL}=                             Ler Variavel Param Global               $.Urls.FSL                                     

    #Usa a Função criada em Python, File Exists para validar se existe o arquivo de Cookies e permissões dentro da pasta
    ${AUTH_EXIST}=                          File Exists                            ${PATH_AUTENTICACAO}
    ${hr_atual}=                            Get Current Date                        exclude_millis=yes
    Set Global Variable                     ${hr_atual}

    #Verifica se o arquivo existe para usar ele na hora do login, se não ele chama a função sem autenticação
    IF  ${AUTH_EXIST}
        Contexto para navegador com arquivo    ${URL_FSL}                       
    ELSE
        Contexto para navegador                ${URL_FSL}
    END

    #Valida se os botões estão na tela, se não estiverem segue o fluxo
    ${Input_Login_Valida}=                  Get Element Count is Visible            ${input_login}
    
    IF      "${Input_Login_Valida}" == "1"
        #Usa os cookies para logar e continua o login
        Wait for Elements State             ${btn_login}                            Visible                                 timeout=${TIMEOUT}
        Input Text Web Element Is Visible   ${input_login}                          ${Usuario_FSL}
        Input Text Web Element Is Visible   ${input_password}                       ${Senha_FSL}
        Click Web Element Is Visible        ${btn_login}
        ${EXIST}=                           Run Keyword And Return Status           Wait for Elements State                 ${input_validacao}                      Visible                                 5
        Run Keyword If                      ${EXIST} == True                        Validar Two Factor
    END
    
    Wait for Elements State                 ${btn_pesquisar}                        Visible                                 timeout=${TIMEOUT}
    Salvar Arquivo Permissao

#===========================================================================================================================================================================================================
Preencher o Work_Order_Id e data do agendamento
    [Tags]                                  RealizarAtribuicaoCompromissoSFL
    [Documentation]                         Preenche as variaveis de Work_Order_id, e as datas do inicio e fim do agendamento.
    ...                                     \nConfigura como variáveis globais.

    ${INICIO_AGENDAMENTO}=                  Ler Variavel na Planilha                appointmentStart                       Global
    ${FINAL_AGENDAMENTO}=                   Ler Variavel na Planilha                appointmentFinish                      Global
    ${WORKORDERID}=                         Ler Variavel na Planilha                workOrderId               	        Global
    ${INICIO_AGENDAMENTO}=                  Replace String                          ${INICIO_AGENDAMENTO}                   T                                       " "
    ${INICIO_AGENDAMENTO}=                  Convert Date                            ${INICIO_AGENDAMENTO}                   result_format=%d/%m/%Y %H:%M
    ${FINAL_AGENDAMENTO}=                   Replace String                          ${FINAL_AGENDAMENTO}                    T                                       " "
    ${FINAL_AGENDAMENTO}=                   Convert Date                            ${FINAL_AGENDAMENTO}                    result_format=%d/%m/%Y %H:%M
    Set Global Variable                     ${WORKORDERID}
    Set Global Variable                     ${INICIO_AGENDAMENTO}
    Set Global Variable                     ${FINAL_AGENDAMENTO}

#===========================================================================================================================================================================================================
Validar Two Factor
    [TAGS]                                  TwoFactorSFL
    [Documentation]                         Faz a Validação de dois fatores no SFL. Abre uma caixa de diálogo solicitando que o usuário digite o número de validação que foi enviado.
    ...                                     \nO número é enviado para o telefone ou e-mail do usuário, dependendo das preferencias no FSL.

    ${Validacao}=                           Get Value From User                     Digite o número para validação que foi enviado
    Click Web Element Is Visible            ${input_validacao}
    Input Text Web Element Is Visible       ${input_validacao}                      ${Validacao}
    Click Web Element Is Visible            ${btn_verificar}
    Wait for Elements State                 ${btn_pesquisar}                        Visible                                 timeout=${TIMEOUT}

#===========================================================================================================================================================================================================
Salvar Arquivo Permissao
    [Documentation]                         Salva o arquivo com os coockies e permissões, que será válido por 1 hora. (Salva o arquivo e escreve na planilha a data de expiração como 3600 segundos)

    ${state_file}=                          Save Storage State
    Rename File                             ${state_file}                           ${PATH_OLD_AUTENTICAO}
    Move File                               ${PATH_OLD_AUTENTICAO}                  ${PATH_AUTENTICACAO}

#===========================================================================================================================================================================================================
Acessar Menu Vendas
    [Documentation]                         Inicia e abre o Menu das Vendas.

    Click Web Element Is Visible            ${btn_iniciador}
    Click Web Element Is Visible            ${input_apps}
    Wait for Elements State                 ${menu_vendas}                          Visible                                 timeout=${TIMEOUT}

#===========================================================================================================================================================================================================
Consultar SA
    [Documentation]                         Acessa o Menu de Vendas, filtra por Compromissos de Serviços, pesquisa pelo Work Order ID e entra na SA.

    ${URL_ATUAL_SA}=                        Get Url

    IF  "${URL_ATUAL_SA}" != "${URL_CONSULTA_SA}"
        Go To                               ${URL_CONSULTA_SA}
    END

#===========================================================================================================================================================================================================
Consultar SA e pegar URL
    [Documentation]                         Acessa o Menu de Vendas, filtra por Compromissos de Serviços, pesquisa pelo Work Order ID e entra na SA.

    IF   "${URL_CONSULTA_SA}" == ""
        
        #Valida se está na parte de Vendas, se não tiver acessa, se já estiver apenas segue
        ${Application_option}=              Get Text Element is Visible             ${span_vendas}
        Run Keyword If                      "${Application_option}" != "Vendas"     Acessar Menu Vendas
        
        Wait For Elements State             ${btn_pesquisar}                        Visible
        Click Web Element Is Visible        ${btn_pesquisar}
        Wait For Elements State             ${input_pesquisa_tudo}                  Visible
        
        ${EXIST}=                           Run Keyword And Return Status           Wait for Elements State                 ${input_pesquisa_tudo}                  Visible                                 5
        Run Keyword If                      ${EXIST} != True                        Click Web Element Is Visible            ${btn_pesquisar}

        ${validate_compromisso_serviço}=    Run Keyword And Return Status           Wait for Elements State                 ${input_pesquisa_compromisso}           Visible                                 5
        
        WHILE    ${validate_compromisso_serviço} != True
            Input Text Web Element Is Visible                                       ${input_pesquisa_tudo}                  Compromissos de serviços
            Keyboard Key                    press                                   ArrowDown
            Sleep                           3s
            Keyboard Key                    press                                   Enter
            ${validate_compromisso_serviço}=     Run Keyword And Return Status      Wait for Elements State                 ${input_pesquisa_compromisso}           Visible                                 5
        END

        Input Text Web Element Is Visible   ${input_SA}                             ${WORKORDERID}
        Click Web Element Is Visible        //span[@title="${WORKORDERID}"]

    ELSE
        Go To                               ${URL_CONSULTA_SA}
    END


    ${SA_site}=                             Get Text Element is Visible             ${value_SA}

    IF  "${SA_site}" != "${WORKORDERID}"
        ${URL_CONSULTA_SA}=                 Set Variable                            ${EMPTY}
        Set Global Variable                 ${URL_CONSULTA_SA}
        Consultar SA e pegar URL
    ELSE
        ${URL_CONSULTA_SA}=                 Get Url
        Set Global Variable                 ${URL_CONSULTA_SA}
    END

#===========================================================================================================================================================================================================
Consultar Relacionado
    Click Web Element Is Visible                ${btn_relacionado}
    Sleep                                       4s
    Take Screenshot Web Element is visible      ${btn_relacionado}

#===========================================================================================================================================================================================================
Consultar Acao
    Click Web Element Is Visible               ${btn_acao}
    Sleep                                      4s
    Take Screenshot Web Element is visible     ${btn_relacionado}

#===========================================================================================================================================================================================================
Gerar Nr de Serie FSL
    [Documentation]                         Gera uma variavel Nr de Serie que é composta por 3 números e 5 letras aleatorios
    ${letras}=                              Generate Random String                  3                                       ABCDEFGHIJKLMNOPQRSTUVWXYZ
    ${numeros}=                             Generate Random String                  5                                       1234567890
    ${nr_serie}=                            Set Variable                            ${letras}${numeros}
    Set Global Variable                     ${nr_serie}

#===========================================================================================================================================================================================================
Fazer Logout
    [Documentation]                         Realizar o Logout do FSL após execução do script

    Click Web Element Is Visible            ${btn_perfil}
    Click Web Element Is Visible            ${span_logout_FSL}
    Sleep                                   5s
    Close Browser                           CURRENT

    ${validadeAuthFSL_posLogout}=           Subtract Time From Date                 ${hr_atual}                             86400 seconds
    
#===========================================================================================================================================================================================================
Auditoria de Tarefas
    [Documentation]                         Realiza a autoria das tarefas no FSL
    [Arguments]                             ${estado_encerramento}=Concluído com sucesso

    Logar no FSL
    BuiltIn.Sleep                           2

    Click Web Element Is Visible            ${btn_relacionado}
    Scroll To                               vertical=bottom
    Click Web Element Is Visible            ${exibirTudo}

    Wait for Elements State                 ${tabela_CompromissoServico}            Visible                                 ${TIMEOUT}
    Take Screenshot Web Element is visible  ${campo_Criado}

    Click Web Element Is Visible            ${filtro}
    Input Text Web Element Is Visible       ${campo}                                estado
    Click Web Element Is Visible            ${botao_aplicar}

    Take Screenshot Web Element is visible                                          ${estado_Atribuido}
    Take Screenshot Web Element is visible                                          ${estado_NaoAtribuido}
    Take Screenshot Web Element is visible                                          ${estado_Recebido}
    Take Screenshot Web Element is visible                                          ${estado_emDeslocamento}
    Take Screenshot Web Element is visible                                          ${estado_emExecucao}
    Take Screenshot Web Element is visible                                          ${estado_fechadoEmWFM}
    Take Screenshot Web Element is visible                                          xpath=(//span[@title="${estado_encerramento}"])[last()]
    Close Browser                           CURRENT

#===========================================================================================================================================================================================================