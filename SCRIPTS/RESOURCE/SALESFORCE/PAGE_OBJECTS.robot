*** Settings ***
Documentation                               Arquivo de objetos/xpath do FSL

*** Variables ***
${WORKORDERID}

#Tela inicial de Login no sistema
${input_login_SALESFORCE}                   //input[contains(@id,'username')]
${input_password_SALESFORCE}                //input[contains(@id,'password')]
${btn_login_SALESFORCE}                     //input[contains(@id,'Login')]
${btn_perfil_SALESFORCE}                    //span[text()="Exibir perfil"]/../..
${span_logout_FSL_SALESFORCE}               //div[@class="profile-card-toplinks"]//a[text()="Fazer logout"]
${btnPesquisarSalesforce}                   //button[@type='button'][contains(.,'Pesquisar...')]
${inputPesquisar}                           //input[@placeholder='Pesquisar...']
${inputPesquisarTudo}                       //*[@data-value="Pesquisa: Tudo"]


# Home
${btnIniciadorDeAplicativos}                //div[contains(@class,'appLauncher')]
${btnVisualizarTudoSalesforce}              //button[@class='slds-button'][contains(.,'Visualizar tudo')]
${btnAlicativoBSS}                          //div[@class='slds-app-launcher__tile-body slds-truncate'][contains(.,'BSS Vtal')]
${barraDeContexto}                          //div[@class='slds-context-bar']
${setaCliente}                              //a[normalize-space()='Clientes']/..//a[@class='slds-button slds-button_reset']
${btnNovoCliente}                           //a[normalize-space()='Novo cliente']/span
${setaOportunidades}                        //a[normalize-space()='Oportunidades']/..//a[@class='slds-button slds-button_reset']
${btnNovaOportunidade}                      //a[normalize-space()='Nova oportunidade']/span
${btnSalvar}                                //button[@name='SaveEdit']

# Aba +Novo Cliente
${btnAvancarNovoCliente}                    //button[normalize-space()='Avançar']
${btnOrganizacao}                           //span[text()="Organização"]/../..//span[@class="slds-radio--faux"]
${btnContasComerciais}                      //span[text()="Contas Comerciais"]/../..//span[@class="slds-radio--faux"]
${btnSalvarNovoCliente}                     //button[normalize-space()='Salvar']

# Aba Clientes
${nomeCliente}                              //div[normalize-space()='Cliente']/..//lightning-formatted-text
${nomeDaContaCliente}                       //span[normalize-space()='Nome da conta']/../../div[@class='slds-form-element__control']/span
${codOrganizacao}                           //span[normalize-space()='Código da Organização']/../../div[@class='slds-form-element__control']/span

# Aba Informações Novo Cliente Organização
${inputNomeDaOrganizacao}                   //label[normalize-space()='*Nome da conta']/..//input

#Informações sobre a conta
${inputNomeConta}                           //label[text()="Nome da conta"]/..//input[@class="slds-input"]
${optionsClienteInternacional}              //label[text()="Cliente Internacional"]/../../../../..//button[@class="slds-combobox__input slds-input_faux slds-combobox__input-value"]
${valorNãoClienteInternacional}             //*[@class="slds-media slds-listbox__option slds-media_center slds-media_small slds-listbox__option_plain"]//*[text()="Não"]
${inputEmail}                               //*[text()="Informações sobre a conta"]/../..//*[text()="Email"]/..//input
${inputTelefone}                            //*[text()="Informações sobre a conta"]/../..//*[text()="Telefone"]/..//input
${inputCelular}                             //*[text()="Informações sobre a conta"]/../..//*[text()="Celular"]/..//input
${optionsWhatsapp}                          //*[text()="Informações sobre a conta"]/../..//*[text()="Whatsapp"]/..//button
${valorNãoWhatsapp}                         //*[text()="Whatsapp"]/..//*[text()="Não"]
${optionsUFRaiz}                            //*[text()="UF Raiz"]/..//div[@class="slds-form-element__control"]
${optionsContaPai}                          //*[text()="Informações sobre a conta"]/../..//*[text()="Conta pai"]/..//input
${inputEmailFatura}                         //*[text()="Informações sobre a conta"]/../..//*[text()="E-mail para envio de Fatura"]/..//input
${inputEmailConfirmacaoFatura}              //*[text()="Informações sobre a conta"]/../..//*[text()="Confirmação E-mail de Fatura"]/..//input

#Detalhes Adicionais da Empresa
${inputNomeFantasia}                        //label[text()="Nome Fantasia"]/..//input
${optionsSituacaoCadastral}                 //label[text()="Situação Cadastral"]/..//div[@class="slds-form-element__control"]
${situacaoCadastralAtiva}                   //label[text()="Situação Cadastral"]/..//*[text()="Ativo"]
${inputCNPJ}                                //label[text()="CNPJ"]/..//input
${optionsStatusCliente}                     //*[text()="Status do Cliente"]/..//div[@class="slds-form-element__control"]
${statusClienteNovo}                        (//*[text()="Status do Cliente"]/..//*[text()="Novo"])[last()]
${optionsEmpresa}                           //label[text()="Empresas"]/..//div[@class="slds-form-element__control"]
${empresaEAassociados}                      //label[text()="Empresas"]/..//*[text()="EA (Empresas associadas)"]
${optionsAtuaInternacional}                 //label[text()="Atua Internacionalmente"]/..//div[@class="slds-form-element__control"]
${atuaInternacionalNão}                     //label[text()="Atua Internacionalmente"]/..//*[text()="Não"]
${inputNomeCDC}                             //label[text()="Nome CDC"]/..//textarea
${optionsCFOP}                              //label[text()="CFOP"]/..//input
${optionsCodigoCNAE}                        //label[text()="Código CNAE"]/..//div[@class="slds-form-element__control"]
${inputInscricaoEstadual}                   //label[text()="Inscrição Estadual"]/..//input
${optionsInsençãoICMS}                      //label[text()="Isenção de ICMS"]/..//div[@class="slds-form-element__control"]
${insençãoICMSNão}                          //label[text()="Isenção de ICMS"]/..//*[text()="Não"]
${optionsDeferimentoICMS}                   //*[text()="Diferimento ICMS"]/..//div[@class="slds-form-element__control"]
${deferimentoICMSNão}                       //*[text()="Diferimento ICMS"]/..//*[text()="Não"]
${optionsInsentoISS}                        //label[text()="Isento ISS"]/..//*[@class="slds-combobox__form-element slds-input-has-icon slds-input-has-icon_right"]
${insentoISSNão}                            //label[text()="Isento ISS"]/..//*[text()="Não"]
${optionsAtendimento}                       //label[text()="Atendimento"]/..//div[@class="slds-form-element__control"]
${atendimentoGerVendas}                     //label[text()="Atendimento"]/..//*[text()="Ger.Vendas"]
${optionsOrganizacaoVendas}                 //label[text()="Organização de Vendas"]/..//div[@class="slds-form-element__control"]
${organizacaoVendasSudeste}                 //label[text()="Organização de Vendas"]/..//*[text()="Sudeste"]

#Endereço Principal
${optionsUF}                                //label[text()="UF"]/..//div[@class="slds-form-element__control"]
${optionsLogradouroPrincipal}               //label[text()="Tipo de Logradouro Principal"]/..//div[@class="slds-form-element__control"]
${inputLogradouroPrincipal}                 //*[text()="Logradouro Principal"]/..//textarea
${optionsRegiao}                            //*[text()="Endereço Principal"]/../..//label[text()="Região"]/..//button
${regiaoSudeste}                            //*[text()="Endereço Principal"]/../..//label[text()="Região"]/..//*[text()="Sudeste"]
${inputNumero}                              //span[text()="Endereço Principal"]/../..//label[text()="Número"]/..//input
${inputBairro}                              //span[text()="Endereço Principal"]/../..//*[text()="Bairro"]/..//textarea
${inputCep}                                 //span[text()="Endereço Principal"]/../..//*[text()="CEP"]/..//input
${inputMunincipio}                          //span[text()="Endereço Principal"]/../..//*[text()="Município"]/..//input

#Endereço de Faturamento
${optionsEnderecoFaturamento}               //label[text()="End. Faturamento é igual ao Principal?"]/..//div[@class="slds-form-element__control"]
${enderecoFaturamentoSim}                   (//label[text()="End. Faturamento é igual ao Principal?"]/..//div[@class="slds-form-element__control"]/..//*[text()="Sim"])[last()]
${inputNumeroFaturamento}                   //span[text()="Endereço de Faturamento"]/../..//label[text()="Número"]/..//input
${inputBairroFaturamento}                   //span[text()="Endereço de Faturamento"]/../..//label[text()="Bairro"]/..//textarea
${inputIdEnderecoFaturamento}               //span[text()="Endereço de Faturamento"]/../..//label[text()="Id Endereço"]/..//input
${inputIdCodigoAnatel}                      //span[text()="Endereço de Faturamento"]/../..//label[text()="Código da Cidade Anatel"]/..//input
${inputMunincipioFaturamento}               //*[text()="Endereço de Faturamento"]/../..//*[text()="Município"]/..//input

${optionsUffaturamento}                     //label[text()="UF de Faturamento"]/..//div[@class="slds-form-element__control"]
${tipoLogradouroFaturamento}                //label[text()="Tipo de Logradouro Faturamento"]/..//div[@class="slds-form-element__control"]
${optionsRegiaoFaturamento}                 //*[text()="Endereço de Faturamento"]/../..//label[text()="Região"]/..//button
${regiaoSudesteFaturamento}                 //*[text()="Endereço de Faturamento"]/../..//label[text()="Região"]/..//*[text()="Sudeste"]
${cepFaturamento}                           //*[text()="CEP de Faturamento"]/..//input
${logradouroFaturamento}                    //*[text()="Logradouro Faturamento"]/..//textarea
${buttonSalvarCriar}                        //button[text()="Salvar e criar"]
${buttonFechar}                             //*[@class="slds-button__icon slds-button__icon_large slds-button_icon-inverse"]/..//*[@data-key="close"]

# Aba +Nova Oportunidade
${inputNovaOportunidade}                    //label[normalize-space()='*Nome da oportunidade']/..//input
${inputNomeDaContaOportunidade}             (//label[normalize-space()='*Nome da conta']/..//input)[last()]
${tipoNegociacao}                           //label[normalize-space()='*Tipo de Negociação']/..//button[@aria-haspopup="listbox"]
${novoContrato}                             //button[@aria-haspopup="listbox"]/../..//*[text()="Novo contrato"]
${origemOutros}                             //button[@aria-haspopup="listbox"]/../..//*[text()="Outros"]
${origemLead}                               //label[normalize-space()='Origem do lead']/..//button[@aria-haspopup="listbox"]
${dataFechamento}                           //label[normalize-space()='*Data de fechamento']/..//input[@name="CloseDate"]
${probabilidadeFechamento}                  (//label[normalize-space()='Probabilidade de Fechamento']/..//button[@aria-haspopup="listbox"])[last()]
${fechamentopossivel}                       //label[normalize-space()='Probabilidade de Fechamento']/..//span[text()="Possivel"]
${campoFase}                                (//label[normalize-space()='*Fase']/..//button[@aria-haspopup="listbox"])[last()]
${tipoContrato}                             (//label[normalize-space()='Tipo do Contrato']/..//button[@aria-haspopup="listbox"])[last()]
${faseBacklog}                              //label[normalize-space()='*Fase']/..//span[text()="Backlog"]
${classeProduto}                            (//label[normalize-space()='Classe de Produto']/..//button[@aria-haspopup="listbox"])[last()]
${produtoclasseFTTP}                        //label[normalize-space()='Classe de Produto']/..//span[text()="FTTP"]
${condicaoComercial}                        (//label[normalize-space()='Condição Comercial']/..//button[@aria-haspopup="listbox"])[last()]
${outraCondicao}                            //label[normalize-space()='Condição Comercial']/..//span[text()="Outra condição"]
${condicaoPadrao}                           //label[normalize-space()='Condição Comercial']/..//span[text()="Condição padrão"]
${informacoesSigilosas}                     (//label[normalize-space()='Informações Sigilosas']/..//button[@aria-haspopup="listbox"])[last()]
${sigilosasSim}                             //label[normalize-space()='Informações Sigilosas']/..//*[text()="Sim"]
${prazoEntrega}                             (//label[normalize-space()='Prazo do contrato (meses)']/..//input)[last()]
${contratoAnchor}                           //label[normalize-space()='Tipo do Contrato']/..//span[text()="ANCHOR"]
${contratoOther}                            (//label[normalize-space()='Tipo do Contrato']/..//span[text()="OTHER"])[last()]
${opcoesNomeDaContaOportunidade}            //label[normalize-space()='*Nome da conta']/..//lightning-base-combobox-item
${btnTipoDeNegociacao}                      //label[normalize-space()='*Tipo de Negociação']/../div//button
${opcaoNovoContrato}                        //label[normalize-space()='*Tipo de Negociação']/..//lightning-base-combobox-item[@data-value='Novo contrato']
${btnOrigemDoLead}                          //label[normalize-space()='Origem do lead']/../div//button
${opcaoOutros}                              //label[normalize-space()='Origem do lead']/..//lightning-base-combobox-item[@data-value='Outros']
${btnFase}                                  //label[normalize-space()='*Fase']/../div//button
${opcaoBacklog}                             //label[normalize-space()='*Fase']/..//lightning-base-combobox-item[@data-value='Backlog']

#Agendar reunião de apresentação
${novoCompromissoReuniao}                   (//div[@class="slds-tabs_card"][contains(.,'Atividade')]//button[@value="NewEvent"][contains(.,'Novo compromisso')])[last()]
${inputAssuntoReuniao}                      //*[text()="Assunto"]/..//input
${assuntoReunaoNegociacao}                  //*[text()="Assunto"]/..//span[text()="Reunião de Negociação"]
${descricaoReuniao}                         (//*[text()="Descrição"]/../..//textarea)[last()]
${localReuniao}                             //*[text()="Local"]/../..//input
${contatoReuniao}                           //*[text()="Nome"]/../..//input[@aria-autocomplete="list"]
${NomeContato}                              //label[normalize-space()='Nome']/..//input[@aria-autocomplete="list"]


#campos após cadastro no CP (validação)
${campoNomeConta}                           //span[text()="Nome da conta"]/../..//span[@class="test-id__field-value slds-form-element__static slds-grow word-break-ie11"]
${buttonVendas}                             //a[text()="Vendas"]
${buttonServicos}                           //a[text()="Serviços"]
${buttonContratos}                          //a[text()="Contratos"]

#Campo criar contato 
${buttonRelacionado}                        //a[@data-label="Relacionado"]
${buttonCriarContato}                       //button[text()="Criar Contato"]
${optionsTratamento}                        //*[text()="Tratamento"]/../..//*[@class="select"]
${optionsTratamentoSra}                     (//*[text()="Sra."])[last()]
${inputPrimeiroNome}                        //*[text()="Primeiro Nome"]/../..//input
${inputSobrenome}                           //*[text()="Sobrenome"]/../..//input
${inputEmailContato}                        //*[text()="Email"]/../../..//input
${inputTelefoneContato}                     //*[text()="Telefone"]/../../..//input
${inputCelularContato}                      //*[text()="Celular"]/../../..//input
${optionsPerfil}                            //*[text()="Perfil"]/../..//*[@class="select"]
${optionsBSSVtal}                           (//*[text()="BSS Vtal Gestao CP"])[last()]
${optionsCargo}                             //*[text()="Cargo"]/../..//*[@class="select"]
${optionsGerenteCoorde}                     (//*[text()="Gerente/Coordenador"])[last()]
${optionsWhapContato}                       //*[text()="Whatsapp"]/../..//*[@class="select"]
${optionsWhapNãoContato}                    (//*[text()="NÃO"])[last()]
${buttonSalvarContato}                      (//button[normalize-space()='Salvar'])[last()]

#Campos oportunindade
${buttonOportunidade}                       //*[text()="Oportunidades"]/../..//div[@class="slds-context-bar__label-action slds-p-left--none"]
${buttonGerarNDA}                           //button[text()="Criar NDA"]
${optionsStatus}                            //span[text()="Status"]/../..//*[@role="button"]
${caixaEntradaStatus}                       //*[text()="Caixa de Entrada"]
${buttonNDA}                                //a[text()="NDA"]
${buttonExibirTudo}                         (//span[text()="Exibir tudo"])[last()]
${buttonExibirContracts}                    (//*[text()="Contracts"]/../..//span[text()="Exibir tudo"])[last()]
${buttonNumeroContrato}                     //th[@data-label="Número do contrato"]//span[@class="slds-grid slds-grid_align-spread"]
${caixaEntrada}                             //span[text()="Caixa de Entrada"]
${buttonRelacionar}                         (//li[@title="Relacionado"])[last()]
${buttonCarregarArquivos}                   //span[@class="slds-file-selector__button slds-button slds-button_neutral"][text()="Carregar arquivos"]
${buttonConcluido}                          //span[@class=" label bBody"][text()="Concluído"]
${validaUploadArquivo}                      //span[@class="slds-shrink-none slds-m-right--xx-small"]/..//span[@title="(1)"]
${buttonDetalhes}                           (//li[@title="Detalhes"])[last()]
${editarDocumentacaoOK}                     //*[text()="Documentação OK"]/../..//span[@class="inline-edit-trigger-icon slds-button__icon slds-button__icon_hint"]
${optionsDocumentacaoOK}                    //*[text()="Documentação OK"]/./..//button[@class="slds-combobox__input slds-input_faux slds-combobox__input-value"]
${documentacaoOkSim}                        //*[text()="Documentação OK"]/./..//span[text()="Sim"]
${optionsAprovacaoExecutiva}                //*[text()="Aprovação Executiva?"]/..//*[@aria-haspopup="listbox"]
${aprovacaoExecutivaSim}                    //*[text()="Aprovação Executiva?"]/..//span[text()="Sim"]
${optionsAnaliseCredito}                    //*[text()="Análise de Crédito Ok?"]/..//*[@aria-haspopup="listbox"]
${analiseCreditoSim}                        //*[text()="Análise de Crédito Ok?"]/..//*[@data-value="Sim"]
${optionsAnaliseCompliance}                 //*[text()="Análise de Compliance Ok?"]/..//*[@aria-haspopup="listbox"]
${analiseComplianceSim}                     //*[text()="Análise de Compliance Ok?"]/..//*[@data-value="Sim"]
${optionsChanceleJuridico}                  //*[text()="Chancela Jurídico?"]/..//*[@aria-haspopup="listbox"]
${chanceleJuridicoSim}                      //label[text()="Chancela Jurídico?"]/..//*[@data-value="Sim"]
${inputNomeRepresentante}                   //label[text()="Nome do Representante"]/..//input
${inputEmailRepresentante}                  //label[text()="E-mail do Representante"]/..//input
${inputNomeTestemunha}                      //label[text()="Nome da Testemunha"]/..//input
${inputEmailTestemunha}                     //label[text()="E-mail da Testemunha"]/..//input
${marcarStatusCompleto}                     //span[text()="Marcar Status como concluído(a)"]
${campoStatus}                              //p[text()="Status"]/..//*[@class="fieldComponent slds-text-body--regular slds-show_inline-block slds-truncate"]
${statusAnaliseAprovada}                    //p[text()="Status"]/..//*[text()="Análise de Risco Aprovada"]
${buttonEditarStatus}                       //*[text()="Status"]/../..//button[@class="test-id__inline-edit-trigger slds-shrink-none inline-edit-trigger slds-button slds-button_icon-bare"]
${campoAlteracaoStatus}                     //*[text()="Status"]/..//button[@class="slds-combobox__input slds-input_faux slds-combobox__input-value"]
${assinaturaDocSign}                        (//*[text()="Status"]/..//span[text()="Assinatura DocuSign"])[last()]
${analiseDeRisco}                           (//*[text()="Status"]/..//span[text()="Análise de Risco"])[last()]
${analiseDeRiscoAprovada}                   (//*[text()="Status"]/..//span[text()="Análise de Risco Aprovada"])[last()]
${buttonContats}                            //div[@class="slds-card__body slds-wrap slds-grid"]//button[@class="slds-button slds-button_icon-border slds-button_icon-x-small"]
${buttonEditar}                             //div[@data-aura-class="uiPopupTarget uiMenuList forceActionsDropDownMenuList uiMenuList--left uiMenuList--default"]
${ndaAnexado}                               (//*[text()="Status"]/..//span[text()="NDA Anexado"])[last()]
${valorNumeroContrato}                      (//span[text()="Número do contrato"]/../../../../.././../..//a[@class="flex-wrap-ie11 slds-truncate"])[last()]
${buttonFase}                               //*[text()="Fase"]/../..//button[@class="test-id__inline-edit-trigger slds-shrink-none inline-edit-trigger slds-button slds-button_icon-bare"]
${statusFase}                               (//p[text()="Fase"]/..//*[@class="fieldComponent slds-text-body--regular slds-show_inline-block slds-truncate"])[last()]
${campoButtonFase}                          //*[text()="Fase"]/..//button[@class="slds-combobox__input slds-input_faux slds-combobox__input-value"]
${faseAnaliseCredito}                       (//*[text()="Fase"]/..//span[text()="Análise de Crédito"])[last()]
${faseEnvioProposta}                        (//*[text()="Fase"]/..//span[text()="Envio da Proposta"])[last()]
${abordagemInicial}                         (//*[text()="Fase"]/..//span[text()="Abordagem Inicial"])[last()]
${negociacao}                               (//*[text()="Fase"]/..//span[text()="Negociação"])[last()]
${analiseCompliance}                        (//*[text()="Fase"]/..//span[text()="Análise de Compliance"])[last()]
${fechamento}                               (//*[text()="Fase"]/..//span[text()="Fechamento"])[last()]
${fechamentoGanho}                          (//*[text()="Fase"]/..//span[text()="Fechado Ganho"])[last()]
${reuniaoApresentacao}                      (//*[text()="Fase"]/..//span[text()="Reunião de Apresentação"])[last()]
${validaEnvioProposta}                      (//span[text()="Fase"]/../..//*[text()="Envio da Proposta"])[last()] 
${validaNegociacao}                         //span[text()="Fase"]/../..//*[text()="Negociação"]
${validaApresentacao}                       //span[text()="Fase"]/../..//*[text()="Reunião de Apresentação"]
${validaBacklog}                            (//span[text()="Fase"]/../..//*[text()="Backlog"])[last()] 
${validaFechamentoGanho}                    (//span[text()="Fase"]/../..//*[text()="Fechado Ganho"])[last()] 

#Adicionar/Remover Munincipos
${buttonAdRemMunincipios}                   (//button[@class="slds-button slds-button_neutral"][contains(.,'Adicionar/Remover Municipios')])[last()]
${buttonUFS}                                (//button[@class="slds-combobox__input slds-input_faux"])[last()] 
${buttonAvancar}                            (//button[normalize-space()='Avançar'])[last()] 
${buttonConcluir}                           (//button[normalize-space()='Concluir'])[last()]
${validaMunincipio1}                        //span[text()="Municípios Por Oportunidade"]/..//*[text()="(1)"]

#Configurar Oportunidade
${buttonConfigOportunidade}                 (//button[text()="Configurar Oportunidade"])[last()]
${buttonListaPreco}                         //iframe[@title="accessibility title"] >>>   (//div[text()="Lista de Preço"]/..//button[@class="slds-button custom-view-dropdown-button slds-button_neutral slds-p-right_small slds-picklist__label cpq-base-header-picklist-label"])[last()]
${listaPadrao}                              //iframe[@title="accessibility title"] >>>   (//div[text()="Lista de Preço"]/..//div[@class="cpq-base-header-dropdown slds-dropdown slds-dropdown_left"])[last()]
${buttonLoadMore}                           //iframe[@title="accessibility title"] >>>   (//div[@class="slds-spinner_brand slds-spinner slds-spinner_small"]/../..//a[@ng-click="importedScope.nextPageProducts()"])[last()]
${buttonAdicionar}                          //iframe[@title="accessibility title"] >>>   (//button[@class="slds-button slds-button_neutral cpq-add-button"][contains(.,'Adicionar')])[last()]
${buttonValor200FTTP}                       //iframe[@title="accessibility title"] >>>    //html/body/div[1]/div[1]/ng-include/div/div[2]/div[2]/div[2]/div[1]/div/ng-include/div/div[3]/div[2]/div[2]/div[1]/ng-include/div/div/div/div[4]/div[2]/div/ng-include/div/div[2]/ng-include/div/div[1]/div/div[2]/div[4]
${buttonEditarValor}                        //iframe[@title="accessibility title"] >>>    //html/body/div[1]/div[1]/ng-include/div/div[2]/div[2]/div[2]/div[1]/div/ng-include/div/div[3]/div[2]/div[2]/div[1]/ng-include/div/div/div/div[4]/div[2]/div/ng-include/div/div[2]/ng-include/div/div[1]/div/div[2]/div[4]/div/div/div[2]/div/div/button[1]
${buttonSetupFeeFttp}                       //iframe[@title="accessibility title"] >>>   (//span[text()="SETUP FEE FTTP"]/../../..//button[@title="Show Actions"])[last()]
${buttonConfigure}                          //iframe[@title="accessibility title"] >>>   (//span[text()="SETUP FEE FTTP"]/../../..//button[@title="Show Actions"]/..//a[@role="menuitemcheckbox"][contains(.,'Configure')])[last()]
${buttonSelect}                             //iframe[@title="accessibility title"] >>>   (//div[contains(.,'Parcelas')]/..//select[@name='productconfig_field_0_0'])[last()]
${buttonClose}                              //iframe[@title="accessibility title"] >>>   (//button[@ng-click="importedScope.close()"])[last()]
${buttonPorcentage}                         //iframe[@title="accessibility title"] >>>   (//*[@class="slds-picklist slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open cpq-pricing-picklist"]/..//button[@class="slds-button slds-button_neutral slds-picklist__label cpq-pricing-picklist__label slds-p-right_small"])[last()]
${buttonAmount}                             //iframe[@title="accessibility title"] >>>   (//div[@class="slds-dropdown slds-dropdown_left cpq-pricing-picklist-dropdown"]//li[@role="presentation"][contains(.,'Amount')])[last()]
${buttonApply}                              //iframe[@title="accessibility title"] >>>   (//button[@class='slds-button slds-button--brand'][contains(.,'Apply')])[last()]
${inputValor}                               //iframe[@title="accessibility title"] >>>   (//input[@ng-model="records.adjustment.value"]/..//input[@type="number"])[last()]

${abasOportunidades}                        //a[@class="slds-context-bar__label-action dndItem"]/..//*[@title="Oportunidades"]
${buttonContatos}                           //a[text()="Contatos"]
${buttonAcessoPortal}                       //button[text()="Acesso Portal"]
${buttonCriarPortal}                        //span[text()="Criar"]/../../.. //span[@class="slds-radio_faux"]
${buttonMembroComunidade}                   //span[text()="Membro da Comunidade"]/..//*[@part="indicator"]

#Campos YouMail
${inputEmailYouMail}                        //input[@class="ycptinput"]/..//input[@id="login"]
${buttonLogarYouMail}                       //input[@class="ycptinput"]/../../..//i[@class="material-icons-outlined f36"]
${emailVtalYouMail}                         //iframe[@id="ifinbox"] >>>  //span[@class="lmf"][contains(.,'V.tal Atendimento Cliente')]
${linkYouMail}                              //iframe[@id="ifmail"]  >>>  //a[contains(.,'Link')]
${inputNovaSenha}                           //form[@action="/bss/resetsenha/form?cid=1"]/..//input[@placeholder="Nova senha"]
${inputConfirmarNovaSenha}                  //form[@action="/bss/resetsenha/form?cid=1"]/..//input[@placeholder="Confirmar nova senha"]
${buttonEnviar}                             //form[@action="/bss/resetsenha/form?cid=1"]/..//button[@id="submit"]
${validaSenhaCriadaSucesso}                 //div[@class="customTitleContainer"][contains(.,'Senha criada com sucesso!')]