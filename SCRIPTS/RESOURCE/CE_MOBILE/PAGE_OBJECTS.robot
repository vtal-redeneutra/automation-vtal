*** Settings ***
Documentation  arquivo de objetos/xpath do App OPM

*** Variables ***
#====================================================================================================================================
#PAGE OBJECTS
#====================================================================================================================================
#PRIMEIRA TELA CE_MOBILE

${Resource_Padrao}                          pt.ptinovacao.nwosp.cemobilea:id/

${Criar_Survey_1UC}                         //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_I_criarMoradias"]
${Criar_Survey_Multi_UC}                    //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_I_criarEdificios"]

${Button_Mapa_1UC}                          //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_IC_CR_mapa"]
${Button_Mapa_Multi_UC}                     //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_IE_E_mapa"]
${Button_OK}                                //android.widget.Button[@text="OK"]
${Button_Opcoes}                            //android.widget.Button[@text="Opções"]
${Text_Escolher_Mapa}                       //android.widget.TextView[@text="Escolher Mapa"]
${Button_Adicionar_Mapa}                    //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_map_open"]
${Pasta_CE_Mobile}                          //android.widget.TextView[@text="CE-Mobile"]
${Pasta_CE_Mobile_Maps}                     //android.widget.TextView[@text="maps"]
${Arquivo_Mapa}                             //android.widget.TextView[contains(@text,".mbtiles")]
${Button_Confirmar_Mapa}                    //android.widget.Button[@text="Sim"]
${Button_Mapa_Aceitar}                      //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_googleMap_ok"]
${Button_Exportar_Levantamento}             //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_I_exportar"]
${Button_Exportar_Confirmar}                //android.widget.Button[@text="Sim"]

#CRIAR SURVEY 1UC PRIMEIRA ABA
${Spinner_Zona}                             //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_IC_CR_bairro"]
${Spinner_Opcao_01}                         //android.widget.CheckedTextView[@text="CE-MES-06-18"]
${Input_Pisos}                              //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_IC_CR_nPisos"]
${Radio_Residencia}                         //android.widget.RadioButton[@text="Residência"]
${Radio_Edificacao_Completa}                //android.widget.RadioButton[@text="Edificação Completa"]
${Input_Cep}                                //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_Morada_filtroCEP"]
${Input_Numero}                             //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_Morada_fachada"]
${Input_Logradouro}                         //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/AutoCompleteTextView_Morada_logradouroExistente1"]
${Spinner_Tipo_Complemento}                 //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_Morada_complemento1"]
${Spinner_Selecionado}                      //android.widget.CheckedTextView[@resource-id="android:id/text1" and @selected="true"]
${Input_Complemento}                        //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_Morada_complemento1"]
${Spinner_Nome_Imovel}                      //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_Morada_tipoImovel"]
${Spinner_Nome_Imovel_Valor}                //android.widget.CheckedTextView[@text="Academia"]
${Input_Nome_Imovel}                        //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_Morada_tipoImovel"]
${Button_Pagina_Inicial}                    //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_IC_CR_paginaInicial"]
${Button_Pagina_Inicial_Sim}                //android.widget.Button[@text="Sim"]
${Input_Logradouro_1UC}                     //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/AutoCompleteTextView_Morada_logradouroExistente1"]

#SEGUNDA ABA 1UC
${Segunda_Aba_1UC}                          //android.widget.TextView[@text="Outras Informações"]
${Spinner_Nome_Survey}                      //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_OI_CR_empresa"]
${Spinner_Nome_Survey_Valor}                //android.widget.CheckedTextView[@text="SEREDE SA"]
${Spinner_Survey_Tecnico}                   //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_OI_CR_tecnico"]
${Spinner_Survey_Tecnico_Valor}             //android.widget.CheckedTextView[@text="SUELLEN ALVES"]
${Button_Finalizar}                         //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_OI_CR_finalizar"]
${Button_Finalizar_Ok}                      //android.widget.Button[@text="OK"]

#PRIMEIRA ABA MULTI UC
${Spinner_Zona_Multi_UC}                    //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_IE_E_bairro"]                
${Radio_Completo}                           //android.widget.RadioButton[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/RadioButton_IE_E_completo"]
${Button_Pagina_Inicial_Multi_UC}           //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_IE_E_paginaInicial"]

#SEGUNDA ABA MULTI UC
${Tab_Caixa_Entrada}                        //android.widget.TextView[@text="Caixa de Entrada Interna"]
${Input_Pisos_Multi_UC}                     //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_PTR_numeroAndar"]
${Spinner_Divisão_Interna}                  //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_PTR_divisaoInterna"]
${Input_Divisão_Interna}                    //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_PTR_divisaoInterna"]
${Spinner_Localizacao}                      //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_PTR_localizacao"]
${Spinner_Localizacao_Valor}                //android.widget.CheckedTextView[@text="Sala Técnica (Dentro da Própria Edificação)"]
${Spinner_Tipo_Acesso}                      //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_PTR_tipoEntradaCabo"]
${Spinner_Tipo_Acesso_Valor}                //android.widget.CheckedTextView[@text="Subterrânea"]
${Spinner_Espaco_FO}                        //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_PTR_espacoFo"]
${Spinner_Espaco_FO_Valor}                  //android.widget.CheckedTextView[@text="Maior que 2 cm"]
${Input_Comprimento}                        //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_PTR_comprimentoCabo"]
${Button_Comprimento_Add}                   //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_PTR_criarCabo"]
${Spinner_Modelo_CDOI}                      //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_PTR_modeloCDOI"]
${Spinner_Modelo_CDOI_Valor}                //android.widget.CheckedTextView[@text="24 / 346 x 255 x 115 / CDOI 24 SC-APC (GENÉRICO)"]
${Button_Modelo_CDOI_Add}                   //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_PTR_criarCDOI"]
${Input_Altura}                             //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_PTR_altura"]
${Input_Largura}                            //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_PTR_largura"]
${Input_Profundidade}                       //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_PTR_profundidade"]
${Button_Caixa_Entrada_Adicionar}           //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_PTR_adicionarPTR"]
${Spinner_Caixa_Entrada}                    //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_PTR_PTRs"]
${Spinner_Caixa_Entrada_Valor}              //android.widget.CheckedTextView[@text="1 ( Piso: 1 )"]


#TERCEIRA ABA MULTI UC
${Tab_Prumada}                              //android.widget.TextView[@text="Prumada"]
${Spinner_CEI}                              //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_P_PTR"]
${Spinner_CEI_Valor}                        //android.widget.CheckedTextView[@text="1 ( Piso: 1 )"]
${Spinner_Prumada_Divisão_Interna}          //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_P_divisaoInterna"]
${Input_Prumada_Divisão_Interna}            //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_P_divisaoInterna"]
${Input_Deslocamento_Horizontal}            //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_P_afastamento"]
${Radio_Atendimento}                        //android.widget.RadioButton[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/RadioButton_P_atendimentoPontoAPonto"]
${Spinner_Prumada_Espaco_FO}                //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_P_espacoFo"]
${Spinner_Prumada_Espaco_FO_Valor}          //android.widget.CheckedTextView[@text="Maior que 2 cm"]
${Input_Piso_Logico_Inicio}                 //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_D_pisoLogicoInicial"]
${Input_Piso_Logico_Final}                  //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_D_pisoLogicoFinal"]
${Input_Piso_Real_Inicio}                   //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_D_pisoRealInicial"]
${Input_Piso_Real_Final}                    //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_D_pisoRealFinal"]
${Radio_Andar}                              //android.widget.RadioButton[@text="Andar"]
${Radio_Destinacao}                         //android.widget.RadioButton[@text="Residência"]
${Radio_Tipo_Complemento}                   //android.widget.RadioButton[@text="Apartamento"]
${Spinner_Prumada_Complemento}              //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_D_complemento"]
${Spinner_Prumada_Complemento_Valor}        //android.widget.CheckedTextView[@text="Texto"]
${Input_Prumada_Complemento}                //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_D_argumentoComplemento"]
${Button_Complemento_Add}                   //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_D_criarArgumentoComplemento"]
${Spinner_Confirmacao_Complemento}          //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_D_ucs"]
${Spinner_Confirmacao_Complemento_Valor}    //android.widget.CheckedTextView[@text="[0] AP 101"]
${Button_Criar}                             //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_D_criarPiso"]
${Button_Adicionar}                         //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_P_adicionarPrumada"]
${Spinner_Prumada}                          //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_P_prumadas"]
${Spinner_Prumada_Valor}                    //android.widget.CheckedTextView[@text="1 ( CEI: 1 )"]
${Button_Salvar}                            //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_P_editarPrumada"]

#QUARTA ABA MULTI UC
${Tab_Caixa_Piso}                           //android.widget.TextView[@text="Caixa de Piso"]
${Spinner_Caixa_Piso_Prumada}               //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_CA_prumada"]
${Spinner_Caixa_Piso_Prumada_Valor}         //android.widget.CheckedTextView[@text="1 ( CEI: 1 )"]
${Input_Caixa_Piso}                         //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_CA_numeroAndar"]
${Spinner_Modelo_CDOIA}                     //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_CA_modeloCDOI"]
${Spinner_Modelo_CDOIA_Valor}               //android.widget.CheckedTextView[@text="16 / 200 x 126 x 50 / CDOIA 16 (FURUKAWA)"]
${Button_Modelo_CDOIA_Add}                  //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_CA_criarCDOI"]
${Input_Caixa_Piso_Altura}                  //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_CA_altura"]
${Input_Caixa_Piso_Largura}                 //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_CA_largura"]
${Input_Caixa_Piso_Profundidade}            //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_CA_profundidade"]
${Button_Caixa_Piso_Add}                    //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_CA_adicionarCaixa"]
${Spinner_Caixa_Piso}                       //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_CA_caixas"]
${Spinner_Caixa_Piso_Valor}                 //android.widget.CheckedTextView[@text="1 ( Prumada: 1 ; Piso: 1 )"]
${Button_Caixa_Piso_Salvar}                 //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_CA_editarCaixa"]


#QUINTA ABA MULTI UC
${Tab_Outras_Infos}                         //android.widget.TextView[@text="Outras Informações"]
${Input_Nome}                               //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_OI_responsavel"]
${Input_Telefone}                           //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_OI_telefone"]
${Input_Email}                              //android.widget.EditText[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/EditText_OI_email"]

#FOTOS GERAL
${Text_Foto_Nome}                           //android.widget.TextView[@text="imagem.jpg"]
${Text_Foto_Nome_OK}                        //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_Imageviewer_ok"]
${Button_Foto__OK}                          //android.widget.Button[@text="OK"]

#FOTO INTERIOR
${Button_Foto_Interior}                     //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_OI_carregarFotoInterior"]
${Pasta_DCIM}                               //android.widget.TextView[@text="DCIM"]
${Pasta_SharedFolder}                       //android.widget.TextView[@text="SharedFolder"]

#FOTO EXTERIOR
${Button_Foto_Exterior}                     //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_OI_carregarFotoExterior"]

#FOTO FACHADA
${Button_Foto_Fachada}                      //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_OI_carregarFotoFachada"]


${Spinner_Survey_Nome}                      //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_OI_empresa"]
${Spinner_Survey_Nome_Valor}                //android.widget.CheckedTextView[@text="SEREDE SA"]
${Spinner_Tecnico_Multi_UC}                 //android.widget.Spinner[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Spinner_OI_tecnico"]
${Spinner_Tecnico_Multi_UC_Valor}           //android.widget.CheckedTextView[@text="SUELLEN ALVES"]
${Button_Outras_Info_Finalizar}             //android.widget.Button[@resource-id="pt.ptinovacao.nwosp.cemobilea:id/Button_OI_finalizar"]
${Button_Outras_Info_Finalizar_OK}          //android.widget.Button[@text="OK"]




