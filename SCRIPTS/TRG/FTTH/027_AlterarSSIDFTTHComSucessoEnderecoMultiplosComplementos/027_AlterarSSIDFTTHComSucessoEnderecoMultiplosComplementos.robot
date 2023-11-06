*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: 
    ...                                     OUTPUT: 
    
Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/027_AlterarSSIDFTTHComSucessoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

27.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_CONFIGURATION            VALOR=OK                                RESET_JSON=SIM

27.02 - Gerar Token de Acesso
    Retornar Token Vtal

27.03 - Realizar Pré Diagnóstico
    Realizando PreDiagnostico

27.04 - Validar retorno do pre-diagnostico no FW
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state
    
27.05 - Realizar Diagnóstico
    Realizando Diagnostico

27.06-07 - Realizar Validação do Diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=wifiIndex

27.08-09 - Realizar a habilitação do SSID
    Configuracao Remota                     HGW_WIFI_ENABLE                         frequencyBand

27.10 - Realizar Validação da habilitação de SSID no FW Console
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=configurationId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1] 
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]     
    ...                                     DADOS_XML=state

27.11 - Realizar Pré diagnostico após habilitação de SSID
    Realizando PreDiagnostico
    
27.12 - Validar Pré diagnóstico após habilltação de SSID no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

27.13 - Realizar Diagnóstico após habilitação de SSID
    Realizando Diagnostico
    
27.14-15 - Validar Diagnostico após habilltação de SSID no FW Console
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=wifiIndex
