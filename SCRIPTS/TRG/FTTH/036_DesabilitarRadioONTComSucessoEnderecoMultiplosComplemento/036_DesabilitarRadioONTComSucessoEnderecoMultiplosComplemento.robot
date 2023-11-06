*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/036_DesabilitarRadioONTComSucessoEnderecoMultiplosComplemento.xlsx


*** Test Cases ***

36.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   RESET_JSON=SIM

36.02 - Gerar Token de Acesso
    Retornar Token Vtal

36.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

36.04 - Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

36.05 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
36.06 - Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code

36.07 - Desabilitar o rádio da ONT com sucesso
    Configuracao Remota                                                             HGW_WIFI_DISABLE                        frequencyBand

36.08 - Validar a Notificação após a Desabilitação
    Valida Configuracao Remota                                                      HGW_WIFI_DISABLE

36.09 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

36.10 - Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state
36.11 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

36.12 - Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code