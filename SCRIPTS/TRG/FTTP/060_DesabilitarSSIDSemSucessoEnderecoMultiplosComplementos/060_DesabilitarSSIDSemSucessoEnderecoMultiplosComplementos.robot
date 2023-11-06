*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/060_DesabilitarSSIDSemSucessoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

60.01 - Criar massa para não cair em Trouble Ticket (diagnóstico sem falha)           
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_CONFIGURATION            VALOR=nOK                               RESET_JSON=SIM

60.02 - Gerar o Token de Acesso
    Retornar Token Vtal

60.03 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

60.04 - Validar a Notificação do Pré-Diagnóstico
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

60.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

60.06 - Validar a Notificação do Diagnóstico
    Escrever Variavel na Planilha           OK                                      code                                    Global
    Valida Notificacao Diagnostico no FW    ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  subscriberId,state,code

60.07 - Realização de desabilitaçãodo SSID
    Desabilitando SSID

60.08 - Validação da desabilitação de SSID com falha no FW Console
    Escrever Variavel na Planilha           EXTERNAL_SYSTEM_FAULT                   state                                   Global
    Escrever Variavel na Planilha           NOK                                     code                                    Global
    Validar Evento FW                       VALOR_BUSCA=desabilitacaoId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1] 
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]     
    ...                                     DADOS_XML=state,code

60.09 - Realizar Pré diagnostico após desabilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

60.10 - Validação do Pré diagnóstico no FW Console
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

60.11 - Realização do Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

60.12 - Validação Diagnostico no FW Console
    Escrever Variavel na Planilha           OK                                      code                                    Global
    Valida Notificacao Diagnostico no FW    ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  subscriberId,state,code
