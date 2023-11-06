*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/058_HabilitarSSIDEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

58.01 - Acessar o Citrix
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_CONFIGURATION            VALOR=OK                                RESET_JSON=SIM

58.02 - Gerar Token de Acesso
    Retornar Token Vtal

58.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

58.04 - Realizar Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,type

58.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
      
58.06 - Validar a Notificação do Diagnóstico
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=code,state 

58.07/08 - Realizar a habilitação do SSID
    Configuracao Remota                     HGW_WIFI_CONFIGURATION                  frequencyBand,wifiIndex,adminStatus

58.09 - Realizar Validação da habilitação de SSID no FW Console
    Validar Evento FW                       VALOR_BUSCA=configurationId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,code

58.10 - Realizar Pré diagnostico após habilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

58.11 - Validar Pré diagnóstico após habilitação de SSID no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,type

58.12 - Realizar Diagnóstico após habilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
      
58.13 - Validar Diagnostico após habilitação de SSID no FW Console
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,code
