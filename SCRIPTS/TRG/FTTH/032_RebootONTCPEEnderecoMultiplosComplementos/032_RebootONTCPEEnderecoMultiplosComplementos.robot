*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/032_RebootONTCPEEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

32.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=GPON_ONT_RESET                    VALOR=OK                                RESET_JSON=SIM  

32.02 - Gerar Token de Acesso
    Retornar Token Vtal

32.03 - Realizar Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

32.04 - Realizar Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

32.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

32.06-07 - Realizar Validação do Diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=wifiIndex

32.08-09 - Realizar o reboot
    Configuracao Remota                                                             GPON_ONT_RESET                  

32.10 - Realizar Validação do reboot no FW 
    Valida Configuracao Remota                                                      GPON_ONT_RESET

32.11 - Realizar Pré diagnostico após desabilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

32.12 - Validar Pré diagnóstico após desabilitação de SSID no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state
    
32.13 - Realizar Diagnóstico após desabilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

32.14 - Validar Diagnostico após desabilitação de SSID no FW Console
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=wifiIndex