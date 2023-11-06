*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_NETQ}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/026_AlterarSSIDFTTHComSucessoEnderecoSemComplemento.xlsx


*** Test Cases ***

26.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_CONFIGURATION            VALOR=OK                                RESET_JSON=SIM

26.02 - Gerar Token de Acesso
    Retornar Token Vtal

26.03 - Realizar Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

26.04 - Realizar Validação do Pré diagnóstico no FW Console
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  startDate,endDate,subscriberId,state

26.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

26.06-07 - Realizar Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW                                            ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  startDate,endDate,subscriberId,state                           
    
26.08-09 - Realizar a troca do SSID
    Escrever Variavel na Planilha                                                   OtherSSID                               ssid                                    Global
    Configuracao Remota                                                             HGW_WIFI_CONFIGURATION                  ssid,wifiIndex

26.10 - Realizar Validação da troca de SSID no FW Console 
    Valida troca de SSID no FW

26.11 - Realizar Pré diagnostico após desabilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

26.12 - Validar Pré diagnóstico após desabilitação de SSID no FW Console
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  startDate,endDate,subscriberId,state

26.13 - Realizar Diagnóstico após desabilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

26.14 - Validar Diagnostico após desabilitação de SSID no FW Console
    Valida Notificacao Diagnostico no FW                                            ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  startDate,endDate,subscriberId,state
