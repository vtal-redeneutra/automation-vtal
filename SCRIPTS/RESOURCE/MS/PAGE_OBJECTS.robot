*** Settings ***
Documentation                               Arquivo de objetos/xpath do PORTAL Microserviços


*** Variables ***

###### Tela de Login ######

${userInput}                             //input[@id="user"]
${passInput}                             //input[@id="pass"]
${loginButtonMS}                         //button[@type="submit"]

###### Logout ######

${dropArrowSair}                        (//p[contains(text(),"Olá")]/../..//button)[1]
${buttonSair}                           (//p[contains(text(),"Olá")]/../..//button)[2]

###### Página de Pesquisa ######

${inputTermo}                          //input[@placeholder="Termo"]
${buttonSearch}                        //button[text()="Pesquisar"]
