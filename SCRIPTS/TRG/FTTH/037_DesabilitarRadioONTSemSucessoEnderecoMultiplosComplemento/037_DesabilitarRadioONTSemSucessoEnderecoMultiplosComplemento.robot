*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/037_DesabilitarRadioONTSemSucessoEnderecoMultiplosComplemento.xlsx


*** Test Cases ***

37.01 - Acessar o Citrix 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_DISABLE                  VALOR=OK                                RESET_JSON=SIM            
    
37.02 - Gerar Token de Acesso
    Retornar Token Vtal

37.03 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
37.04 - Validar a Notificação do Pré-Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

37.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
37.06 - Validar a Notificação do Diagnóstico
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code

37.07 - Configurar a Mock
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_DISABLE                  VALOR=nOK                               

37.08 - Desabilitar o rádio da ONT sem Sucesso
    Configuracao Remota                                                             HGW_WIFI_DISABLE                        frequencyBand

37.09 - Validar a Notificação após a Desabilitação
    Escrever Variavel na Planilha           EXTERNAL_SYSTEM_FAULT                   state                                   Global
    Validar Evento FW                       VALOR_BUSCA=configurationId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1] 
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]     
    ...                                     DADOS_XML=state
37.10 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic
    Escrever Variavel na Planilha           FINISHED                                state                                   Global

37.11 - Validar a Notificação do Pré-Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=preDiagnostic    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state
    
37.12 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
37.13 - Validar a Notificação do Diagnóstico
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code

