*** Settings ***
Documentation                               Arquivo de objetos/xpath SOM


*** Variables ***
#Login
${SOM_input_login}                          //input[@class='UserNameComponent']
${SOM_input_password}                       //input[@class='PasswordComponent']
${SOM_btn_login}                            //input[@class='LoginText']


#Pagina Inicial
${SOM_btn_worklist}                         //div[@id='TopIndex']//table[1]/..//img[@name='worklist_']
${SOM_rb_Preview}                           //*[@id="BodyIndex"]/form/table[1]/tbody/tr/td/p/input[2]
${SOM_rb_Editor}                            //*[@id="BodyIndex"]/form/table[1]/tbody/tr/td/p/input[1]
${SOM_rb_ProcessHistory}                    //*[@id="BodyIndex"]/form/table[1]/tbody/tr/td/p/input[3]
${SOM_order_input}                          //*[@id="aazone.worklist"]/form/table/tbody/tr[1]/td/input[1]
${SOM_Ref_Input}                            //*[@id="aazone.worklist"]/form/table/tbody/tr[1]/td/input[2]
${SOM_btn_refresh}                          //input[@value='Refresh']
${SOM_Option_ChangeStatus}                  //span[text()="Change Task State/Status..."]


#T017 - Instalar Equipamento
${SOM_atividade}                            //html/body/table/tbody/tr[1]/td/div[4]/form/table/tbody/tr/td/div/table/tbody/tr[2]/td[2]/h1

#Dados de Pendencia
${SOM_pendencia}                            //a[.='Dados de Pendência']/../../../../..//*[text()='Pendência']/../../../../..//tr//td//div//input
${SOM_numeroARS}                            //div[@class='window'][1] //div[@class='windowContent']  //div[@class='oeGroupNode']  //div[@style='display:inline;'][2] //input
${SOM_Select_pendencia}                     (//select[contains(@id,'completionStatusList')])[1]
${SOM_resultadoAnalise}                     //span[.='Analise do Chamado Tecnico']/../../..//label[normalize-space()='Resultado da Análise']/../../../..//textarea
${SOM_observacao}                           //span[.='Analise do Chamado Tecnico']/../../..//label[normalize-space()='Observação']/../../../..//textarea
${SOM_Select_Motivo_Pendencia}              //span[.='Analise do Chamado Tecnico']/../../..//label[normalize-space()='Tipo Motivo']/../../../..//select
${SOM_input_Motivo}                         //span[.='Analise do Chamado Tecnico']/../../..//label[normalize-space()='Motivo']/../../../..//textarea
${SOM_pendencia_observacoes}                //a[.='Dados de Pendência']/../../../../..//*[text()='Observações']/../../../../..//tr//td//div//input

#Dados da Ordem
${SOM_Ordem_numeroCOM}                      xpath=//*[.='Dados da Ordem']/../../../../..//*[text()='Número da Ordem do COM']/../../../../..//input
${SOM_Ordem_numeroPedido}                   xpath=//a[.='Dados da Ordem']/../../../../..//*[text()='Número do Pedido']/../../../../..//tr//td//div//input
${SOM_Ordem_dtAberturaPedido}               xpath=//a[.='Dados da Ordem']/../../../../..//*[text()='Data de Abertura do Pedido']/../../../../..//tr//td//div//input
${SOM_Ordem_tipo}                           xpath=//a[.='Dados da Ordem']/../../../../..//*[text()='Tipo de Ordem']/../../../../..//tr//td//div//input
${SOM_Acesso_GPON}                          xpath=(//*[.='Dados da Ordem']/../../../../..//*[text()='Acesso GPON']/../../../../..//input)[1]
${SOM_btnUpdate}                            (//span[contains(.,'Update')])[1]/..

#Dados do Catálogo
${SOM_Classe_Produto}                       //a[.='Dados do Catálogo']/../../../../..//*[text()='Classe do Produto']/../../../../..//tr//td//div//input
${SOM_Habilitado}                           //a[.='Dados do Catálogo']/../../../../..//*[text()='Habilitado']/../../../../..//tr//td//div//input
${SOM_Termo_Contrato}                       //a[.='Dados do Catálogo']/../../../../..//*[text()='Termo de Contrato']/../../../../..//tr//td//div//input
${SOM_Codigo_Ativacao}                      //a[.='Dados do Catálogo']/../../../../..//*[text()='Código de Ativação']/../../../../..//tr//td//div//input

#Dados do Cliente
${SOM_Cliente_nome}                         xpath=//a[.='Dados do Cliente']/../../../../..//*[text()='Nome']/../../../../..//tr//td//div//input
${SOM_Cliente_tel1}                         xpath=//a[.='Dados do Cliente']/../../../../..//*[text()='Telefone de Contato 1']/../../../../..//tr//td//div//input
${SOM_Cliente_empresa}                      xpath=//a[.='Dados do Cliente']/../../../../..//*[text()='Empresa']/../../../../..//tr//td//div//input
${SOM_Cliente_idContrato}                   xpath=//a[.='Dados do Cliente']/../../../../..//*[text()='Id do Contrato']/../../../../..//tr//td//div//input
${SOM_Origem_Solicitacao}                   xpath=(//a[.='Dados da Ordem']/../../../../..//*[text()='Origem da Solicitação']/../../../../..//tr//td//div//input)[1]
${SOM_cliente_documento}                    xpath=//a[.='Dados do Cliente']/../../../../..//*[text()='Documento']/../../../../..//tr//td//div//input

#Dados do Agendamento
${SOM_Agendamento_dtInicio}                 xpath=//a[.='Dados de Agendamento']/../../../../..//*[text()='Data Início']/../../../../..//tr//td//div//input
${SOM_Agendamento_hrInicio}                 xpath=//a[.='Dados de Agendamento']/../../../../..//*[text()='Hora Início']/../../../../..//tr//td//div//input
${SOM_Agendamento_dtFim}                    xpath=//a[.='Dados de Agendamento']/../../../../..//*[text()='Data Fim']/../../../../..//tr//td//div//input
${SOM_Agendamento_hrFim}                    xpath=//a[.='Dados de Agendamento']/../../../../..//*[text()='Hora Fim']/../../../../..//tr//td//div//input

#Dados do Produto
${SOM_NomeDoProduto}                        xpath=//*[text()="Produto"]/../../../..//*[text()="Nome do Produto"]/../../../../..//input
${SOM_TecnologiaProduto}                    xpath=//*[text()="Produto"]/../../../..//*[text()="Tecnologia"]/../../../../..//input
${SOM_IdDoCatalogo}                         xpath=//*[text()="Produto"]/../../../..//*[text()="Id do Catálogo"]/../../../../..//input

#Dados do Endereco
${SOM_Endereco_tpLogradouro}                xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Tipo de Logradouro']/../../../../..//input
${SOM_Endereco_logradouro}                  xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Nome do Logradouro']/../../../../..//input
${SOM_Endereco_numero}                      xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Número da Porta']/../../../../..//input
${SOM_Endereco_bairro}                      xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Bairro']/../../../../..//input
${SOM_Endereco_cidade}                      xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Cidade']/../../../../..//input
${SOM_Endereco_uf}                          xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='UF']/../../../../..//input
${SOM_Endereco_cep}                         xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='CEP']/../../../../..//input
${SOM_Endereco_id}                          xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Id do Endereço']/../../../../..//input
${SOM_Endereco_inventory}                   xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Id do Endereço no Inventário']/../../../../..//input
${Som_Endereco_ref}                         xpath=//a[.='Dados dos Endereços']/../../../..//*[text()='Ponto de Referência']/../../../../..//input

#Recursos Lógicos
${SOM_CVLAN}                                //a[.='Recursos Lógicos']/../../../../..//*[text()='CVLAN']/../../../../..//tr//td//div//input
${SOM_SVLAN}                                //a[.='Recursos Lógicos']/../../../../..//*[text()='SVLAN']/../../../../..//tr//td//div//input
${SOM_QVLAN}                                //a[.='Recursos Lógicos']/../../../../..//*[text()='QVLAN']/../../../../..//tr//td//div//input
${SOM_CVLAN2}                               //a[.='Recursos Lógicos']/../../../../..//*[text()='CVLAN 2']/../../../../..//tr//td//div//input
${SOM_SVLAN2}                               //a[.='Recursos Lógicos']/../../../../..//*[text()='SVLAN 2']/../../../../..//tr//td//div//input
${SOM_QVLAN2}                               //a[.='Recursos Lógicos']/../../../../..//*[text()='QVLAN 2']/../../../../..//tr//td//div//input

#Bilhetes de Atividade
${SOM_Nome_Atividade}                       (//a[.='Bilhete de Atividade']/../../../../..//*[text()='Bilhete de Atividade']/../../../../..//tr//td//div//input)[1]
${SOM_Numero_BA}                            (//a[.='Bilhete de Atividade']/../../../../..//*[text()='Número do BA']/../../../../..//tr//td//div//input)[1]
${SOM_Codigo_Encerramento}                  (//a[.='Bilhete de Atividade']/../../../..//*[normalize-space()="Código de Encerramento"]//input)[1]
${SOM_BilheteAtividade_Observacoes}         (//a[.='Bilhete de Atividade']/../../../..//*[normalize-space()="Observações"]//textarea)[1]
${SOM_Matricula_Tecnico}                    //a[.='Bilhete de Atividade']/../../../../../..//label[normalize-space()='Matrícula do Técnico']/../../../..//input
${SOM_Equipamento_Extraviado}               //a[.='Bilhete de Atividade']/../../../../../../..//label[normalize-space()='Equipamento Extraviado']/../../../../..//select
${SOM_btn_AdicionarTecAuxiliar}             //a[.='Bilhete de Atividade']/../../../..//a[normalize-space()='A']
${SOM_Nome_TecAuxiliar}                     //a[.='Bilhete de Atividade']/../../../../../..//label[normalize-space()='Nome']/../../../../..//textarea
${SOM_Matricula_TecAuxiliar}                //a[.='Bilhete de Atividade']/../../../../../..//label[normalize-space()='Matrícula']/../../../../..//input

#Bilhetes de Atividade EDITOR
${inputMatriculaTecnico}                    //label[normalize-space()="Matrícula do Técnico"]/../../../..//input
${inputCodigoEncerramento}                  //*[normalize-space()="Bilhete de Atividade"]/../../..//*[normalize-space()="Código de Encerramento"]//input
${inputObservacoesBA}                       //*[normalize-space()="Bilhete de Atividade"]/../../..//*[normalize-space()="Observações"]//textarea


#Processo
${SOM_Processo_Id}                          (//a[.='Processo']/../../../../..//*[text()='Id']/../../../../..//tr//td//div//input)[1]
${SOM_Processo_Nome}                        (//a[.='Processo']/../../../../..//*[text()='Nome']/../../../../..//tr//td//div//input)[1]
${SOM_Processo_Status}                      (//a[.='Processo']/../../../../..//*[text()='Status']/../../../../..//tr//td//div//input)[1]

#Pedido completo com sucesso
${SOM_btn_query}                            //div[@id='TopIndex']//table[1]/..//img[@name='query_']
${SOM_input_ref}                            //blockquote[@id='resetzone']//table[1]/..//input[@name='/]reference_number_0']
${SOM_btn_search}                           (//input[contains(@type,'button')][contains(@title,'Search')])[1]
${SOM_linha_tarefa}                         //form[contains(@name,'queryResultsForm')]//table//table//table//table//tr
${SOM_order_state}                          //span[normalize-space()='Order State']/../../../../tr[2]/td[13]
${SOM_order_state_reparo}                   //span[normalize-space()='Order State']/../../../../tr[2]/td[9]
${SOM_btn_tres_pontos}                      //td[contains(@class,'tableAction')]//input[contains(@name,'move')]
${SOM_btn_edit_order}                       //input[contains(@onclick,'EditOrder()')]
${SOM_btn_change_taskState_status}          //html/body/ul/li[5]
${SOM_btn_assignedUser}                     //*[@id="assigned"]/select
${SOM_btn_selectAssigned}                   //input[contains(@value,'/OrderManagement/control/assignOrder')]
${SOM_btn_updateTaskName}                   //*[@id="Body"]/form/table[1]/tbody/tr/td/input[1]
${SOM_quantia_linhas_tarefas}               //a[normalize-space()='Tarefas List']//following::div[2]/div[@style="display:inline;"]
${SOM_linha_Status}                         /../../../../../../..//*[text()='Status']/../../../../..//tr//td//div//input
${SOM_linha_Descrição}                      /../../../../../../..//*[text()='Tipo de Encerramento']/../../../../..//tr//td//div//input
${SOM_linha_retorno}                        /../../../../../../..//*[text()='Código de Retorno']/../../../../..//tr//td//div//input

#Validação Pendência Tenant (7111)
${SOM_pendTenant_TA}                        (//*[text()="Tarefas"]/../../../../div[@class="windowContent"]//*[@value="TA - Tratar Pendência Tenant"])

#Validação Mudança Velocidade
${SOM_input_OrderId}                        xpath=//td[text()="Order ID"]/..//input[@id="/]order_seq_id_0"]
${SOM_vel_054}                              xpath=//a[text()="Tarefas"]/../../../..//*[@value="T054 - Alterar Velocidade - APC"]
${SOM_vel_055}                              xpath=//a[text()="Tarefas"]/../../../..//*[@value="T055 - Alterar Velocidade - NASS"]
${SOM_encerrado}                            xpath=//a[text()="Tarefas"]/../../../..//*[@value="T026 - Notificar Encerramento de Ordem"]
${SOM_infraType}                            xpath=//a[.='Dados da Ordem']/../../../../..//*[text()='Tipo de Infra']/../../../../..//tr//td//div//input
${SOM_NomeDoProdutoAdd}                     xpath=//*[text()="Produto"]/../../../../../..//*[text()="Nome do Produto"]/../../../../..//input
${SOM_TipoDeProdutoAdd}                     xpath=//*[text()="Produto"]/../../../../../..//*[text()="Tipo de Produto"]/../../../../..//input
${SOM_TecnologiaAdd}                        xpath=//*[text()="Produto"]/../../../../../..//*[text()="Tecnologia"]/../../../../..//input
${SOM_AcaoAdd}                              xpath=//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../..//*[text()="Atributo"]/../../../../../../../../../../../../../../../../div[5]//*[text()="Ação"]/../../../../..//input
${SOM_IdCatalogRemove}                      xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Id do Catálogo"]/../../../../..//input
${SOM_NomeDoProdutoRemove}                  xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Nome do Produto"]/../../../../..//input
${SOM_TipoDeProdutoRemove}                  xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Tipo de Produto"]/../../../../..//input
${SOM_TecnologiaRemove}                     xpath=//*[text()="Produto"]/../../../../../../div[1]//*[text()="Tecnologia"]/../../../../..//input
${SOM_AcaoRemove}                           xpath=//*[text()="Atributo"]/../../../../../../../../../../../../../../../../../../../../div[1]//*[text()="Atributo"]/../../../../../../../../../../../../../../../../div[5]//*[text()="Ação"]/../../../../..//input
${SOM_IdCatalogAdd}                         xpath=//*[text()="Produto"]/../../../../../..//*[text()="Id do Catálogo"]/../../../../..//input

#Validação última tarefa
${ultimaTarefaSOM}                          (//a[text()="Tarefas"])[last()]/../../../..//a[contains(text(),'Nome')]/../../../../..//input

#Validação Bloqueio
${SOM_bloq_043}                             xpath=//a[text()="Tarefas"]/../../../..//*[@value="T043 - Bloquear Banda Larga Total APC"]
${SOM_desblo_044}                           xpath=//a[text()="Tarefas"]/../../../..//*[@value="T044 - Desbloquear Banda Larga Total APC"]
${SOM_bloq_045}                             xpath=//a[text()="Tarefas"]/../../../..//*[@value="T045 - Bloquear Banda Larga - Parcial - NASS"]
${SOM_bloq_status}                          xpath=//div[@id="usuario_master_query_header"]//li[2]//span


#Query campo de pesquisa de:
${SOM_input_from}                           //blockquote[@id='resetzone']//table[1]/..//input[@name='/]reference_number_0']
${SOM_input_orderID}                        //blockquote[@id='resetzone']//table[1]/..//input[@name='/]order_seq_id_0']
${SOM_order_type}                           //span[normalize-space()='Order State']/../../../../tr[2]/td[14]
${SOM_taskname}                             //span[normalize-space()='Task Name']/../../../../tr[2]/td[12]
${SOM_process}                              //span[normalize-space()='Process']/../../../../tr[2]/td[16]
${Order_Type_SOM}                           //span[normalize-space()='Order State']/../../../../tr[2]/td[7]



${SOM_Customer_Name}                        //a[.='Dados da Ordem']/../../../..//*[text()="Origem da Solicitação"]/../../../../..//input
${SOM_Tipo_Ordem}                           //a[.='Dados da Ordem']/../../../..//*[text()="Tipo de Ordem"]/../../../../..//input
${SOM_Numero_Pedido}                        //a[.='Dados da Ordem']/../../../..//*[text()="Número do Pedido"]/../../../../..//input
${SOM_UF}                                   //a[.='Dados dos Endereços']/../../../..//*[text()="UF"]/../../../../..//input
${SOM_CEP}                                  //a[.='Dados dos Endereços']/../../../..//*[text()="CEP"]/../../../../..//input
${SOM_Numero_SA}                            //a[.='Bilhetes de Atividade']/../../../..//*[text()="Número do BA"]/../../../../..//input
${SOM_Tipo_Complemento_1}                   //a[.='Dados dos Endereços']/../../../..//*[text()="Tipo de Complemento 1"]/../../../../..//input
${SOM_Complemento_1}                        //a[.='Dados dos Endereços']/../../../..//*[text()="Complemento 1"]/../../../../..//input
${SOM_Atributo_Acao}                        (//a[.='Atributo List']/../../../..//*[text()="Ação"]/../../../../..//input)[1]
${SOM_Header_OrderID}                       //ul[@class="oeHeaderList"]//li[contains(text(),"Order ID")]//span

${SOM_Pendencia_Nome}                       (//a[.='Tarefas']/../../../..//*[text()="Nome"]/../../../../..//input)[12]
${SOM_Pendencia_Grupo}                      (//a[.='Informação de Dados de Pendência']/../../../..//*[text()="Grupo da Pendencia"]/../../../../..//input)
${SOM_Pendencia_Valor}                      //a[normalize-space()='Dados de Pendência']/../../../..//a[normalize-space()='Pendência']/../../../../..//input

${SOM_Ordem_Block}                          //*[text()="Dados da Ordem"]/../../../../div[@class="windowContent"]
${SOM_Tarefa_Block}                         //*[text()="Histórico de Tramitação"]/../../../../div[@class="windowContent"]


#CONSULTA
${ValorOrderId}                             //li[@class='noDecorate readonly'][contains(.,'Order ID')]//span[@class='value']

#Tramitação de reparo 
${LupaResultadoAnalise}                     //span[.='Analise do Chamado Tecnico']/../../..//label[normalize-space()='Resultado da Análise']/../../../..//a//img
${ButtonONTDesconfigurada}                  //input[contains(@onclick,'ONT - Desconfigurada/Divergente')]
${SelectTipoMotivo}                         //*[normalize-space()="Tipo Motivo"]/../../../..//select[@class="oeValueNode"]
${CaixaTextMotivo}                          //span[.='Analise do Chamado Tecnico']/../../..//label[normalize-space()='Motivo']/../../../..//textarea
${LupaMotivo}                               //span[.='Analise do Chamado Tecnico']/../../..//label[normalize-space()='Motivo']/../../../..//a//img[@alt="Find"]
${ButtonMotivoReparo}                       //input[contains(@onclick,'Acao interna realizada na Vtal: Efetuada configuracao rede wi-fi (canal/criptografia/senha). | Acao a ser realizada pela Tenant: Verificar normalizacao com cliente e realizar novo teste. Certificar que dispositivo do cliente e compativel para com o servico/velocidade.')]

#EDITOR
${inputNumeroSerie}                         //label[normalize-space()='Número de Série']/../../../..//input
${inputCodigoEquipamento}                   //label[normalize-space()='Código do Equipamento']/../../../..//textarea
${lupaEquipamento}                          //img[@src='/OrderManagement/images/oefind.gif']
${selectStatus}                             (//select[@id='completionStatusList'])[1]
${btnUpdate}                                (//button[@id='completeTaskButton'])[1]
${addTecnicoAuxiliar}                       //span[normalize-space()="Técnico Auxiliar List"]/../..//a[@class='addGroupIcon']
${inputNomeTecnicoAux}                      //span[normalize-space()="Técnico Auxiliar"]/../../..//label[normalize-space()="Nome"]/../../../..//textarea
${inputMatriculaTecnicoAux}                 //span[normalize-space()="Técnico Auxiliar"]/../../..//label[normalize-space()="Matrícula"]/../../../..//input

#CHANGE STATE/STATUS
${selectUsuarios}                           //select[@class='input']
${radioBtnAssociar}                         //input[@type='radio']
${inputUpdateAssociar}                      //input[@value='Update']

#Solicitar Troca de CDOE
${SOM_CDOE_Nova}                            //span[.='Dados de Solicitação de Troca de CDOE']/../../../..//*[normalize-space()='CDOE Nova']/../../../../..//tr//td//div//textarea
${SOM_MatriculaTecnicoSolicitante}          //span[.='Dados de Solicitação de Troca de CDOE']/../../../..//*[normalize-space()='Matrícula do Técnico Solicitante']/../../../../..//tr//td//div//textarea

#PROCESS HISTORY
${SOM_Detailed_Table}                       iframe[src="/OrderManagement/processhistory"] >>> (//li[@id="ui-id-5"]//*[normalize-space()="Detailed Table"])[1]
${SOM_Task_DesconfigVoipIMS}                iframe[src="/OrderManagement/processhistory"] >>> (//div[@id="componentDemoContent"]/..//span[normalize-space()="TA - Desconfigurar VoIP IMS (SP - Desconfigurar VoIP IMS)"])[3]