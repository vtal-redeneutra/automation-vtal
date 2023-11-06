*** Settings ***
Documentation                               Script para troca de CDOE via SOM.

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SALESFORCE}/UTILS.robot
Resource                                    ${DIR_SALESFORCE}/PAGE_OBJECTS.robot


*** Keywords ***
Criar Organizacao para CP
    [Documentation]                         Cria uma organização no Salesforce

    ${customerName}                         Ler Variavel na Planilha                customerName                            Global

    Abrir site e Logar no SALESFORCE
    
    Criar Novo Cliente                      tipoDeRegistro=Organização

    # Preenche o nome da conta e salva
    Input Text Web Element Is Visible       ${inputNomeDaOrganizacao}               ${customerName}        # NOME PROVISORIO
    Click Web Element Is Visible            ${btnSalvar}
    
    # Valida as informações de Nome da Conta e Código da Organização
    Click Web Element Is Visible            ${setaCliente}
    Click Web Element Is Visible            //a[normalize-space()='${customerName}']/span

    ${nomeDaConta}                          Get Text Element is Visible             ${nomeDaContaCliente}
    Should Be Equal As Strings              ${nomeDaConta}                          ${customerName}

    ${codigoOrganizacao}                    Get Text Element is Visible             ${codOrganizacao}
    Escrever Variavel na Planilha           ${codigoOrganizacao}                    codigoDaOrganizacao                     Global

#===========================================================================================================================
Cadastro de CP no Salesforce
    [Documentation]                         Cria um novo cadastro de CP no Salesforce Anchor ou Other
    
    Abrir site e Logar no SALESFORCE
    Criar cadastro no CP
#===========================================================================================================================
Criar Oportunidade de uma CP no Salesforce
    [Documentation]                         Cria Oportunidade de CP no Salesforce
    [Arguments]                             ${cenarioAtual}
    Abrir site e Logar no SALESFORCE
    Consulta a CP 
    Criar Oportunidade CP                   ${cenarioAtual}
    Agendamento de Reunião                  assuntoReuniao=Reunião de Apresentação  descricao=Reunião para a apresentação 
    Alterar fase da CP para apresentacao
#===========================================================================================================================
Criar Oportunidade CP
    [Arguments]                             ${cenarioAtual}
    [Documentation]                         Cria Oportunidade de CP

    Click Web Element Is Visible            ${setaOportunidades}
    Click Web Element Is Visible            ${btnNovaOportunidade}
    
    #Informações da oportunidade
    ${dataSalesforce}=                      Get Current Date                        result_format=%d/%m/%Y
    ${contaNome}                            Ler Variavel na Planilha                nomeConta                               Global
    ${customerName}                         Ler Variavel na Planilha                customerName                            Global

    Input Text Web Element Is Visible       ${inputNovaOportunidade}                ${customerName}
    Click Web Element Is Visible            ${inputNomeDaContaOportunidade}         
    Click Web Element Is Visible            xpath=//label[normalize-space()='*Nome da conta']/..//*[text()="${contaNome}"]
    Click Web Element Is Visible            ${tipoNegociacao}     
    Click Web Element Is Visible            ${novoContrato}        
    Click Web Element Is Visible            ${origemLead}   
    Click Web Element Is Visible            ${origemOutros}     
    Click Web Element Is Visible            ${dataFechamento}    
    Input Text Web Element Is Visible       ${dataFechamento}                       ${dataSalesforce}
    Click Web Element Is Visible            ${probabilidadeFechamento}
    Click Web Element Is Visible            ${probabilidadeFechamento}
    Click Web Element Is Visible            ${fechamentopossivel}    
    Click Web Element Is Visible            ${campoFase}    
    Click Web Element Is Visible            ${faseBacklog}    
    
    #Informações de Contrato
    IF    "${cenarioAtual}" == "Anchor"
        Scroll To Element                   ${tipoContrato}
        Click Web Element Is Visible        ${tipoContrato}
        Click Web Element Is Visible        ${contratoAnchor}   
        Click Web Element Is Visible        ${classeProduto}     
        Click Web Element Is Visible        ${produtoclasseFTTP}  
        Click Web Element Is Visible        ${condicaoComercial} 
        Click Web Element Is Visible        ${outraCondicao}   
        Input Text Web Element Is Visible   ${prazoEntrega}                         6
    ELSE IF    "${cenarioAtual}" == "Other"
        Scroll To Element                   ${tipoContrato}
        Click Web Element Is Visible        ${tipoContrato}
        Click Web Element Is Visible        ${contratoOther}  
        Click Web Element Is Visible        ${classeProduto}     
        Click Web Element Is Visible        ${produtoclasseFTTP}  
        Click Web Element Is Visible        ${condicaoComercial} 
        Click Web Element Is Visible        ${condicaoPadrao} 
        Input Text Web Element Is Visible   ${prazoEntrega}                         6
    END

    #Informações NDA
    Scroll To Element                       ${informacoesSigilosas}
    Click Web Element Is Visible            ${informacoesSigilosas}
    Click Web Element Is Visible            ${sigilosasSim}    
    Click Web Element Is Visible            ${buttonSalvarCriar} 
    Sleep                                   10s
    Click Web Element Is Visible            ${buttonFechar}     
#===========================================================================================================================
Agendamento de Reunião 
    [Arguments]                             ${assuntoReuniao}                       ${descricao}
    [Documentation]                         Realiza o agendamento de uma reunião
    ...                                     Tela de oportunidade

    ${nomeConta}                            Ler Variavel na Planilha                nomeConta                               Global
    ${nomeCompleto}                         Ler Variavel na Planilha                nomeCompleto                            Global
    ${munincipio}                           Ler Variavel na Planilha                munincipio                              Global

    Click Web Element Is Visible            ${novoCompromissoReuniao}
    Click Web Element Is Visible            ${inputAssuntoReuniao}
    Click Web Element Is Visible            xpath=//*[text()="Assunto"]/..//*[text()="${assuntoReuniao}"]    
    Input Text Web Element Is Visible       ${descricaoReuniao}                     ${descricao}
    Input Text Web Element Is Visible       ${localReuniao}                         ${munincipio}
    Click Web Element Is Visible            ${contatoReuniao}
    Scroll To Element                       ${NomeContato} 
    Click Web Element Is Visible            ${NomeContato} 
    Click Web Element Is Visible            xpath=//a[@role="option"][contains(.,'${nomeCompleto}')][contains(.,'${nomeConta}')]
    Click Web Element Is Visible            ${buttonSalvarContato}
#===========================================================================================================================
Alterar fase da CP para apresentacao
    [Documentation]                         Loga no Salesforce, pesquisa a CP na e altera as fases

    Janela de oportunidade

    Get Text Element is Visible Valida      ${validaBacklog}                        ==                                      Backlog
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase}  
    Click Web Element Is Visible            ${abordagemInicial}
    Click Web Element Is Visible            ${buttonSalvarContato}
    Sleep                                   5s    
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase} 
    Click Web Element Is Visible            ${reuniaoApresentacao}
    Click Web Element Is Visible            ${buttonSalvarContato}
    Get Text Element is Visible Valida      ${validaApresentacao}                   ==                                      Reunião de Apresentação
#===========================================================================================================================
Criar Contato de CP no Salesforce
    [Documentation]                         Loga no Salesforce, pesquisa a CP na barra de pesquisar e cria um contato.
    Abrir site e Logar no SALESFORCE
    Consulta a CP 
    Criar contato CP
#===========================================================================================================================
Gerar um contrato principal na CP
    [Documentation]                         Loga no Salesforce, pesquisa a CP na barra de pesquisar e cria um contrato
    Abrir site e Logar no SALESFORCE
    Consulta a CP 
    Gerar Contrato Principal
    Alterar status da CP para DocSign
    Alterar status para NDA Anexado
    Alterar fase para envio de proposta
    Agendamento de Reunião                  assuntoReuniao=Reunião de Negociação    descricao=Reunião para a negociação
    Alterar fase para negociacao
    Adicionar/remover municípios
#===========================================================================================================================
Configurar Oportunidade na CP
    [Documentation]                         Loga no Salesforce, pesquisa a CP na barra de pesquisar e cria um contrato
    Abrir site e Logar no SALESFORCE
    Consulta a CP 
    Configurar Oportunidade
#===========================================================================================================================
Configurar a Oportunidade na CP
    [Documentation]                         Loga no Salesforce e faz o processo de configurar Oportunidade na CP do Salesforce e realização de alteração dos valores.
    Abrir site e Logar no SALESFORCE
    Consulta a CP 
    Configurar Oportunidade
    Realizar a Alteração dos Valores
    Alterar fase para fechamento ganho
#===========================================================================================================================
Gerar Contrato Principal 
    [Documentation]                         Loga no Salesforce, pesquisa a CP na barra de pesquisar e e gera um contrato principal.

    #Processo para chegar a tela do contrato 
    Janela de oportunidade

    #Clica no botão "Gerar NDA" preenche o campo Status e salva
    Click Web Element Is Visible            ${buttonGerarNDA}
    Click Web Element Is Visible            ${optionsStatus}    
    Click Web Element Is Visible            ${caixaEntradaStatus}     
    Click Web Element Is Visible            ${buttonSalvarContato}    
    # Sleep                                   10s
    Click Web Element Is Visible            ${buttonNDA}
    Click Web Element Is Visible            ${buttonExibirTudo} 
    ${numeroContrato}=                      Get Text Element is Visible             ${valorNumeroContrato}
    Escrever Variavel na Planilha           ${numeroContrato}                       numeroContrato                          Global
    Click Web Element Is Visible            ${valorNumeroContrato}
    Sleep                                   10s

    #Tela após gerar o contrato
    Get Text Element is Visible Valida      ${caixaEntrada}                         ==                                      Caixa de Entrada
    Click Web Element Is Visible            ${buttonRelacionar}     
    Click Web Element Is Visible            ${buttonCarregarArquivos}
    Pause Execution                         Selecione o arquivo a ser adicionado e clique no "OK"
    Click Web Element Is Visible            ${buttonConcluido}
    Get Text Element is Visible Valida      ${validaUploadArquivo}                  ==                                      (1)
    
    #tela da janela "Detalhes"
    Click Web Element Is Visible            ${buttonDetalhes}    
    Click Web Element Is Visible            ${editarDocumentacaoOK}
    Click Web Element Is Visible            ${optionsDocumentacaoOK}
    Click Web Element Is Visible            ${documentacaoOkSim}    
    Click Web Element Is Visible            ${optionsAprovacaoExecutiva}
    Click Web Element Is Visible            ${aprovacaoExecutivaSim}   
    Click Web Element Is Visible            ${optionsAnaliseCredito}     
    Click Web Element Is Visible            ${analiseCreditoSim}    
    Click Web Element Is Visible            ${optionsAnaliseCompliance}
    Click Web Element Is Visible            ${analiseComplianceSim}
    Click Web Element Is Visible            ${optionsChanceleJuridico}
    Click Web Element Is Visible            ${chanceleJuridicoSim}

    #campo preenchimento informações adicionais da aba "Detalhes"
    ${nomeRepresentante}                    Ler Variavel na Planilha                nomeRepresentante                       Global
    ${emailRepresentante}                   Ler Variavel na Planilha                emailRepresentante                      Global
    ${primeiroNome}                         Ler Variavel na Planilha                nome                                    Global
    ${emailContrato}                        Ler Variavel na Planilha                emailContato                            Global
    Scroll To Element                       ${inputNomeRepresentante}
    Input Text Web Element Is Visible       ${inputNomeRepresentante}               ${nomeRepresentante}
    Input Text Web Element Is Visible       ${inputEmailRepresentante}              ${emailRepresentante}
    Input Text Web Element Is Visible       ${inputNomeTestemunha}                  ${primeiroNome} 
    Input Text Web Element Is Visible       ${inputEmailTestemunha}                 ${emailContrato}
    Click Web Element Is Visible            ${buttonSalvarContato}      

#===================================================================================================================================================================
Alterar status para NDA Anexado
    [Documentation]                         Após realizar o processo de gerar Contrato Principal ele altera o status da CP na tela de "contratos"
    ...                                     Entra na tela "oportunidade" preenche e valida NDA Anexado

    #Processo retorna para a tela da oportunidade e seleciona a aba NDA.
    Janela de oportunidade

    Click Web Element Is Visible            ${buttonNDA}
    Click Web Element Is Visible            ${buttonContats}     
    Click Web Element Is Visible            ${buttonEditar}    
    Click Web Element Is Visible            ${campoAlteracaoStatus}   
    Click Web Element Is Visible            ${ndaAnexado}  
    Click Web Element Is Visible            ${buttonSalvarContato}  
    Sleep                                   10s
    Click Web Element Is Visible            ${buttonExibirContracts}
    Click Web Element Is Visible            ${valorNumeroContrato}
    Get Text Element is Visible Valida      ${campoStatus}                          ==                                      NDA Anexado

#===========================================================================================================================
Alterar status da CP para DocSign
    [Documentation]                         Na aba "Contratos" vai alterar o status até o DocSign

    #Após preenchimento, muda o status até o status "Análise de Risco Aprovada" 
    Get Text Element is Visible Valida      ${caixaEntrada}                         ==                                      Caixa de Entrada
    Click Web Element Is Visible            ${buttonEditarStatus}
    Click Web Element Is Visible            ${campoAlteracaoStatus} 
    Click Web Element Is Visible            ${analiseDeRisco}    
    Click Web Element Is Visible            ${buttonSalvarContato}
    Sleep                                   5s
    Click Web Element Is Visible            ${buttonEditarStatus}
    Click Web Element Is Visible            ${campoAlteracaoStatus} 
    Click Web Element Is Visible            ${analiseDeRiscoAprovada} 
    Click Web Element Is Visible            ${buttonSalvarContato}
    Sleep                                   5s
    Click Web Element Is Visible            ${buttonEditarStatus}
    Click Web Element Is Visible            ${campoAlteracaoStatus} 
    Click Web Element Is Visible            ${assinaturaDocSign}
    Click Web Element Is Visible            ${buttonSalvarContato}      
#===========================================================================================================================
Alterar fase para envio de proposta
    [Documentation]                         Loga no Salesforce, pesquisa a CP na e altera as fases de "Reunião de apresentação" para "Envio de proposta"
    ...                                     Tela de oportunidade 
    
    #Processo retorna para a tela da oportunidade
    Janela de oportunidade

    Get Text Element is Visible Valida      ${validaApresentacao}                   ==                                      Reunião de Apresentação
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase}  
    Click Web Element Is Visible            ${faseAnaliseCredito}
    Click Web Element Is Visible            ${buttonSalvarContato}
    Sleep                                   5s    
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase} 
    Click Web Element Is Visible            ${faseEnvioProposta}
    Click Web Element Is Visible            ${buttonSalvarContato}
#===========================================================================================================================
Janela de oportunidade
    [Documentation]                         Após login no Salesforce, ele clica na oportunidade de acordo com o custumerName
    ...                                     Tela de oportunidade 

    ${customerName}                         Ler Variavel na Planilha                customerName                            Global
    Click Web Element Is Visible            ${buttonOportunidade}
    Click Web Element Is Visible            xpath=//span[@class="slds-truncate"]//*[text()="${customerName}"]  
#===========================================================================================================================
Alterar fase para negociacao
    [Documentation]                         Altera a fase de "Envio de proposta" para "Negociação"
    ...                                     Tela de oportunidade 

    Get Text Element is Visible Valida      ${validaEnvioProposta}                  ==                                      Envio da Proposta
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase}  
    Click Web Element Is Visible            ${negociacao}
    Click Web Element Is Visible            ${buttonSalvarContato}
    Sleep                                   5s    
    Get Text Element is Visible Valida      ${validaNegociacao}                     ==                                      Negociação
#===========================================================================================================================
Adicionar/remover municípios    
    [Documentation]                         Adiciona ou remove o munincipio
    ...                                     Tela de oportunidade 
    
    ${UF}                                   Ler Variavel na Planilha                UF                                      Global
    ${munincipio}                           Ler Variavel na Planilha                munincipio                              Global

    Click Web Element Is Visible            ${buttonAdRemMunincipios}     
    Sleep                                   15s
    Click Web Element Is Visible            ${buttonUFS}    
    Click Web Element Is Visible            xpath=//*[@class="slds-media slds-listbox__option slds-media_center slds-media_small slds-listbox__option_plain"]/..//*[@data-value="${UF}"]      
    Click Web Element Is Visible            xpath=//span[text()="Nome do Município"]/../../../../../../..//*[text()="${munincipio}"]/../../../../../..//*[@class="slds-checkbox_faux"]
    Click Web Element Is Visible            ${buttonAvancar}
    Click Web Element Is Visible            ${buttonConcluir}
    Scroll To Element                       ${validaMunincipio1}
    Get Text Element is Visible Valida      ${validaMunincipio1}                    ==                                      (1)
#===========================================================================================================================
Configurar Oportunidade
    [Documentation]                         Configura oportunidade
    ...                                     Tela de oportunidade 
    Janela de oportunidade
    Click Web Element Is Visible            ${buttonConfigOportunidade} 
    Sleep                                   10s   
    Click Web Element Is Visible            ${buttonListaPreco}
    Click Web Element Is Visible            ${listaPadrao}        
    Click Web Element Is Visible            ${buttonLoadMore}
    Click Web Element Is Visible            ${buttonLoadMore}
    Click Web Element Is Visible            ${buttonAdicionar} 
    Sleep                                   5s 
    Scroll To Element                       ${buttonSetupFeeFttp}
    Click Web Element Is Visible            ${buttonSetupFeeFttp}
    Click Web Element Is Visible            ${buttonConfigure} 
    Click Web Element Is Visible            ${buttonSelect}  
    Pause execution                         Clique na quantidade de parcelas "3" e depois no OK                      
    Sleep                                   5s
    Click Web Element Is Visible            ${buttonClose}
#===========================================================================================================================
Realizar a Alteração dos Valores
    [Documentation]                         Altera a fase de "Negociação" para "Fechamento ganho"
    ...                                     Tela de oportunidade

    Click Web Element Is Visible            ${buttonValor200FTTP}
    Click Web Element Is Visible            ${buttonEditarValor}
    Sleep                                   3s
    Click Web Element Is Visible            ${buttonPorcentage}    
    Click Web Element Is Visible            ${buttonAmount}  
    Click Web Element Is Visible            ${inputValor}    
    Input Text Web Element Is Visible       ${inputValor}                           26
    Click Web Element Is Visible            ${buttonApply}    
    Sleep                                   10s
#===========================================================================================================================
Alterar fase para fechamento ganho
    [Documentation]                         Altera a fase de "Negociação" para "Fechamento ganho"
    ...                                     Tela de oportunidade

    Janela de oportunidade
    Get Text Element is Visible Valida      ${validaNegociacao}                     ==                                      Negociação
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase}  
    Click Web Element Is Visible            ${analiseCompliance}
    Click Web Element Is Visible            ${buttonSalvarContato}
    Sleep                                   3s    
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase}  
    Click Web Element Is Visible            ${fechamento}
    Click Web Element Is Visible            ${buttonSalvarContato}
    Sleep                                   3s    
    Click Web Element Is Visible            ${buttonFase}  
    Click Web Element Is Visible            ${campoButtonFase}  
    Click Web Element Is Visible            ${fechamentoGanho}
    Click Web Element Is Visible            ${buttonSalvarContato}
    Get Text Element is Visible Valida      ${validaFechamentoGanho}                ==                                      Fechado Ganho
#===========================================================================================================================
Acesso ao portal pelo Salesforce
    [Documentation]                         Processo feito para criar o portal do cliente
    ...                                     Tela inicial 
    
    Abrir site e Logar no SALESFORCE

    ${customerName}                         Ler Variavel na Planilha                customerName                            Global
    ${nomeCompleto}                         Ler Variavel na Planilha                nomeCompleto                            Global

    Click Web Element Is Visible            ${abasOportunidades}
    Click Web Element Is Visible            xpath=//a[@data-aura-class="forceOutputLookup"]/..//a[@title="${customerName}"] 
    Click Web Element Is Visible            ${buttonContatos}    
    Click Web Element Is Visible            xpath=//a[@class="flex-wrap-ie11 slds-truncate"]/..//span[text()="${nomeCompleto}"]
    Click Web Element Is Visible            ${buttonAcessoPortal}    
    Click Web Element Is Visible            ${buttonCriarPortal} 
    Click Web Element Is Visible            ${btnAvancarNovoCliente}   
    Sleep                                   15s 
    Click Web Element Is Visible            ${buttonConcluir}     
    Close Browser                           CURRENT
#===========================================================================================================================
