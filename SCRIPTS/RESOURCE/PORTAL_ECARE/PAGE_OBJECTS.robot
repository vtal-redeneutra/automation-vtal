*** Settings ***
Documentation                               Arquivo de objetos/xpath Portal E-Care


*** Variables ***
#Login
${buttonFazerLoginSSO}                      //div[@id="idp_section_buttons"]//button
${usuarioPortal}                            //input[@title="Insira seu ID de usuário"]
${senhaPortal}                              //input[@title="Insira sua senha"]
${buttonEntrar}                             //button[@id="submit"]


# validação de contato dentro do portal
${buttonMeuPerfil}                          //button[@class="profile-menuTrigger"]
${PerfilContato}                            //ul[@class="scrollable"]/..//li[@class="profile-menuItem profile uiMenuItem"]
${buttonTresPontos}                         //button[@class="forceCommunityThemeNavTrigger"]
${buttonContratoECare}                      //nav[@class="jepsonInnerHeader commThemeCmp comm-navigation themeNavContainer navMenuType-panel alignPanel-left forceCommunityThemeNav doneRendering"]/..//li[@class="mainNavItem comm-navigation__top-level-item comm-navigation__menu-item"][contains(.,'Contratos')]
${validaEmailContato}                       //a[@class="emailuiFormattedEmail"]
${validaNomeContato}                        //a[@class="emailuiFormattedEmail"]
${setaMeusContratos}                        //button[@title="Selecionar um modo de exibição de lista: Contratos"]
${optionTodosContratos}                     //div[@class="list uiAbstractList forceVirtualAutocompleteMenuList"]//a[@role="option"][contains(.,'Todos os contratos ativados')]
${validaNomeConta}                          //a[@class="textUnderline outputLookupLink slds-truncate outputLookupLink-0018G00000W6HdGQAV-11:3885;a forceOutputLookup"]
