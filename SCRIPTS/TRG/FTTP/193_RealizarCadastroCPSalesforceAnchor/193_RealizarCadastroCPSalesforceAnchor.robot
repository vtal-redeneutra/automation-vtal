*** Settings ***


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SALESFORCE}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0048_CriarOrganizacaoCPSalesforce/ROB0048_CriarOrganizacaoCPSalesforce.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/193_RealizarCadastroCPSalesforceAnchor.xlsx


*** Test Cases ***

193.01/05 - Criar Organização para CPs no Salesforce
    Criar Organizacao para CP

193.06/07 - Cadastro de CP no Salesforce - Conta Comercial ou Conta Serviço
    Cadastro de CP no Salesforce

193.08/09 - Criar Contato de uma CP no Salesforce
   Criar Contato de CP no Salesforce

193.10/15- Criar Oportunidade de uma CP no Salesforce
    Criar Oportunidade de uma CP no Salesforce                                      cenarioAtual=Anchor        

193.16/27 - Gerar Contrato Principal 
   Gerar um contrato principal na CP

193.28/33 - Configurar Oportunidade
    Configurar a Oportunidade na CP