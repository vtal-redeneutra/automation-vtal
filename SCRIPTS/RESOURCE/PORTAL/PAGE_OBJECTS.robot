*** Settings ***
Documentation                               Arquivo de objetos/xpath do PORTAL Operacional


*** Variables ***

###### Tela de Login ######

${userInput}                             //input[@id="user"]
${passInput}                             //input[@id="pass"]
${loginButtonPortal}                     //button[@id="submit"]

###### Logout ######

${dropArrowSair}                        //i[@role="presentation"][@class="q-icon notranslate material-icons q-btn-dropdown__arrow q-btn-dropdown__arrow-container"]
${buttonSair}                           //span[contains(text(),"Sair")]

###### Página Ordens de Serviço ######

#-- Nova OS --
${novaOS}                                //div[@class="q-tab__label"][contains(text(),"Nova OS")]
${selectTipoOrdem}                       //div[@class="q-field__label no-pointer-events absolute ellipsis"][contains(text(),"Tipo")]/..
${caixaEndereco}                         //input[@aria-label="Endereço"]
${inputCEP}                              //input[@aria-label="Endereço ou CEP *"]
${inputNumero}                           //input[@aria-label="Número *"]
${buttonBuscar}                          (//span[@class="block"][contains(text(),"Buscar")])[1]  
${resultadoEndereco}                     //div[contains(text(),"resultado")]/..//div[@class="q-item__section column q-item__section--main justify-center"]
${inputReferencia}                       //input[@aria-label="Ponto de referência"]
${buttonViabilidade}                     //span[@class="block"][contains(text(),"Analisar viabilidade")]
${buttonAgenda}                          //span[@class="block"][contains(text(),"Ver agenda")]
${inputNome}                             //input[@aria-label="Nome *"]
${inputCelular}                          //input[@aria-label="Telefone *"]
${inputCasaId}                           //input[@aria-label="ID da Casa Conectada *"]

#-- Lista de Ordens de Serviço
${searchId}                              //input[@placeholder="Pesquisar ID"]
${linkDataAgendamento}                   //span[contains(text(),"Agendado para")]/../div//span
${botaoCirculoAmarelo}                   //i[@role="presentation"][contains(text(),"close")]/../../../..
${botaoCirculoCancelar}                  //i[@role="presentation"][contains(text(),"cancel")]/../../.. 
${botaoRefresh}                          //i[@role="img"][contains(text(),"refresh")]       