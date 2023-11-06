*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/035_HabilitarRadioONTSemSucessoEnderecoSemComplemento.xlsx


*** Test Cases ***


35.01 - Acessar o Citrix 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_ENABLE                   VALOR=nOK                               RESET_JSON=SIM
    
35.02 - Gerar Token de Acesso
    Retornar Token Vtal
    Escrever Variavel na Planilha           FINISHED                                state                                   Global

35.03 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

35.04 - Validar a Notificação do Pré-Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

35.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
35.06 - Validar a Notificação do Diagnóstico
    Valida Notificacao Diagnostico no FW_1                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code,state,subscriberId

35.07 - Habilitar o rádio da ONT sem sucesso
    Configuracao Remota                                                             HGW_WIFI_ENABLE                         frequencyBand

35.08 - Validar a Notificação após a Habilitação 
    Escrever Variavel na Planilha           EXTERNAL_SYSTEM_FAULT                   state                                   Global
    Validar Evento FW                       VALOR_BUSCA=configurationId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1] 
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]     
    ...                                     DADOS_XML=state

35.09 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic
    Escrever Variavel na Planilha           FINISHED                                state                                   Global

35.10 - Validar a Notificação do Pré-Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

35.11 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

35.12 - Validar a Notificação do Diagnóstico
    Valida Notificacao Diagnostico no FW_1                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code,state,subscriberId