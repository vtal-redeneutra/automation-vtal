*** Settings ***
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     Browser
Library                                     Dialogs
Library                                     ../../RESOURCE/COMMON/LIB/lib_geral.py

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/SALESFORCE/PAGE_OBJECTS.robot
Resource                                    ../../RESOURCE/SALESFORCE/VARIABLES.robot


*** Variables ***
${URL_CONSULTA_SA}


*** Keywords ***
Abrir site e Logar no SALESFORCE
    [Documentation]                         Faz Login colocando a autenticação de dois fatores.
    ...                                     \nPreenche dados de login com usuário e senha da planilha, faz a autenticação de dois fatores, e ao final salva o arquivo com os coockies e permissões.

    ${Usuario_SALESFORCE}=                  Ler Variavel Param Global               $.Logins.SALESFORCE.Usuario                      
    ${Senha_SALESFORCE}=                    Ler Variavel Param Global               $.Logins.SALESFORCE.Senha                        
    ${URL_SALESFORCE}=                      Ler Variavel Param Global               $.Urls.SALESFORCE                          

    #Usa a Função criada em Python, File Exists para validar se existe o arquivo de Cookies e permissões dentro da pasta
    ${AUTH_EXIST}=                          File Exists                             ${PATH_AUTENTICACAO}
    ${hr_atual}=                            Get Current Date                        exclude_millis=yes
    Set Global Variable                     ${hr_atual}

    #Verifica se o arquivo existe para usar ele na hora do login, se não ele chama a função sem autenticação
    IF  ${AUTH_EXIST}
        Contexto para navegador com arquivo    ${URL_SALESFORCE}                       
    ELSE
        Contexto para navegador                ${URL_SALESFORCE}
    END

    #Valida se os botões estão na tela, se não estiverem segue o fluxo
    ${Input_Login_Valida}=                  Get Element Count is Visible            ${input_login_SALESFORCE}
    
    IF      "${Input_Login_Valida}" == "1"
        #Usa os cookies para logar e continua o login
        Wait for Elements State             ${btn_login_SALESFORCE}                 Visible                                 timeout=${TIMEOUT}
        Input Text Web Element Is Visible   ${input_login_SALESFORCE}               ${Usuario_SALESFORCE}
        Input Text Web Element Is Visible   ${input_password_SALESFORCE}            ${Senha_SALESFORCE}
        Click Web Element Is Visible        ${btn_login_SALESFORCE}
        ${EXIST}=                           Run Keyword And Return Status           Wait for Elements State                 ${input_validacao}                      Visible                                 5
        Run Keyword If                      ${EXIST} == True                        Validar Two Factor
    END
    
    Salvar Arquivo Permissao SALESFORCE

#===================================================================================================================================================================
Salvar Arquivo Permissao SALESFORCE
    [Documentation]                         Salva o arquivo com os coockies e permissões, que será válido por 1 hora. (Salva o arquivo e escreve na planilha a data de expiração como 3600 segundos)

    ${state_file}=                          Save Storage State
    Rename File                             ${state_file}                           ${PATH_OLD_AUTENTICAO}
    Move File                               ${PATH_OLD_AUTENTICAO}                  ${PATH_AUTENTICACAO}
#===================================================================================================================================================================
Fazer Logout SALESFORCE
    [Documentation]                         Realizar o Logout do FSL após execução do script

    Click Web Element Is Visible            ${btn_perfil_SALESFORCE}
    Click Web Element Is Visible            ${span_logout_FSL_SALESFORCE}
    Sleep                                   5s
    Close Browser                           CURRENT

    ${validadeAuthFSL_posLogout}=           Subtract Time From Date                 ${hr_atual}                             86400 seconds

#===================================================================================================================================================================
Criar Novo Cliente
    [Arguments]                             ${tipoDeRegistro}
    [Documentation]                         Valida se BSS Vtal está selecionado e clica em "+Novo cliente"

    ${bssVtalVisivel}    Run Keyword And Return Status    Wait Until Element Is Visible    ${barraDeContexto}//span[@title='BSS Vtal']    10
    IF    ${bssVtalVisivel} == False
        Click Web Element Is Visible        ${btnIniciadorDeAplicativos}
        Click Web Element Is Visible        ${btnVisualizarTudoSalesforce}
        Click Web Element Is Visible        ${btnAlicativoBSS}
    END

    Click Web Element Is Visible            ${setaCliente}
    Click Web Element Is Visible            ${btnNovoCliente}
    # Seleciona o tipo de registro
    Click Web Element Is Visible            //span[text()="${tipoDeRegistro}"]/../..//span[@class="slds-radio--faux"]
    Click Web Element Is Visible            ${btnAvancarNovoCliente}

#===================================================================================================================================================================
Criar cadastro no CP
    [Documentation]                         Cria um cadastro no CP Conta Comercial ou Conta Serviço

    #Informações de input (lidas referente a planilha)
    ${contaNome}                            Ler Variavel na Planilha                nomeConta                               Global
    ${email}                                Ler Variavel na Planilha                email                                   Global
    ${telefone}                             Ler Variavel na Planilha                telefone                                Global
    ${UF}                                   Ler Variavel na Planilha                UF                                      Global
    ${customerName}                         Ler Variavel na Planilha                customerName                            Global
    ${nomeFantasia}                         Ler Variavel na Planilha                nomeFantasia                            Global
    ${nomeCDC}                              Ler Variavel na Planilha                nomeCDC                                 Global    
    ${CFOP}                                 Ler Variavel na Planilha                codCFOP                                 Global
    ${CNAE}                                 Ler Variavel na Planilha                codCNAE                                 Global
    ${inscricaoEstadual}                    Ler Variavel na Planilha                inscricaoEstadual                       Global
    ${tipologradouroPrincipal}              Ler Variavel na Planilha                tipologradouroPrincipal                 Global
    ${logradouroPrincipal}                  Ler Variavel na Planilha                logradouroPrincipal                     Global
    ${cep}                                  Ler Variavel na Planilha                cep                                     Global
    ${numero}                               Ler Variavel na Planilha                numero                                  Global
    ${bairro}                               Ler Variavel na Planilha                bairro                                  Global
    ${munincipio}                           Ler Variavel na Planilha                munincipio                              Global
    ${idEndereco}                           Ler Variavel na Planilha                idEndereco                              Global
    ${codAnatel}                            Ler Variavel na Planilha                codAnatel                               Global
    ${cnpj}                                 Ler Variavel na Planilha                cnpj                                    Global

    #Acessar a aba de contas comerciais em novo cliente
    Click Web Element Is Visible            ${setaCliente}
    Click Web Element Is Visible            ${btnNovoCliente}
    Click Web Element Is Visible            ${btnContasComerciais}
    Click Web Element Is Visible            ${btnAvancarNovoCliente}
    
    #aba 1 - Informações sobre a conta
    Input Text Web Element Is Visible       ${inputNomeConta}                       ${contaNome}
    Click Web Element Is Visible            ${optionsClienteInternacional}
    Click Web Element Is Visible            ${valorNãoClienteInternacional}     
    Input Text Web Element Is Visible       ${inputCNPJ}                            ${cnpj} 
    Input Text Web Element Is Visible       ${inputEmail}                           ${email}
    Input Text Web Element Is Visible       ${inputTelefone}                        ${telefone}
    Input Text Web Element Is Visible       ${inputCelular}                         ${telefone} 
    Click Web Element Is Visible            ${optionsWhatsapp}  
    Click Web Element Is Visible            ${valorNãoWhatsapp}  
    Click Web Element Is Visible            ${optionsUFRaiz}      
    Click Web Element Is Visible            xpath=//*[@data-value="${UF}"] 
    Click Web Element Is Visible            ${optionsContaPai}
    Input Text Web Element Is Visible       ${optionsContaPai}                      ${customerName}
    Click Web Element Is Visible            xpath=//*[text()="Informações sobre a conta"]/../..//*[text()="${customerName}"]
    Click Web Element Is Visible            ${optionsStatusCliente}
    Click Web Element Is Visible            ${statusClienteNovo}
    Input Text Web Element Is Visible       ${inputEmailFatura}                     ${email}
    Input Text Web Element Is Visible       ${inputEmailConfirmacaoFatura}          ${email}
    
    #aba 2 - Detalhes Adicionais da Empresa
    Scroll To Element                       ${inputNomeFantasia}
    Input Text Web Element Is Visible       ${inputNomeFantasia}                    ${nomeFantasia}
    Click Web Element Is Visible            ${optionsSituacaoCadastral}
    Click Web Element Is Visible            ${situacaoCadastralAtiva}
    Click Web Element Is Visible            ${optionsEmpresa}
    Click Web Element Is Visible            ${empresaEAassociados} 
    Click Web Element Is Visible            ${optionsAtuaInternacional}
    Click Web Element Is Visible            ${atuaInternacionalNão}
    Input Text Web Element Is Visible       ${inputNomeCDC}                         ${nomeCDC}
    Click Web Element Is Visible            ${optionsCFOP} 
    Input Text Web Element Is Visible       ${optionsCFOP}                          ${CFOP}
    Click Web Element Is Visible            xpath=//label[text()="CFOP"]/..//*[text()="${CFOP}"]
    Click Web Element Is Visible            ${optionsCodigoCNAE}
    Click Web Element Is Visible            xpath= //label[text()="Código CNAE"]/..//*[@data-value="${CNAE}"]
    Input Text Web Element Is Visible       ${inputInscricaoEstadual}               ${inscricaoEstadual}
    Click Web Element Is Visible            ${optionsInsençãoICMS}
    Click Web Element Is Visible            ${insençãoICMSNão}
    Click Web Element Is Visible            ${optionsDeferimentoICMS}
    Click Web Element Is Visible            ${deferimentoICMSNão}
    Click Web Element Is Visible            ${optionsInsentoISS}
    Click Web Element Is Visible            ${optionsInsentoISS}
    Click Web Element Is Visible            ${insentoISSNão}
    Click Web Element Is Visible            ${optionsAtendimento}
    Click Web Element Is Visible            ${atendimentoGerVendas}  
    Click Web Element Is Visible            ${optionsOrganizacaoVendas}  
    Click Web Element Is Visible            ${organizacaoVendasSudeste} 

    #aba 3 - Endereço Principal
    Scroll To Element                       ${optionsUF}
    Click Web Element Is Visible            ${optionsUF}
    Click Web Element Is Visible            xpath= //*[text()="UF"]/..//*[text()="${UF}"]
    Click Web Element Is Visible            ${optionsLogradouroPrincipal}
    Click Web Element Is Visible            xpath=//label[text()="Tipo de Logradouro Principal"]/..//*[text()="${tipologradouroPrincipal}"]
    Input Text Web Element Is Visible       ${inputNumero}                          ${numero} 
    Input Text Web Element Is Visible       ${inputBairro}                          ${bairro}
    Click Web Element Is Visible            ${optionsRegiao} 
    Click Web Element Is Visible            ${regiaoSudeste}
    Input Text Web Element Is Visible       ${inputCep}                             ${cep}
    Input Text Web Element Is Visible       ${inputLogradouroPrincipal}             ${logradouroPrincipal}
    Click Web Element Is Visible            ${inputMunincipio}
    Input Text Web Element Is Visible       ${inputMunincipio}                      ${munincipio}
    Click Web Element Is Visible            xpath=(//span[text()="Endereço Principal"]/../..//label[text()="Município"]/..//*[@title="${munincipio}"])[last()]
    
    #aba 4 - Endereço de Faturamento
    Scroll To Element                       ${optionsUffaturamento}
    Click Web Element Is Visible            ${optionsEnderecoFaturamento}
    Click Web Element Is Visible            ${enderecoFaturamentoSim}    
    Click Web Element Is Visible            ${optionsUffaturamento}
    Click Web Element Is Visible            xpath=//label[text()="UF de Faturamento"]/..//*[text()="${UF}"]
    Click Web Element Is Visible            ${tipoLogradouroFaturamento}
    Click Web Element Is Visible            xpath=//label[text()="Tipo de Logradouro Faturamento"]/..//*[text()="${tipologradouroPrincipal}"]
    Input Text Web Element Is Visible       ${inputNumeroFaturamento}               ${numero} 
    Input Text Web Element Is Visible       ${inputBairroFaturamento}               ${bairro}
    Scroll To Element                       ${optionsRegiaoFaturamento}
    Click Web Element Is Visible            ${optionsRegiaoFaturamento}
    Click Web Element Is Visible            ${regiaoSudesteFaturamento}
    Input Text Web Element Is Visible       ${inputIdEnderecoFaturamento}           ${idEndereco}
    Input Text Web Element Is Visible       ${inputIdCodigoAnatel}                  ${codAnatel}
    Input Text Web Element Is Visible       ${cepFaturamento}                       ${cep}
    Input Text Web Element Is Visible       ${logradouroFaturamento}                ${logradouroPrincipal}
    Click Web Element Is Visible            ${inputMunincipioFaturamento}
    Input Text Web Element Is Visible       ${inputMunincipioFaturamento}           ${munincipio}
    Click Web Element Is Visible            xpath=(//*[text()="Endereço de Faturamento"]/../..//label[text()="Município"]/..//*[@title="${munincipio}"])[last()]
    Scroll To Element                       ${logradouroFaturamento}
    Click Web Element Is Visible            ${buttonSalvarCriar} 
    Sleep                                   10s   
    Click Web Element Is Visible            ${buttonFechar}

    #Janela da validação do cadastro no CP
    ${retornoContaNome}                     Get Text Element is Visible             ${campoNomeConta} 
    Should Be Equal As Strings              ${retornoContaNome}                     ${contaNome}

    Click Web Element Is Visible            ${buttonVendas}
    Click Web Element Is Visible            ${buttonServicos}   
    Click Web Element Is Visible            ${buttonContratos}
    Close Browser                           CURRENT
#===================================================================================================================================================================
Consulta a CP 
    [Documentation]                         Pesquisa a CP após o cadastro no Salesforce
    
    Click Web Element Is Visible            ${btnPesquisarSalesforce}
    Click Web Element Is Visible            ${inputPesquisarTudo} 
    Input Text Web Element Is Visible       ${inputPesquisarTudo}                   Clientes
    Keyboard Key                            press                                   ArrowDown
    Sleep                                   3s
    Keyboard Key                            press                                   Enter

    ${contaNome}                            Ler Variavel na Planilha                nomeConta                               Global
    Input Text Web Element Is Visible       ${inputPesquisar}                       ${contaNome}
    Click Web Element Is Visible            xpath=//mark[@class="data-match"][contains(.,'${contaNome}')]
    
    ${retornoContaNome}                     Get Text Element is Visible             ${campoNomeConta} 
    Should Be Equal As Strings              ${retornoContaNome}                     ${contaNome}

#===================================================================================================================================================================
Criar contato CP
    [Documentation]                         Cria um contato no CP
    
    ${primeiroNome}                         Ler Variavel na Planilha                nome                                    Global
    ${sobrenome}                            Ler Variavel na Planilha                sobrenome                               Global
    ${nomeCompleto}                         Ler Variavel na Planilha                nomeCompleto                            Global
    ${emailContato}                         Ler Variavel na Planilha                emailContato                            Global
    ${telefone}                             Ler Variavel na Planilha                telefone                                Global
    ${contaNome}                            Ler Variavel na Planilha                nomeConta                               Global

    Click Web Element Is Visible            ${buttonRelacionado}
    Click Web Element Is Visible            ${buttonCriarContato}    

    #Tela de preenchimento do contrato
    Click Web Element Is Visible            ${optionsTratamento}    
    Click Web Element Is Visible            ${optionsTratamentoSra} 
    Input Text Web Element Is Visible       ${inputPrimeiroNome}                    ${primeiroNome}
    Input Text Web Element Is Visible       ${inputSobrenome}                       ${sobrenome}
    Input Text Web Element Is Visible       ${inputEmailContato}                    ${emailContato}
    Input Text Web Element Is Visible       ${inputTelefoneContato}                 ${telefone}
    Input Text Web Element Is Visible       ${inputCelularContato}                  ${telefone}
    Click Web Element Is Visible            ${optionsPerfil}
    Click Web Element Is Visible            ${optionsBSSVtal} 
    Click Web Element Is Visible            ${optionsCargo} 
    Click Web Element Is Visible            ${optionsGerenteCoorde} 
    Click Web Element Is Visible            ${optionsWhapContato}  
    Click Web Element Is Visible            ${optionsWhapNãoContato} 
    Click Web Element Is Visible            ${buttonSalvarContato} 
    
    #Validação do contato criado no CP
    Click Web Element Is Visible            xpath=//*[@class="flex-wrap-ie11 slds-truncate"]//span[text()="${nomeCompleto}"]    
    ${retornoContaNome}                     Get Text Element is Visible             ${campoNomeConta} 
    Should Be Equal As Strings              ${retornoContaNome}                     ${contaNome}
    Close Browser                           CURRENT
#===================================================================================================================================================================
Acessar e criar senha no Youmail
    [Documentation]                         Abrir e logar no YopMail, entra no link de alterar senha.
    [TAGS]                                  Login YopMail

    ${usuarioYopMail}=                      Ler Variavel na Planilha                emailContato                            Global                       
    
    Contexto para navegador                 ${UrlEmail}                                                        
    Wait For Elements State                 ${inputEmailYouMail}                    visible                                 timeout=${TIMEOUT}

    Input Text Web Element Is Visible       ${inputEmailYouMail}                    ${usuarioYopMail}
    Click Web Element Is Visible            ${buttonLogarYouMail} 
    Click Web Element Is Visible            ${emailVtalYouMail}
    Click Web Element Is Visible            ${linkYouMail}  
    Sleep                                   10s

    Switch Page                             NEW 
    Pause execution                         Digite a senha e envie, depois clique no "OK"  
    Close Browser                           CURRENT
#===================================================================================================================================================================

