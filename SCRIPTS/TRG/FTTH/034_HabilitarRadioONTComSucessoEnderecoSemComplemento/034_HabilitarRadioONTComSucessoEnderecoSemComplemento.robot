*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/034_HabilitarRadioONTComSucessoEnderecoSemComplemento.xlsx


*** Test Cases ***

34.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   RESET_JSON=SIM

34.02 - Gerar Token de Acesso
    Retornar Token Vtal

34.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

34.04 - Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

34.05 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
34.06 - Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code

34.07 - Habilitar o rádio da ONT com sucesso
    Configuracao Remota                                                             HGW_WIFI_ENABLE                        frequencyBand

34.08 - Validar a Notificação após a Habilitação 
    Valida Configuracao Remota                                                      HGW_WIFI_ENABLE

34.09 - Realização do Pré Diagnóstico após solicitação do reboot
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

34.10 - Validação do Pré diagnóstico no FW Console após solicitação do reboot
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

34.11 - Realização de Diagnóstico após solicitação do reboot
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
34.12 - Validação do Diagnóstico no FW Console após solicitação do reboot
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code
