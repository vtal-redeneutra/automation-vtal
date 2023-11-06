*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/057_AlteracaoSSIDEnderecoMultiplosComplementos.xlsx


*** Test Cases ***
57.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_CONFIGURATION            VALOR=OK                                RESET_JSON=SIM                     
    
57.02 - Gerar Token de Acesso
    Retornar Token Vtal

57.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

57.04 - Validação do Pré diagnóstico no FW Console
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             startDate,endDate,state

57.05 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

57.06 - Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW_1                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             ssid,wifiIndex,code,frequencyBand

57.07/08 - Realiza Troca SSID 
    Configuracao Remota                     HGW_WIFI_CONFIGURATION                  ssid,wifiIndex

57.09 - Valida a troca de SSID no FW 
    Valida Configuracao Remota                                 	                    HGW_WIFI_CONFIGURATION

57.10 - Realização do Pré Diagnóstico após Habilitação do SSID
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

57.11 - Validação do Pré diagnóstico no FW Console após Habilitação do SSID
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             startDate,endDate,state

57.12 - Realização de Diagnóstico após Habilitação do SSID
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

57.13 - Validação do Diagnóstico no FW Console após Habilitação do SSID
    Valida Notificacao Diagnostico no FW_1                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             ssid,wifiIndex


