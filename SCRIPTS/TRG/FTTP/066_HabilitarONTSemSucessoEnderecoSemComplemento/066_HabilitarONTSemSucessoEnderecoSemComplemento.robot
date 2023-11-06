*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_FTTP_DAT_066_HabilitarONTSemSucessoEnderecoSemComplemento.xlsx


*** Test Cases ***
66.01 - Acessar o Citrix 
    Alterar Campo no NETQ                   RESET_JSON=SIM

66.02 - Gerar Token de Acesso
    Retornar Token Vtal

66.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

66.04 - Validação do Pré diagnóstico no FW Console
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId
    
66.05 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

66.06 - Validação do Diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=Diag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=ssid

66.07 - Configuração MOCK
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_ENABLE                   VALOR=nOK                               

66.08 - Habilitar o rádio da ONT sem sucesso
    Configuracao Remota                     HGW_WIFI_ENABLE                         frequencyBand


66.09 - Validar a Notificação após a Habilitação
    Escrever Variavel na Planilha           EXTERNAL_SYSTEM_FAULT                   state                                   Global
    Validar Evento FW                       VALOR_BUSCA=Configuration_Id   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state

66.10 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

66.11 - Validar a Notificação do Pré-Diagnóstico
    Escrever Variavel na Planilha           FINISHED                                state                                  Global
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId

66.12 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

66.13 - Validar a Notificação do Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=Diag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=ssid















































