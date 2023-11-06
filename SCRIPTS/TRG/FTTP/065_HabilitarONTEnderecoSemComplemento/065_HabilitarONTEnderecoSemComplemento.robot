*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_FTTP_DAT_065_HabilitarONTEnderecoSemComplemento.xlsx


*** Test Cases ***

65.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   RESET_JSON=SIM

65.02 - Gerar Token de Acesso
    Retornar Token Vtal

65.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

65.04 - Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId

65.05 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
65.06 - Validação do Diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=Diag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=ssid

65.07 - Habilitar o rádio da ONT com sucesso
    Configuracao Remota                                                             HGW_WIFI_ENABLE                         frequencyBand

65.08 - Validar a Notificação após a Habilitação 
    Valida Configuracao Remota                                                      HGW_WIFI_ENABLE

65.09 - Realização do Pré Diagnóstico após solicitação do reboot
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

65.10 - Validação do Pré diagnóstico no FW Console após solicitação do reboot
    Escrever Variavel na Planilha           FINISHED                                state                                  Global
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId

65.11 - Realização de Diagnóstico após solicitação do reboot
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
65.12 - Validação do Diagnóstico no FW Console após solicitação do reboot
    Validar Evento FW                       VALOR_BUSCA=Diag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=ssid
