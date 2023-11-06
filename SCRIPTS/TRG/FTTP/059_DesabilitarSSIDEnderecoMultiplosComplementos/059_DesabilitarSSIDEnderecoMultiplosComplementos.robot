*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/059_DesabilitarSSIDEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

59.01 - Realizar configuração na ferramenta de mock
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_CONFIGURATION            VALOR=OK                                RESET_JSON=SIM
    
59.02 - Gerar Token de Acesso
    Retornar Token Vtal

59.03 - Realizar Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

59.04 - Realizar Validação do Pré diagnóstico no FW Console
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  startDate,endDate,subscriberId,state

59.05 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

59.06 - Realizar Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW                                            ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  ssid,wifiIndex,subscriberId,frequencyBand                           

59.07/08 - Realizar a desabilitação do SSID
    Desabilitando SSID

59.09 - Realizar Validação da desabilitação de SSID no FW Console 
    Realizar Validação da desabilitação de SSID no FW                               ServiceActivationConfiguration.ListenerConfigurationResultEvent                 <msg:message>Operação realizada com sucesso</msg:message>

59.10 - Realizar Pré diagnostico após desabilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

59.11 - Validar Pré diagnóstico após desabilitação de SSID no FW Console
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  startDate,endDate,subscriberId,state

59.12 - Realizar Diagnóstico após desabilitação de SSID
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

59.13 - Validar Diagnostico após desabilitação de SSID no FW Console
    Valida Notificacao Diagnostico no FW                                            ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  ssid,wifiIndex,subscriberId,frequencyBand

    