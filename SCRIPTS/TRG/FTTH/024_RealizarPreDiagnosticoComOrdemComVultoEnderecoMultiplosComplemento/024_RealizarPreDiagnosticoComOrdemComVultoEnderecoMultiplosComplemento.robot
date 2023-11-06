*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: subscriberid
    ...                                     OUTPUT: 

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/024_RealizarPreDiagnosticoComOrdemComVultoEnderecoMultiplosComplemento.xlsx


*** Test Cases ***
24.01 - Gerar Token de Acesso
    Retornar Token Vtal

24.02 - Realizar configuração na ferramenta de mock    
    Alterar Campo no NETQ                   CAMPO=VULTOATIVO                        VALOR=INVENTORY_18                      RESET_JSON=SIM                        

24.03 - Realizar pre-diagnostico 
    Realizando PreDiagnostico
    
24.04 - Validar retorno do pre-diagnostico no Microserviços
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT         XML    INVOKE - Request enviado para a ClienteCo        state                   state
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado para a ClienteCo        type                    preDiagnostic
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço                     msg:Description         Sucesso

