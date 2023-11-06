*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario



Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SALESFORCE}/UTILS.robot
Resource                                    ${DIR_PORTALECARE}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0048_CriarOrganizacaoCPSalesforce/ROB0048_CriarOrganizacaoCPSalesforce.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/202_ValidarClientePortalE-Care.xlsx

*** Test Cases ***
202.01 - Realizar acesso ao Salesforce
   Acesso ao portal pelo Salesforce

202.02/03 - Realizar Acesso a Caixa de E-mail
   Acessar e criar senha no Youmail

202.04 - Realizar Acesso ao Portal E-care
   Valida contato no portal E-care


