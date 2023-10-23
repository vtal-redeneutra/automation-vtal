*** Settings ***
Documentation  arquivo de objetos/xpath do App OPM

*** Variables ***
#====================================================================================================================================
#PAGE OBJECTS
#====================================================================================================================================
# LOGIN PAGE
${notificacao_carregando}                   //android.widget.TextView[@text="Carregando informações. Por favor aguarde..."]
${input_matricula_opm}                      //android.widget.EditText[@resource-id="inputMatricula"]
${input_senha_opm}                          //android.widget.EditText[@resource-id="inputPassword"]
${input_captcha_opm}                        //android.widget.EditText[@resource-id="textVerificacao"]
${btn_login_opm}                            //android.widget.Button[@text="efetuar login"]
${form_login}                               //android.view.View[@resource-id="IDPLogin"]
${msg_erro_captcha}                         //android.widget.TextView[@text="A autenticação falhou. Por favor verifique se todos os campos foram informados corretamente."]

#PAGE 1
${txt_nome}                                 //android.widget.TextView[@resource-id="p-engineerName-start-journey"]
${btn_start_journey}                        //android.widget.Button[@resource-id="start-journey-button"]
${btn_menu}                                 //android.widget.Button[@resource-id="button-menu-toggle"]
${btn_menu_encerrar_jornada}                //android.widget.Button[@text="alarm Encerrar jornada"]
${select_motivo_jornada}                    //android.view.View[@text="Motivo"]
${select_motivo_logout}                     //android.widget.RadioButton[@text="Logout"]
${btn_encerrar_jornada}                     //android.widget.Button[@text="ENCERRAR JORNADA"]
${btn_encerrar_sim}                         //android.widget.Button[@text="SIM"]

#PAGE 2
${btn_ba}                                   xpath=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.webkit.WebView/android.webkit.WebView/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.view.View[2]/android.view.View[2]/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[1]/android.widget.Image

#PAGE 3
${btn_menu_acoes}                           //android.view.View[@resource-id="tab-t0-2"]
${btn_atualizar_status}                     //android.view.View[@resource-id="finish-journey-div-button"]
${btn_fechar_alerta}                        //android.widget.Button[@text="FECHAR" and @enabled="true"]
${btn_voltar}                               //android.widget.Button[@text="arrow back"]

#PAGINA ATUALIZAR FACILIDADES
${btn_atualizar_facilidades}                //android.view.View[@text="Atualizar Facilidade"]
${input_cabo_riser}                         //android.view.View[@resource-id="input-facilities-0"]//android.widget.EditText
${input_cabo_drop}                          //android.view.View[@resource-id="input-facilities-1"]//android.widget.EditText
${input_cdoia}                              //android.view.View[@resource-id="input-facilities-2"]//android.widget.EditText
${btn_salvar_facilidades}                   //android.widget.Button[@resource-id="button-save-facilities"]

#PAGINA CONSUMO EQUIPAMENTOS
${btn_consumo_equipamentos}                 //android.view.View[@text="Consumo Equipamentos"]
${btn_editar_equipamento}                   //android.widget.Button[@text="Editar"]
${btn_equipamento}                          //android.view.View[@resource-id="add-equipment-equipment"]
${input_pesquisa_equipamento}               xpath=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.webkit.WebView/android.webkit.WebView/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View[2]/android.view.View/android.widget.EditText 
${select_equipamento_opm}                   //android.view.View[@text="ONT G-1425-GA NOKIA 2GHZ/5GHZ"]/..
${select_equipamento_opm_bit}               //android.view.View[@text="700131 - ONT TIM SAGEM FAST5670 WI-FI 6c"]/..
${btn_equip_fixo}                           //android.view.View[@resource-id="search-item-0"]
${numero_serie_OPM}                         //android.view.View[@resource-id="input-equipment-ftth-serial-number"]//android.widget.EditText
${btn_comodo}                               //android.view.View[@text="Cômodo"]
${select_comodo}                            //android.widget.RadioButton[@text="Quarto 1"]
${btn_associar}                             //android.widget.Button[@resource-id="button-associate-equipment"]
${btn_ok}                                   //android.widget.Button[@text="OK"]
${btn_extraviado}                           //android.view.View[@text="Extraviado"]
${radio_extraviado_nao}                     //android.widget.RadioButton[@text="Não"]
${radio_extraviado_sim}                     //android.widget.RadioButton[@text="Sim"]
${input_extraviado}                         //android.view.View[@text="Motivo de não devolução"]/..//android.widget.EditText
${btn_salvar_equipamento}                   //android.widget.Button[@text="SALVAR"]

#PAGINA CONSUMO MATERIAIS
${btn_consumo_materiais}                    //android.view.View[@text="Consumo Materiais"]
${btn_adicionar_materiais}                  //android.widget.Button[@resource-id="add-material-button"]
${select_acao}                              //android.view.View[@text="Ação"]
${radio_acao_adicionar}                     //android.widget.RadioButton[@text="Adicionar"]
${radio_acao_retirar}                       //android.widget.RadioButton[@text="Retirar"]
${btn_adicionar_grupo}                      //android.view.View[@resource-id="add-material-group"]
${input_pesquisa_grupo}                     xpath=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.webkit.WebView/android.webkit.WebView/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View[2]/android.view.View/android.widget.EditText 
${select_grupo}                             //android.view.View[@resource-id="search-item-0"]
${btn_adicionar_material}                   //android.view.View[@resource-id="add-material-material"]
${input_pesquisa_material}                  xpath=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.webkit.WebView/android.webkit.WebView/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View[2]/android.view.View/android.widget.EditText
${select_material}                          //android.widget.TextView[@text="10815_FECHO AÇO INOX 3/4"]
${select_material_retirada}                 //android.widget.TextView[@text="ADAPTADOR DE TOMADA NOVA X ANTIGA 20A"]
${input_material_quantidade}                //android.view.View[@resource-id="select-quant"]//android.widget.EditText
${btn_salvar_materiais}                     //android.widget.Button[@resource-id="continue-button-add-material"]

#PAGINA AUXILIAR
${btn_auxiliar}                             //android.view.View[@text="Auxiliar"]
${select_auxiliar}                          //android.view.View[@resource-id="need-assistant-select"]
${select_auxiliar_nao}                      //android.widget.RadioButton[@text="Não"]
${btn_salvar_auxiliar}                      //android.widget.Button[@text="SALVAR"]
${select_ajuda}                             //android.view.View[@resource-id="need-assistant-select"]
${select_ajuda_sim}                         //android.widget.RadioButton[@text="Sim"]
${btnAuxiliar}                              //android.view.View[@text="Auxiliar"]

#PAGINA AUXILIAR - CASO SIM 
${matricula_auxiliar01}                     //android.view.View[@text="Matricula Auxiliar 1"]/..//android.widget.EditText
${observacao01}                             xpath=(//android.view.View[@text="Observação"]/..//android.widget.EditText)[1]
${matricula_auxiliar02}                     //android.view.View[@text="Matricula Auxiliar 2"]/..//android.widget.EditText
${observacao02}                             xpath=(//android.view.View[@text="Observação"]/..//android.widget.EditText)[2]

                                            
${btn_finalizar_jornada}                    //android.widget.Button[@resource-id="finish-journey-button"]

#PAGINA ENCERRAMENTO
${input_codigo_encerramento_opm}            //android.view.View[@resource-id="input-code-overview"]//android.widget.EditText
${input_RSR_opm}                            //android.view.View[@resource-id="input-RSR-overview"]//android.widget.EditText
${input_senha_encerramento_opm}             //android.view.View[@resource-id="input-password-overview"]//android.widget.EditText
${input_obs_encerramento_opm}               //android.view.View[@text="Observação"]/..//android.widget.EditText
${btn_salvar_obs}                           //android.widget.Button[@text="Salvar"]
${btn_ok_obs}                               //android.widget.Button[@text="OK"]
${btn_overview_finaliza}                    //android.widget.Button[@resource-id="button-overview-finish"]
${dialog_encerrar_sim}                      //android.app.Dialog[@text="Alerta!"]//android.widget.Button[@text="SIM"]
${btnCodPlatExt}                            //android.view.View//android.widget.Button[@text="Plat.Ext.(HC)-Amb. Cli - ONT arrow forward"]
${btnCodOutrosSub}                          //android.view.View//android.widget.Button[@text="Outros - Substituído arrow forward"]
${btnTodosOsProdutos}                       //android.view.View//android.widget.Button[@text="Todos os produtos arrow forward"]
${btnProcurarCodigo}                        //android.view.View//android.widget.Button[@text="Não sabe o código? Clique aqui!"]

#MENSAGEM DE LOADING
${loading}                                  //android.view.View[@text="Por favor aguarde..."]
#====================================================================================================================================

#END PAGE OBJECTS
#====================================================================================================================================
#====================================================================================================================================