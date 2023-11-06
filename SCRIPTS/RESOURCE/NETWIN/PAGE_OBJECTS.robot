*** Settings ***
Documentation                               Arquivo de objetos/xpath do FSL

*** Variables ***

#Tela inicial de Login no sistema
${btn_login_Netwin}                         //button[contains(@id,'login_button')]
${input_login_Netwin}                       //input[contains(@id,'Login')]
${input_password_Netwin}                    //input[contains(@id,'inputPassword')]
${input_captcha_netwin}                     //input[contains(@id,'inputCaptcha')]


#Tela após login (pesquisa)
${location_manager}                         //a[contains(.,'Location Manager')]
${pesquisa_pg1}                             //a[contains(.,'Pesquisa')]
${Nome_IDSurvey}                            //input[contains(@id,'location_locphysical_input_name')]
${pesquisar_pg2}                            iframe#iframe-content-wrapper >>>       //a[contains(.,'Pesquisar')]
${pesquisar_IDSurvey}                       //a[contains(.,'Pesquisar')]
${antena_netwin}                            //a[contains(@title,'Visualizar em OSP')]
${resource_provisioning}                    //a[contains(@id,'operational-module-resource_provisioning')]
${resource_provisioning_seta}               //a[contains(@id,'operational-button-resource_provisioning')]
${botao_criar}                              iframe#iframe-content-wrapper >>>       //a[@id='create-button']
${viabilidade_GPON}                         //a[contains(.,'Viabilidade GPON')]
${btn_resource_provisioning_pesquisar}      //a[@id='operation-module-link-rp-1-0']
${selectTipoServico}                        iframe#iframe-content-wrapper >>>       //*[@id="tipoServico"]
${servicoCliente}                           iframe#iframe-content-wrapper >>>       //*[@id="identificaServico"]
${search_eye}                               iframe#iframe-content-wrapper >>>       //th[contains(text(),"Ações")]/../../..//i
${cessar_eye}                               iframe#iframe-content-wrapper >>>       //td[contains(text(),"Cessar")]/..//i[@class="fuxicons fuxicons-eye"]
${fim_pedido}                               frame#ifr >>> //table[@id="question"]//*[text()="Ok"]/..
${Outside_Plant}                            //a[@id="operational-module-osp"]
${Outside_Plant_Visao_Geo}                  //a[@id="operation-module-link-osp-1-0"]
${inside_plant_seta}                        //a[contains(@id,'operational-button-isp')]
${acessoGPON_estado_item}                   iframe#iframe-content-wrapper >>>       //td[text()="Acesso GPON"]/..//td[8]
${acessoGPON_eye}                           iframe#iframe-content-wrapper >>>       //td[contains(text(),"Acesso GPON")]/..//i

#Outside Plant
${Button_Utilitarios}                       iframe#iframe-content-wrapper >>>       //div[@title="Utilitários" and @class="olControlUtilitiesItemInactive"]
${Button_Utilitarios_Survey}                iframe#iframe-content-wrapper >>>       //td[@id="olControlSurvey"]
${Button_Utilitarios_Survey_Import}         iframe#iframe-content-wrapper >>>       //td[@id="olControlImportSurvey"]
${Button_Upload}                            iframe#iframe-content-wrapper >>>       //td[@id="importNavGridUpload"]
${Input_File}                               iframe#iframe-content-wrapper >>>       //input[@type="file" and @id="fileinput"]
${Td_Sucesso_Importacao}                    iframe#iframe-content-wrapper >>>       //td[normalize-space()="O processo de importação foi concluído com sucesso"]


#Resource Provisioning
${ID_externo}                               iframe#iframe-content-wrapper >>>       //input[contains(@id,'provisionnworderext')]
${data_objetivo}                            iframe#iframe-content-wrapper >>>       //input[contains(@id,'provisionData')]
${selecionar_data_atual}                    iframe#iframe-content-wrapper >>>       //td[contains(@class,"ui-datepicker-today")]
${adicionar_servico}                        iframe#iframe-content-wrapper >>>       //div[contains(@id,"add_Button")]
${selecionar_servico}                       iframe#iframe-content-wrapper >>>       //div[@id='add_service']//select[@id='select_serv_type']
${operacao_adicionarServico}                iframe#iframe-content-wrapper >>>       //div[@id='add_service']//select[@id='select_operation_type']
${campoNome_adicionarServico}               iframe#iframe-content-wrapper >>>       //div[@id='add_service']//input[@id='service_id']
${unidadeDebito_adicionarServico}           iframe#iframe-content-wrapper >>>       //select[@id='UNIDADE_DEBITO']
${botao_adicionar_adicionarServico}         iframe#iframe-content-wrapper >>>       //div[@id='add_service']//a[@id='add_new_service']
${botao_confirmar}                          iframe#iframe-content-wrapper >>>       //a[@onclick='javascript: checkInputValues()']
${botao_ok}                                 iframe#iframe-content-wrapper >>>       //a[@onclick='modalQuestionOkClicked();']
${caracteristicas_provisao}                 frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //*[@id="elemServCfs_elemCFS.state"]
${caracteristicas_operacional}              frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //*[@id="elemServCfs_elemCFS.operationalState"]
${caracteristicas_dataCriacao}              frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //*[@id="elemServCfs_elemCFS.createDate"]
${caracteristicas_dataActualizacao}         frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //*[@id="elemServCfs_elemCFS.updateDate"]
${aba_Cliente}                              frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //a[@href="#cliente"]
${tipo_cliente}                             frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //div[@id="cliente"]//div[@class="xLabelField"]
${button_pesquisa}                          iframe#iframe-content-wrapper >>>       //html/body/div[7]/div[2]/div/div[1]/table/tbody/tr[2]/td[5]/div/img
${aba_ServicosDeRede}                       frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //a[@href="#ListagemRFSa"]
${tipo_servicosDeRede}                      frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //div[@id="ListagemRFSa"]//th[@class="ui-state-default"]
${aba_ServicosDeCliente}                    frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //a[@href="#ListagemCFSPaisS"]
${relacao_servicosDeCliente}                frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //div[@id="ListagemCFSPaisS"]//th[@class="ui-state-default"]
${aba_atribuicao}                           frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //a[@href="#Atribuicao"]
${familiaRFS}                               frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> iframe#dadosAtribuicao >>> //select[@id="select_familia_rfs"]
${tipoRFS}                                  frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> iframe#dadosAtribuicao >>> //select[@id="select_tipo_rfs_rede"]
${botao_criarRFS}                           frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> iframe#dadosAtribuicao >>> //a[@id="addRFS"]
${botao_terminarDesignacao}                 frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> iframe#dadosAtribuicao >>> //*[@id="buttonFinishDesignation"]/span
${botao_okTerminar}                         frame#ifr >>> //span[text()="Ok"]/..
${botao_finalizarPedido}                    frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> iframe#dadosAtribuicao >>> //span[text()="Finalizar Pedido"]
${botao_okFinazarPedido}                    frame#ifr >>> (//span[text()="Ok"]/..)[2]
${alerta_sucesso}                           frame#ifr >>> (//table[@id="alert"])[3]//*[text()="Operação realizada com sucesso."]
${estado_rfs}                               frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> iframe#dadosAtribuicao >>> //td[@class="tdRfs" and contains(text(),"Activo")]
${estado_provisao}=                         frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //td[@class="ui-widget-content" and contains(text(),"Activo")]

${tabela_servico_linhas}                    iframe#iframe-content-wrapper >>>       //div[@id='serviceProvision']//table[@id='table_serviceProvision']//tbody
${caracteristicas_segmento}                 frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_SEGMENTO']
${caracteristicas_UF}                       frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_UF']
${caracteristicas_bairro}                   frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_codigoBairro']
${caracteristicas_cod_localidade}           frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_codigoLocalidade']
${caracteristicas_cod_logradouro}           frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_codigoLogradouro']
${caracteristicas_ID_empresa}               frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_companyId']
${caracteristicas_ID_endereco}              frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_idEndereco']
${caracteristicas_numero}                   frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_nFachada']
${caracteristicas_ID_contrato}              frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='elemServCfs_subscriberId']
${características_operacao}                 frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='associatedOrderItemAction']
${características_estado_item}              frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='associatedOrderItemState']
${características_atividade}                frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='associatedOrderItemActivity']
${btn_olho_home_network}                    frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> (//i[contains(@class,'fuxicons fuxicons-eye')])[1]
${btn_olho_PON}                             frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> (//i[contains(@class,'fuxicons fuxicons-eye')])[2]
${tabela_conectividade}                     frame#ifr >>> iframe#dados >>> iframe#dados >>> //tr[@id='node--1']
${tabela_elemento_de_rede1}                 frame#ifr >>> iframe#dados >>> iframe#dados >>> (//tr[@id='node--1']//td[@class='treeTableMe'])[1]
${tabela_terminacao_1}                      frame#ifr >>> iframe#dados >>> iframe#dados >>> (//td[contains(@title,'TTP')])[1]
${tabela_terminacao_2}                      frame#ifr >>> iframe#dados >>> iframe#dados >>> (//td[contains(@title,'TTP')])[2]
${tabela_elemento_ONT}                      frame#ifr >>> iframe#dados >>> iframe#dados >>> (//tr[@id='node--1']//td[@class='treeTableMe'])[2]
${aba_GPON}                                 frame#ifr >>> iframe#dados >>> iframe#dados >>> (//div[@id='siteMap']//span[@class='mapurl'])[2]
${select_provisao}                          frame#ifr >>> iframe#dados >>> iframe#dados >>> iframe#frmEntidade >>>  iframe#dados >>> //select[@id='elemServRfs_elemRFS.state']//option[@value='IN_PROVISIONING']
${select_operacional}                       frame#ifr >>> iframe#dados >>> iframe#dados >>> iframe#frmEntidade >>>  iframe#dados >>> //select[@id='elemServRfs_elemRFS.operationalState']//option[@value='ENABLED']
${input_data_criacao}                       frame#ifr >>> iframe#dados >>> iframe#dados >>> iframe#frmEntidade >>>  iframe#dados >>> //input[@id='elemServRfs_elemRFS.createDate']
${input_data_actualizacao}                  frame#ifr >>> iframe#dados >>> iframe#dados >>> iframe#frmEntidade >>>  iframe#dados >>> //input[@id='elemServRfs_elemRFS.updateDate']
${atribuicao_tabela_encaminhamento}         frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //div[@id='idTable']
${btn_olho_GPON}                            iframe#iframe-content-wrapper >>>       (//i[@class='fuxicons fuxicons-eye'])[1]
${btn_olho_VPN}                             iframe#iframe-content-wrapper >>>       (//i[@class='fuxicons fuxicons-eye'])[2]
${tbody_servicos_rede}                      frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //table[@id='rowPedidoListaRfs']//tr//td[@class='ui-widget-content']
${tabela_estado_provisao}                   frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //table[@id='rowPedidoListaRfs']//tr//td[@class='ui-widget-content'][3]
${btn_mais_CPE}                             frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //i[@class='glyphicon glyphicon-plus']
${select_tipo_CPE}                          frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //select[@id='cpeTipoSelect']
${select_fabricante_CPE}                    frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //select[@id='cpeFabricanteSelect']
${select_modelo_CPE}                        frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //select[@id='cpeModelSelect']
${select_regime_CPE}                        frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //select[@id='cpeRegimeSelect']
${btn_calendario_CPE}                       frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //div[@id='datainstpicker']//img[@title='label.provision.fix_data']
${selecionar_data_atual_CPE}                frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //td[contains(@class,"ui-datepicker-today")]
${input_Nr_serie_CPE}                       frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //input[@id='nseriecpe']
${btn_adicionar_CPE}                        frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //a[@id='addCpe']
${btn_fecha_CPE}                            frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //button[@aria-hidden='true'][contains(.,'x')]
${btn_finaliza_pedido_GPON}                 frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //div[@id='divBotao']//span[contains(.,'Finalizar Pedido')]
${tabela_estado_item}                       iframe#iframe-content-wrapper >>>       (//td[@class='order'][9])
${tabela_estado_item_GPON}                  iframe#iframe-content-wrapper >>>       (//td[@class='order'][9])[1]
${tabela_estado_item_VPN}                   iframe#iframe-content-wrapper >>>       (//td[@class='order'][9])[2]
${btn_exporta_excel}                        frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //div[@id='export-actions']
${tabela_ID_endereco}                       iframe#iframe-content-wrapper >>>       (//div[@id='codigosPdo']//td[3])[1]
${botao_ok_CPE}                             frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //a[@onclick='modalQuestionOkClicked();']


#Aba Adicionar Serviço
${aba_Servico_Suporte}                      iframe#iframe-content-wrapper >>>       //div[@id='add_service']//a[@href='#tabs-supp'][contains(.,'Serviços Suporte')]
${input_codigo_bairro}                      iframe#iframe-content-wrapper >>>       //input[@id='codigoBairro']
${input_codigo_localidade}                  iframe#iframe-content-wrapper >>>       //input[@id='codigoLocalidade']
${input_UF}                                 iframe#iframe-content-wrapper >>>       //input[@id='UF']
${input_codigo_logradouro}                  iframe#iframe-content-wrapper >>>       //input[@id='codigoLogradouro']
${input_numero_fachada}                     iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>>       //label[text()='Número fachada']/..//input
${input_num_fachada}                        iframe#iframe-content-wrapper >>>       //input[@id='nFachada']
${select_produto_VPN}                       iframe#iframe-content-wrapper >>>       //select[@id='PRODUTO']
${select_QOS}                               iframe#iframe-content-wrapper >>>       //select[@id='QOS']
${select_ID_perfil}                         iframe#iframe-content-wrapper >>>       //select[@id='ID_PERFIL_TRAFEGO']
${select_tipo_enderacamento}                iframe#iframe-content-wrapper >>>       //select[@id='TIPO_ENDERECAMENTO']
${input_ID_endereco}                        iframe#iframe-content-wrapper >>>       //input[@id='idEndereco']
${btn_confirmar_servico}                    iframe#iframe-content-wrapper >>>       //i[@id='accept_button_serv_sup']

#Tela GPON
${select_segmento}                          iframe#iframe-content-wrapper >>>       //select[contains(@id,'cboSegmento')]
${input_CEP}                                iframe#iframe-content-wrapper >>>       //div[contains(text(),'Viabilidade GPON')]//following::input[@id='cep']
${input_fachada}                            iframe#iframe-content-wrapper >>>       //input[contains(@id,'addrLevel7')]
${btn_validar_viabilidade}                  iframe#iframe-content-wrapper >>>       //a[contains(.,'Validar Viabilidade')]
${select_complemento}                       iframe#iframe-content-wrapper >>>       //select[contains(@id,'addrLevel8')]
${input_complemento}                        iframe#iframe-content-wrapper >>>       //input[contains(@id,'addrLevel9')]
${tabela_CEP}                               iframe#iframe-content-wrapper >>>       //table[@id="tableServices"]//tr[@class='odd'][1]//td[12]
${select_UF}                                iframe#iframe-content-wrapper >>>       //label[contains(.,'Unidade federativa*')]/../..//div//select
${popUp_tabela}                             iframe#iframe-content-wrapper >>>       //div[@class='ui-widget-overlay']/..//div[@id='popUp']
${btn_bairro}                               iframe#iframe-content-wrapper >>>       //div[contains(@id,'popUp')]/..//input
${widget_tabelaCEP}                         iframe#iframe-content-wrapper >>>       //table[contains(@id,'tableCEP')]/tbody//tr
${btn_confirmar_widget}                     iframe#iframe-content-wrapper >>>       //div[@id='popUp']//a[@id='fillData']

# retornar a tela "Resource Provisioning" e valida após a pesquisa do serviço alterado.
${button_inicio}                            //h1[@class='fx-logo-brand']
${valida_alterar}                           iframe#iframe-content-wrapper >>>       //td[contains(text(),'Alterar')]
${serviço_cliente}                          iframe#iframe-content-wrapper >>>       //*[@id="servicesTable"]/tbody/tr[1]/td[5]
${atividade_item}                           iframe#iframe-content-wrapper >>>       //*[@id="servicesTable"]/tbody/tr[1]/td[7]
${valida_concluido}                         iframe#iframe-content-wrapper >>>       //*[@id="servicesTable"]/tbody/tr[1]/td[8]
${valida_cessar}                            iframe#iframe-content-wrapper >>>       //td[contains(text(),'Cessar')]

#Realizar Gestão de Entidades
${btn_Outside_plant}                        //a[contains(@id,'operational-module-osp')]
${btn_visao_georreferenciada}               //a[contains(.,'Visão georreferenciada')]
${btn_Ba_BAHIA}                             iframe#iframe-content-wrapper >>> iframe#ifrarvore >>> iframe#ifArvore >>> //a[contains(.,'BA - BAHIA')]
${btn_pesquisar_geo}                        iframe#iframe-content-wrapper >>> iframe#ifrarvore >>> iframe#ifArvore >>> //table//tr//td[contains(@title,'Pesquisar')]
${select_UF_estado}                         iframe#iframe-content-wrapper >>> //div[contains(text(),'UF')]/..//select[contains(@class,'localizacao')]
${select_Municipio}                         iframe#iframe-content-wrapper >>> //div[contains(text(),'Município')]/..//select[contains(@class,'localizacao')]
${select_Localidade}                        iframe#iframe-content-wrapper >>> //div[contains(text(),'Localidade')]/..//select[contains(@class,'localizacao')]
${select_Entidade}                          iframe#iframe-content-wrapper >>> //div[contains(text(),'Entidade')]/..//select[contains(@id,'rede')]
${select_Tipo}                              iframe#iframe-content-wrapper >>> //div[contains(text(),'Tipo')]/..//select[contains(@id,'tipo')]
${input_Nome}                               iframe#iframe-content-wrapper >>> //div[contains(text(),'Nome')]/..//input[contains(@id,'codigo')]
${btn_pesquisar_Netwin}                     iframe#iframe-content-wrapper >>> //p//input[contains(@value,'Pesquisar')]
${btn_OPTN1}                                iframe#iframe-content-wrapper >>> //td[contains(@aria-describedby ,'pesquisaGrid_code')]
${span_close_GOVS}                          iframe#iframe-content-wrapper >>> //span[contains(text(),'GOVS')]/..//span[contains(text(),'close')][1]
${btn_mais_mapa}                            iframe#iframe-content-wrapper >>> //span[contains(@id,'objLayerSwitcher_expander')]
${btn_mapa_equipamento}                     iframe#iframe-content-wrapper >>> //td[contains(@id,'objLayerSwitcherlabel_L_16')]/..//td[contains(@class,'LS_expImg')]
${btn_mapa_Survey}                          iframe#iframe-content-wrapper >>> //td[contains(@id,'objLayerSwitcherlabel_L_17')]/..//td[contains(@class,'LS_expImg')]
${btn_mapa_celulas}                         iframe#iframe-content-wrapper >>> //td[contains(@id,'objLayerSwitcherlabel_L_18')]/..//td[contains(@class,'LS_expImg')]
${btn_mapa_Redefixa}                        iframe#iframe-content-wrapper >>> //img[contains(@id,'objLayerSwitcherexp_L_3')]/..
${btn_caneta+}                              iframe#iframe-content-wrapper >>> //div[contains(@id,'controlBarContainer')]//div[contains(@title,'Adicionar')]
${btn_caneta+_local}                        iframe#iframe-content-wrapper >>> //table[contains(@id,'olControlAddButtonMenu')]//tr//td[contains(text(),'Local')]
${span_caixa_subterrania}                   iframe#iframe-content-wrapper >>> //div[contains(text(),'Caixa Subterrânea')]/..//span/..
${caixa_calçada}                            iframe#iframe-content-wrapper >>> //div[contains(text(), 'Caixa em Calçada')]/../..//a
${input_valor_numero_calcada}               iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(@for,'location_input_numero')]/..//div//input
${btn_eliminar}                             iframe#iframe-content-wrapper >>> //div[contains(@id, 'controlBarContainer')]//div[contains(@title, 'Eliminar')]
${btn_eliminar_local}                       iframe#iframe-content-wrapper >>> //table[contains(@id,'olControlRemoveButtonMenu')]//tr//td[contains(text(),'Local')]
${select_Projeto}                           iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Projeto')]/..//span[contains(@class ,'selection')][2]
${input_data_caixa}                         iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Data estado ciclo de vida')]/..//input
${input_projeto}                            iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${input_projeto_click}                      iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${capacidade_click_options}                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Capacidade (N° de lados)')]/..//span[contains(@class ,'select2-selection__arrow')]
${capacidade_input_options}                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${capacidade_input_escolha}                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${tipo_click_options}                       iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Tipo')]/..//span[contains(@class ,'select2-selection__arrow')]
${tipo_input_options}                       iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${tipo_input_escolha}                       iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${material_click_options}                   iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Material')]/..//span[contains(@class ,'select2-selection__arrow')]
${material_input_options}                   iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${material_input_escolha}                   iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${btn_localizacao}                          iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[contains(text(), 'Localização')]
${btn_localizacao_add}                      iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //h6[contains(.,'Endereços')]/../../..//button[contains(@title, 'editar')]/../..//button[contains(@title, 'adicionar')]
${filtro_logradouro_escolha}                iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Filtro Logradouro')]/..//span[contains(@class ,'select2-selection__arrow')]
${filtro_logradouro_input_options}          iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${filtro_logradouro_input_escolha}          iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${input_numero_fachada}                     iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Número fachada')]/..//input
${cep_input_escolha}                        iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'CEP')]/..//span[contains(@class ,'select2-selection__arrow')]
${cep_input_options}                        iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${cep_input_escolha}                        iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${bairro_input_escolha}                     iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Bairro')]/..//span[contains(@class ,'select2-selection__arrow')]
${bairro_input_options}                     iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${bairro_input_escolha}                     iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${btn_confirmar_endereço}                   iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //button[contains(@id, 'modal_button_ok')]
${linhas_endereço}                          iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //table[contains(@id, 'datatable_addresses_53_')]
${btn_relaçoes}                             iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[contains(text(), 'Relações')]
${btn_atividades}                           iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[contains(text(), 'Atividades')]
${btn_historicos}                           iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[contains(text(), 'Atividades')]/../..//a[contains(text(), 'Histórico')]
${btn_origem_escolha}                       iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[contains(text(),'Origem')]/..//span[contains(@class ,'select2-selection__arrow')]
${btn_origem_options}                       iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[contains(@class,'select2-search__field')]
${btn_origem_click_escolha}                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[contains(@class,'select2-results')]
${btn_guardar_endereco}                     iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[contains(@class, 'btn btn-primary')]
${btn_pesquisa_arvore}                      iframe#iframe-content-wrapper >>> //img[contains(@title,'Pesquisa Arvore')]/..
${btn_modificar_atributo}                   iframe#iframe-content-wrapper >>> //div[contains(@id,'controlBarContainer')]//div[contains(@title, 'Modificar Atributos')]
${btn_modificar_atributo_local}             iframe#iframe-content-wrapper >>> //table[contains(@id,'olControlModifyButtonMenu')]//tr//td[contains(@attr,'OpenLayers.Control.ModifyInfranode_411')]
${btn_opcoes_adicionais_localizacao}        iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //button[contains(@title, 'opções adicionais')]
${btn_editar_localizacao}                   iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //button[contains(@title, 'opções adicionais')]/..//a[contains(@title, 'editar')]
${linha_validar_endereco}                   iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //table[contains(@id, 'datatable_addresses_53_')]//tbody//td[2]

#Inside Plant
${abrir_BA}                                 iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="0_childs"]//td[@id="sigrede_1_0_2_6_exp"]
${abrir_FeiraDeSantanda}                    iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="6_childs"]//td[@id="sigrede_1_0_2_6_3_1848970_exp"]
${abrir_FSA_FeiraDeSantana}                 iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="1848970_childs"]//td[@id="sigrede_1_0_2_6_3_1848970_4_1880180_exp"]
${abrir_estacaoPredial}                     iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="1880180_childs"]//td[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_exp"]
${abrir_GV01_FeiraDeSantada}                iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_exp"]
${abrir_CDOI}                               iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_6_55169843_270_exp"]
${abrir_EQ_CDOI_5PL}                        iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_6_55169843_270_7_3872074_exp"]
${EQ_CDOI_5PL}                              iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //a[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_6_55169843_270_7_3872074_txt"]
${abrir_EQ_CDOI_5PL}                        iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_6_55169843_270_7_3872074_exp"]
${alterarEquipamento}                       iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //div[@id="popupAccao"]//tr[@id="divSpan_1003"]
${aba_estruturaFisica}                      iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //a[@href="#estruturaFisica"]
${criarEstrutura}                           iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //a[@id="confAssocEstrutura"]
${consultarEquipamento}                     iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //div[@id="popupAccao"]//td[@title="Consultar Equipamento"]

${aba_caracteristicas}                      iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //a[@href="#a"]
${codigo_bastidor}                          iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //input[@name="elem.codigo"]
${identificacao_fisica}                     iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //input[@id="elem_nome"]
${numero_logico}                            iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //input[@id="numeroLogico"]
${modelo_bastidor}                          iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="idTipoElemento"]
${ciclo_de_vida}                            iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="elem_estado_ciclo_vida"]
${estado_operacional}                       iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="elem_estado_operacional"]
${legado}                                   iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="LEGADO"]
${observacoes}                              iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //textarea[@id="elem_observacoes"]

${aba_localizacao}                          iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //a[@href="#b"]
${filaLado}                                 iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //input[@id="elem_fiada"]
${posicao}                                  iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //input[@id="elem_posicao"]

${aba_estruturaFisica}                      iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //a[@href="#c"]
${altura}                                   iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //input[@id="elem_tipo.altura"]
${largura}                                  iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //input[@id="elem_tipo.largura"]
${bastidores}                               iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //table[@id="rowBast"]
${shelves}                                  iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //table[@id="rowSubbastidores"]
${placas}                                   iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //table[@id="rowCard"]

${confirmarCriacao}                         iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //a[@id="confAssoc"]
${fecharAlerta}                             iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //button[@onclick="afterConfirm(true);"]

#Criar Shelf
${codigo_bastidor2}                         iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //input[@id="elem_codigo"]
${identificacao_fisica2}                    iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //input[@id="elem_nome"]
${legado2}                                  iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //select[@id="LEGADO"]
${observacoes2}                             iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //textarea[@id="elem_observacoes"]
${aba_localizacao2}                         iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //a[@href="#b"]
${vista}                                    iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //select[@id="elem_frente_costas"]
${localizacaoX}                             iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //input[@id="xSubbastidor"]
${localizacaoY}                             iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //input[@id="ySubbastidor"]
${aba_UFs}                                  iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //a[@href="#UFs"]
${UF_operacao}                              iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //select[@id="uf_operacao"]
${UF_tipo}                                  iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //select[@id="uf_id_bd_tipo_un_funcional"]
${UF_codificacao}                           iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //input[@id="uf_codificacao"]
${confirmarCriacao2}                        iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //a[@id="confAssoc"]
${fecharAlerta2}                            iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //button[@onclick="afterConfirm(true);"]
${xFinalizar}                               iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //button[@onclick="afterConfirm(false); return false;"]    # Clicar no X
${icone_olho}                               iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //i[@id="btnSubbastidordetails"]

#Criação da Placa
${abrir_BAS}                                iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //a[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_6_55169843_270_7_3872068_12_176271_3872068_txt"]
${abrir_SB}                                 iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //a[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_6_55169843_270_7_3872068_12_176271_3872068_13_327141_3872068_txt"]
${SLOT1}                                    iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //a[@id="sigrede_1_0_2_6_3_1848970_4_1880180_38_82_1880180_5_55169843_6_55169843_270_7_3872068_12_176271_3872068_13_327141_3872068_14_4306670_3872068_txt"]
${criar_placa}                              iframe#iframe-content-wrapper >>> iframe#ifArvore >>> iframe#ifArvore >>> //td[@id="nodefault_1035"]

${placa_modelo}                             iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="idTipoElemento"]
${placa_cicloVida}                          iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="elem_idCicloVida"]
${placa_estadoOperacional}                  iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="elem_idOperacional"]
${unidade_funcional}                        iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //select[@id="elem_id_bd_unidade_funcional"]
${aba_outros}                               iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //a[@href="#d"]

${botao_ok_remover}                         iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //a[@id="buttonOK"]
${fechar_confirmacao}                       iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> iframe#info >>> //table[@class="modalDialogDIV alert-dialog success-dialog success2"]//button[@class="close"]
${fechar_confirmacao2}                      iframe#iframe-content-wrapper >>> iframe#ifr >>> iframe#dados >>> //table[@class="modalDialogDIV alert-dialog success-dialog success2"]//button[@class="close"]

#Botões Pagina de pesquisa do Survey 
${botton_antena}                            //a[contains(@title,'Visualizar em OSP')]
${botton_lupa}                              iframe#iframe-content-wrapper >>>       //div[@class='olControlNavToolbar']//div[contains(@title,'Detalhe Local')]
${MenuAdicionar}                            iframe#iframe-content-wrapper >>>       //div[@class='olControlNavToolbar']//div[contains(@title,'Adicionar')]
${OptionLocal}                              iframe#iframe-content-wrapper >>>       //table[@id="olControlAddButtonMenu"]//td[text()="Local" and @id="olControlAddInfranode"]
${MenuEdificio}                             iframe#iframe-content-wrapper >>>       //ul[@id="ulCatalogMenu"]//a[@catsubtypeid="79"]//div[text()="Edifício"]
${ButtonEstacaoPredial}                     iframe#iframe-content-wrapper >>>       //ul[@id="ulCatalogMenu"]//a[@catsubtypeid="82"]//div[text()="Estação Predial"]


#Elementos página Criacao OPT

${InputNomeEntidade}                        iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[@id="location_input_name"]
${InputDesignacao}                          iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[@id="location_input_description"]
${InputProjetoCombo}                        iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[text()="Projeto"]/..//span[@role="combobox"]
${InputProjetoComboPesquisa}                iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[@class="select2-search select2-search--dropdown"]//input[@class="select2-search__field"]
${InputProjetoComboValor}                   iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //li[text()="A1-12641-2018-FTTH-ALD-CE_CEOS48"]
${InputSigla}                               iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[@id="location_input_sigla"]
${SelectRedeSuportada}                      iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[text()="Redes suportadas"]/..//span[@role="combobox"]
${SelectRedeSuportadaValor}                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //li[normalize-space()="Rede Óptica GPON"]

${InputDescricaoCombo}                      iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[text()="Descrição"]/..//span[@role="combobox"]
${InputDescricaoComboPesquisa}              iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[@class="select2-search select2-search--dropdown"]//input[@class="select2-search__field"]
${InputDescricaoComboValor}                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //li[normalize-space()="Edifício (Escritórios)"]

#Aba Localização
${AbaLocalização}                           iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[@id="location_tab_localization"] 
${ButtonAdicionar}                          iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //button[@id="datatable_addresses_53__rightaction_add" and @title="adicionar"]
${InputFiltroLogradouro}                    iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[text()="Filtro Logradouro"]/..//span[@role="combobox"]
${InputFiltroLogradouroPesquisa}            iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[@class="select2-search select2-search--dropdown"]//input[@class="select2-search__field"]
${InputFiltroLogradouroValor}               iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //ul[@id="select2-location_addresses_select_baseAddress-results"]//li[1]
${InputNumeroFachada}                       iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //input[@id="location_addresses_input_numFachada"]
${ButtonOK}                                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //button[@id="modal_button_ok"]

#Aba Serviços
${AbaServicos}                              iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[@id="location_tab_servicos"]
${InputServicosDisponiveis}                 iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[text()="Serviços disponíveis"]/..//span[@role="combobox"]

#Aba Histórico         
${AbaHistórico}                             iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[@id="location_tab_logs"]
${InputOrigem}                              iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //label[text()="Origem"]/..//span[@role="combobox"]
${InputOrigemPesquisa}                      iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //span[@class="select2-search select2-search--dropdown"]//input[@class="select2-search__field"]
${InputOrigemValor}                         iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //li[normalize-space()="Netwin"]
${ButtonSalvar}                             iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //a[@id="forms_button_save"]