*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_FTTP_DAT_068_DesabilitarONTSemSucessoEnderecoSemComplemento.xlsx


*** Test Cases ***
68.01 - Acessar o Citrix
    Alterar Campo no NETQ                   RESET_JSON=SIM

68.02 - Gerar Token de Acesso 
    Retornar Token Vtal

68.03 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

68.04 - Validar a Notificação do Pré-Diagnóstico
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,subscriberId

68.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
68.06 - Validar a Notificação do Diagnóstico
    Validar Evento FW                   VALOR_BUSCA=Diag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=beaconType,ssid,frequencyBand

68.07 - Realizar configuração Mock
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_DISABLE                  VALOR=nOK                               

68.08 - Desabilitar o rádio da ONT sem sucesso
    Configuracao Remota                                                             HGW_WIFI_DISABLE                                                                frequencyBand

68.09 - Validar a Notificação após a Desabilitação 
    Escrever Variavel na Planilha           EXTERNAL_SYSTEM_FAULT                   state                                   Global
    Validar Evento FW                       VALOR_BUSCA=Configuration_Id   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state

68.10 - Realizar Pré-Diagnóstico após desabilitação sem sucesso
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

68.11 - Validar a Notificação do Pré-Diagnóstico
    Escrever Variavel na Planilha           FINISHED                                state                                  Global
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,subscriberId
    
68.12 - Realizar Diagnóstico após desabilitação sem sucesso
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

68.13 - Validar a Notificação do Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=Diag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=beaconType,ssid,frequencyBand
