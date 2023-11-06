*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                     C:/IBM_VTAL/SCRIPTS/ROBS/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                     C:/IBM_VTAL/SCRIPTS/ROBS/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                     C:/IBM_VTAL/SCRIPTS/ROBS/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot
Resource                                     C:/IBM_VTAL/SCRIPTS/ROBS/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/031_ConfigurarCriptografiaRedeWifiEnderecoMuliplosComplementos.xlsx


*** Test Cases ***

31.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_CONFIGURATION            VALOR=OK                                RESET_JSON=SIM
    

31.02 - Gerar Token de Acesso
    Retornar Token Vtal

31.03 - Realização do Pré Diagnóstico
    Realizando PreDiagnostico

31.04 - Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

31.05 - Realização de Diagnóstico
    Realizando Diagnostico
    
31.06 - Validação do Diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=wifiIndex

31.07 - Realização solicitação de reboot da ONT/CPE
    Troca de criptografia da rede Wifi

31.08 - Validação de troca de criptografia sem falha no FW Console
    Validar Evento FW                       VALOR_BUSCA=trocaRedeWifi
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceActivationConfiguration.ListenerConfigurationResultEvent'])[1]  
    ...                                     RETORNO_ESPERADO=Operação realizada com sucesso

31.09 - Realização de Pré Diagnóstico 
    Realizando PreDiagnostico

31.10 - Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state
    
31.11 - Realização do Diagnóstico
    Realizando Diagnostico

31.12 - Validação Diagnostico no FW Console 
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=wifiIndex
















































