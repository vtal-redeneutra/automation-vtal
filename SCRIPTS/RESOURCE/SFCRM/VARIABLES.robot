*** Settings ***
Documentation                               Arquivo de variaveis do SFCRM


*** Variables ***
#===================================================================================================================================================================
#VARIABLES
#===================================================================================================================================================================
${URL_SF}                                   https://oimoveltrialorg2021--trg.my.salesforce.com/
${TIMEOUT}                                  50s

${input_username}                           //*[@id="username"]
${input_password}                           //*[@id="password"]
${btn_login_sales}                          //input[@id='Login']

${pesquisar}                                //button[@type='button'][contains(.,'Pesquisar...')]
