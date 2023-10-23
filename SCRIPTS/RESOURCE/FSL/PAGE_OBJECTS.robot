*** Settings ***
Documentation                               Arquivo de objetos/xpath do FSL

*** Variables ***
${WORKORDERID}

#Tela inicial de Login no sistema
${input_login}                              //input[contains(@id,'username')]
${input_password}                           //input[contains(@id,'password')]
${btn_login}                                //input[contains(@id,'Login')]
${btn_perfil}                               //span[text()="Exibir perfil"]/../..
${span_logout_FSL}                          //a[text()="Fazer logout"]

#Tela da validação dos dois fatores.
${input_validacao}                          //input[contains(@id,'smc')]
${vendas_text}                              //span[contains(@title,'Vendas')]
${btn_verificar}                            //input[@id='save']
${span_vendas}                              //div[@aria-label="Aplicativo"]/..//span//span

#Tela de pesquisa das SA e informações
${btn_pesquisar}                            //button[@type='button'][contains(.,'Pesquisar...')]
${input_pesquisar}                          (//input[@placeholder="Pesquisar..."])
${input_pesquisa_tudo}                      //input[@data-value="Pesquisa: Tudo"]
${input_pesquisa_compromisso}               //input[@data-value="Pesquisa: Compromissos de serviços"]
${input_SA}                                 //input[@placeholder="Pesquisar..."]
${btn_compromisso_servico}                  //ul[@aria-label="Sugerido para você"]//span[@title="Compromissos de serviços"]/../../..
${input_type_pesquisa}                      //input[contains(@data-value,'Tudo')]
${input_pesquisa_compromisso}               //*[contains(@title,'Todos os itens pesquisáveis')]/../../..//span[contains(@title,'Compromissos de serviços')]
${input_pesquisar_consulta}                 //*[@type="search"and @placeholder="Pesquisar..."]

#Tela de selecionar qual tipo de sistema quer acessar
${btn_iniciador}                            //span[contains(text(),'Iniciador de aplicativos')]/..
${quantia_linhas_facilidade}                //span[@title='Facilidades'][contains(.,'Facilidades')]/../../../../../../..//div[3]//tbody//tr
${btn_visualizar_tudo}                      //button[@class='slds-button'][contains(.,'Visualizar tudo')]
${input_apps}                               //p[contains(text(),'Vendas')]
${btn_field_service}                        //a[@data-label="Field Service"]//p[@class='slds-truncate'][normalize-space()='Field Service']
${btn_compromisso_servico}                  //lightning-accordion-section[2]//section[1]//div[1]//h3[1]//button[1]/../../..//p[@class='slds-truncate'][normalize-space()='Compromissos de serviços']
${btn_mostrar_todos_sa}                     //button[@role='button'][contains(.,'Selecionar um modo de exibição de lista')]
${btn_clicar_todos_sa}                      //span[@class=' virtualAutocompleteOptionText'][contains(.,'Todos os Compromissos de serviços')]
${btn_inserir_sa}                           //input[contains(@aria-label,'Pesquisar modo de exibição de lista Recente(s).')]
${btn_pesquisar_sa}                         //button[@class='slds-button slds-button_icon slds-button_icon-border-filled'][contains(.,'Atualizar')]

#Item que seleciona o número do Work ID
${WORK_ID_ITEM}                             //mark[@class='data-match'][contains(.,'${WORKORDERID}')]

#Item que pega qual o estado do pedido, exemplo: Atribuido
${estado_item}                              //span[contains(@title,'Estado')]/..//div//div//span
${conta_fsl}                                //span[contains(@title,'Conta')]/..//div//div//div//a
${tipo_trabalho}                            //span[contains(@title,'Tipo de trabalho')]/..//div//div//div//a
${status_cancelado}                         //*[text()="Em deslocamento"]/../../..//*[text()="Cancelado"]
${menu_vendas}                              //span[contains(@title,'Vendas')]
${FSL_INICIO_AGENDAMENTO}                   //span[@class='test-id__field-label'][contains(.,'Início Agendamento')]/../..//div//span//span
${FSL_FINAL_AGENDAMENTO}                    //span[@class='test-id__field-label'][contains(.,'Fim Agendamento')]/../..//div//span//span
${btn_editSA}                               //*[text()="Editar"]/../..//div[@title="Editar"]
${optionAux_editSA}                         //*[text()="Teve Auxílio?"]/../../../..//select

${valorContaFSL}                            (//span[contains(@title,'Conta')]/../div//div)[1]
${origemFSL}                                (//span[text()="Origem"]/../..//div[2]//span)[1]


#Botões da tela que selecionam os menus de um pedido
${btn_relacionado}                          //span[@class='title'][contains(.,'Relacionado')]
${btn_acao}                                 //span[@class='title'][contains(.,'Ações')]
${btn_detalhes}                             (//span[@class='title'][contains(.,'Detalhes')])

#Text com o valor da SA
${value_SA}                                 //span[contains(text(),'Número SA')]/../..//div[2]//span//span

${btn_alterar_status}                       //div[@title='Marcar Status como Completo'][contains(.,'Marcar Status como Completo')]

#CheckBox que mostra se a SA está disponivel para ser executada, mudar de estado
${check_pronto_execucao}                    //span[contains(text(),'Pronto Execução')]/../..//div[2]//span//span//img

#Spans com os valores do complemento utilizado
${span_tipo_complemento}                    //span[text()="Tipo Complemento"]/../../div[2]/span/span
${span_abreviacao_complemento}              //span[text()="Abrev. Tipo Comp."]/../../div[2]/span/span

#Tela e botões da mudança de estado
${btn_marcar_concluido}                     //div[@title='Marcar Status como Completo'][contains(.,'Marcar Status como Completo')]
${btn_concluir}                             //button[@type='button'][contains(.,'Concluir')]
${erro_fluxo}                               //b[contains(.,'Ocorreu uma falha não tratada nesse fluxo')]
${btn_editar_sa}                            //div[contains(@title,'Editar')]
${select_auxilio}                           //select[@name="sc_TeveAuxilio"]
${btn_pesquisar}                            css=button[class="slds-button slds-button_neutral search-button slds-truncate"]

#Tela de atualizar facilidades
${btn_criar}                                //span[@title='Facilidades'][contains(.,'Facilidades')]/../../../../../..//div//div//ul//li//a//div
${cabo_riser}                               //input[contains(@name,'FSLOI_Cabo_Riser__c')]
${cabo_drop}                                //input[contains(@name,'FSLOI_Cabo_Drop__c')]
${CDOIA}                                    //input[contains(@name,'FSLOI_CDDOIA__c')]
${btn_salvar_criar}                         //button[@name='SaveAndNew'][contains(.,'Salvar e criar')]
${btn_close_facilidade}                     //button[@type='button'][contains(.,'Fechar esta janela')]


#Tela Atualizar Equipamento
${btn_consumo_equipamento}                  //div[@title='Consumo de Materiais e Equipamentos'][contains(.,'Consumo de Materiais e Equipamentos')]
${check_equipamento}                        (//span[contains(@class,'slds-radio_faux')])[1]
${btn_avancar}                              //button[@type='button'][contains(.,'Avançar')]
${select_equipamento}                       //select[contains(@name,'sc_EditEquipInstall')]
${linha_equipamento}                        //span[normalize-space()='Número do produto consumido']//following::a[4]
${equipamento_ok}                           //span[text()="Status da Validação"]/../../..//span[contains(text(),"OK")]
${input_nr_serie}                           //input[contains(@name,'sc_EditSerialInstall')]
${input_comodo}                             //select[contains(@name,'sc_Room')]
${check_associar}                           //span[contains(@class,'slds-checkbox_faux')]
${check_extravio}                           //*[text()="Extraviado"]/../../..//span[@class="slds-checkbox"]
${motivo_extravio}                          //*[text()="Motivo do Extraviamento"]/../../..//input[@type="text"]
${check_adicionar_mais}                     (//span[@class='slds-radio_faux'])[2]
${btn_concluir}                             //button[@type='button'][contains(.,'Concluir')]

#Tela Atualizar Material
${check_material}                           (//span[contains(@class,'slds-radio_faux')])[2]
${check_adicionar}                          (//span[contains(@class,'slds-radio_faux')])[1]
${input_grupo_material}                     //select[contains(@name,'sc_AddGroup')]
${input_material}                           //select[contains(@name,'sc_AddMaterial')]
${input_acao}                               //select[contains(@name,'sc_AddAction')]
${input_quantidade}                         //input[contains(@name,'sc_AddQuantity')]

#Tela Validar produtos consumidos
${ordem_trabalho}                           //span[@title='Ordem de Trabalho'][contains(.,'Ordem de Trabalho')]/..//div//div//div//a
${produtos_consumidos}                      //span[@class='rlql-label'][contains(.,'Produtos consumidos')]
${itens_linha_trabalho}                     //span[@class='rlql-label'][contains(.,'Itens de linha da ordem de trabalho')]
${table_produtos_consumidos}                (//table[@role='grid'][@aria-label='Produtos consumidos'])//tbody//tr
${itens_de_linha}                           //a//span[text()="Itens de linha da ordem de trabalho"]
${linhas_itens_ordem_trabalho}              (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr
${itens_trabalho_obrigatorio}               (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr[4]//img
${itens_trabalho_status}                    (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr[4]//span[contains(.,'Completed')]//span
${numero_orden_lista_get}                   (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr[1]//th//span//a
${numero_linha_ordem_trabalho}              //span[text()='Número do item de linha da ordem de trabalho']/../..

#Tela de adicionar tec auxiliar
${btn_criar_tecnico}                        (//span[@title='Técnico Auxiliar'][contains(.,'Técnico Auxiliar')])/../../../../..//a//div[contains(.,'Criar')]
${input_id_tecnico}                         //input[contains(@name,'FSLOI_EngineerID__c')]
${btn_exibir_tudo_tec}                      (//span[@title='Técnico Auxiliar'][contains(.,'Técnico Auxiliar')])/../../../../../..//a//div//span[contains(.,'Exibir tudo')]
${btn_tec}                                  //span[@title='Aux Technician Name'][contains(.,'Aux Technician Name')]/../../../../../../..//tbody//a[contains(.,'AUXT')]
${tecnico_id}                               //span[@class='test-id__field-label'][contains(.,'Engineer ID')]/../..//div//span//slot//lightning-formatted-text

#tela de Encerramento
${btn_encerrar}                             //div[@title='Encerramento'][contains(.,'Encerramento')]
${input_rsr}                                //input[contains(@name,'sc_RSR')]
${input_code}                               //label[@class='slds-form-element__label slds-no-flex'][contains(.,'Código de encerramento')]/..//div//input
${input_observacao}                         //input[contains(@name,'sc_Observation')]
${btn_ver_senha}                            //div[@title='Ver Senha'][contains(.,'Ver Senha')]
${campo_senha}                              //h2[normalize-space()='Ver Senha']//following::p[2]
${input_senha}                              //input[contains(@name,'sc_Password')]
${button_pesquisar}                         //button[contains(text(),'pesquisar')]
${arvore_codigos}                           //span[@class='slds-checkbox_faux']
${arvore_codigo1}                           (//select[contains(@class,'slds-select')])[1]
${arvore_codigo2}                           (//select[contains(@class,'slds-select')])[2]
${arvore_codigo3}                           (//select[contains(@class,'slds-select')])[3]
${arvore_descricao}                         //input[@name='shortDescription']
${arvore_completion_code}                   //input[@name='completionCode']

#Tela Field Service
${input_pesquisar_SA}                       css=iframe[lang="pt-BR"] >>> //input[contains(@id,'TaskSearchFilterInput')]
${SA_field_service}                         css=iframe[lang="pt-BR"] >>> //div[@id='TaskListItems']//div[@class='unselectable draggableService singleServiceBigContainer firstServiceIfSelection']
${atividade}                                css=iframe[lang="pt-BR"] >>> //div[@id='TaskListItems']//div[@class='unselectable draggableService singleServiceBigContainer firstServiceIfSelection']//div//div[@ng-repeat='field in pair']//div[@title='Atividade']/..//span//span//span
${doc_associado}                            css=iframe[lang="pt-BR"] >>> //div[@id='TaskListItems']//div[@class='unselectable draggableService singleServiceBigContainer firstServiceIfSelection']//div//div[@ng-repeat='field in pair']//div[@title='Documento Associado']/..//span//span//span
${pronto_exec}                              css=iframe[lang="pt-BR"] >>> //div[@id='TaskListItems']//div[@class='unselectable draggableService singleServiceBigContainer firstServiceIfSelection']//div//div[@ng-repeat='field in pair']//div[@title='Pronto Execução']/..//span//span//span
${btn_editar}                               css=iframe[lang="pt-BR"] >>> //div[contains(@title,'Editar')]
${check_box_SA}                             css=iframe[lang="pt-BR"] >>>
${btn_select}                               css=iframe[lang="pt-BR"] >>> //div[contains(@title,'Despachar')]/..//div[contains(@id,'ActionButton')]
${btn_remover_atribuicao}                   css=iframe[lang="pt-BR"] >>> //div[@class='truncate BulkActionMenuItem'][contains(.,'Remover atribuição')]
${btn_popup_remover_atribuicao}             css=iframe[lang="pt-BR"] >>> //button[@class='lightboxSaveButton'][contains(.,'Remover atribuição')]
${btn_sinalizar}                            css=iframe[lang="pt-BR"] >>> //span[contains(@title,'Sinalizar')]
${btnFiltrosTabela}                         css=iframe[lang="pt-BR"] >>> //button[@id='filterSkillsButton']
${btnFiltroHabilidades}                     css=iframe[lang="pt-BR"] >>> //button[@title='Habilidades']
${checkHabilitarHabilidades}                css=iframe[lang="pt-BR"] >>> //input[@id='enableSkills']
${checkFTTHREMCP}                           css=iframe[lang="pt-BR"] >>> //label[@title='FTTHREMCP']/../input

#Tela field Service troca de Tec
${input_searc_tec}                          css=iframe[lang="pt-BR"] >>> //input[contains(@ng-model,'searchEmployee')]
${btn_calendario_hoje}                      css=iframe[lang="pt-BR"] >>> //div[@class='truncate todayButton'][contains(.,'Hoje')]
${coluna_time}                              css=iframe[lang="pt-BR"] >>> //*[@data-section-index="1"]//div[@class='dhx_timeline_data_row dhx_data_table ']
${linha_agendamento}                        css=iframe[lang="pt-BR"] >>> //*[@data-section-index="1"]
${btn_pesquisar_todos_registro}             css=iframe[lang="pt-BR"] >>> //button[contains(.,'Pesquisar todos os registros')]
${btn_candidatos}                           css=iframe[lang="pt-BR"] >>> //div[@id="TaskListItems"]//span[contains(text(),'Candidatos')]
${btn_politica}                             css=iframe[lang="pt-BR"] >>> //div[contains(text(),'Política')]//select

#Historico de agendamento - tela RELACIONADO (Mensagem "Cancelamento Checkout")
${CancelamentoAgendamento}                  //span[contains(@title,'Cancelamento Checkout')]
${linkCancelamento}                         //span[contains(@title,'Cancelamento Checkout')]/../../..//th//span//div//a

#Historico de Agendamento - Tela de RELACIONADO (Mensagem "Cancelamento do Agendamento")
${CancelamentoDeAgendamento}                //span[contains(@title,'Cancelamento do Agendamento')]
${linkDoCancelamento}                       //span[contains(@title,'Cancelamento do Agendamento')]/../../..//th//span//div//a

#Historico de Compromisso de Serviço (campos relacionados) - Tela de RELACIONADO
${exibirTudo}                               //a[contains(@href,'Service_Appointment_History__r')]//span[@class='view-all-label']
${tabela_CompromissoServico}                (//table[@aria-label="Histórico Compromisso de Serviço (campos relacionados)"])[2]
${filtro}                                   //button[@title="Mostrar filtros rápidos"]
${campo}                                    //input[@name="FSLOI_Service_Appointment_History__c-FSLOI_Field__c"]
${botao_aplicar}                            //button[@title="Aplicar"]
${campo_Criado}                             (//td[@data-label="Campo"]//*[text()="Criado"])[last()]
${estado_Atribuido}                         (//td[@data-label="Novo Valor"]//*[text()="Atribuído"])[last()]
${estado_NaoAtribuido}                      (//td[@data-label="Valor Original"]//*[text()="Não atribuído"])[last()]
${estado_Recebido}                          (//td[@data-label="Novo Valor"]//*[text()="Recebido"])[last()]
${estado_emDeslocamento}                    (//td[@data-label="Novo Valor"]//*[text()="Em deslocamento"])[last()]
${estado_emExecucao}                        (//td[@data-label="Novo Valor"]//*[text()="Em execução"])[last()]
${estado_fechadoEmWFM}                      (//td[@data-label="Novo Valor"]//*[text()="Fechado em WFM"])[last()]
${estado_ConcluidoComSucesso}               (//td[@data-label="Novo Valor"]//*[text()="Concluído com sucesso"])[last()]

#Consultar "Resursos de serviços"
${btn_Recurso_servicos}                     //a[@data-label="Recursos de serviços"]//p[@class='slds-truncate'][normalize-space()='Recursos de serviços']
${pg_Relacionado}                           //a[@aria-selected="false"]/..//*[@data-label='Relacionado']
${valida_1_territorio}                      //span[contains(@title,'Territórios de serviços')]/..//span[contains(@title,'(1)')]
${local_territorio_servico}                 //div[@class='listWrapper'][3]
${territorio_servico}                       //span[contains(@title,'Territórios de serviços')]
${nome_tecnico_atribuido}                   //span[@title='Recursos atribuídos'][contains(.,'Recursos atribuídos')]/../../../../../../..//div[3]//tbody//tr//text()/../../..//div
${button_Pesquisa_Lista}                    //input[contains(@placeholder,'Pesquisar nesta lista...')]
${button_Refresh_Lista}                     //div[@class='slds-m-left_xx-small'] //button[@name='refreshButton'][contains(.,'Atualizar')]

#Desatribuir na pagina do compromisso de serviço
${button_exibir_tudo}                       //span[@title='Recursos atribuídos']/../../../../../../.././/span[@class='view-all-label'][contains(.,'Exibir tudo')]
${button_excluir_tecnico}                   //button[@class="slds-button slds-button_icon-border slds-button_icon-x-small"]
${button_excluir}                           (//div[@title="Excluir"]/..)[last()]
${caixa_excluir}                            (//span[@dir="ltr"][contains(.,'Excluir')])[last()]