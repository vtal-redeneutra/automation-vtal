*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_FTTP_DAT_061_TrocaSenhaUsuarioRedeWifiEnderecoSemComplemento.xlsx


*** Test Cases ***

61.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_SET_PASSWD               VALOR=OK                                RESET_JSON=SIM                 

61.02 - Gerar Token de Acesso
    Retornar Token Vtal

61.03 - Realizar Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

61.04 - Realizar Validação do Pré diagnóstico no FW Console
    Escrever Variavel na Planilha           preDiagnostic                           type                                    Global
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=type,state

61.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic              

61.06 - Realizar Validação do Diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=Diag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=wifiIndex

61.07 - Realizar a troca de senha do usuário de rede wifi
    Configuracao Remota                                                             HGW_WIFI_SET_PASSWD                     wifiIndex,passwd,mode

61.08 - Realizar Validação da troca da senha no FW Console
    #Valida Troca de Senha WiFi
    Validar Evento FW                       VALOR_BUSCA=Configuration_Id   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/listener/configurationResultEvent]"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

61.09 - Realizar Pré diagnostico após troca de senha
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

61.10 - Validar Pré diagnóstico após troca de senha no FW Console
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID  
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=type,state

61.11 - Realizar Diagnóstico após troca de senha
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

61.12 - Validar Diagnostico após troca de senha no FW Console
    Validar Evento FW                       VALOR_BUSCA=Diag_ID  
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=beaconType
