*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_NETQ}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/030_TrocaSenhaUsuarioRedeWifiEnderecoSemComplemento.xlsx


*** Test Cases ***

30.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=HGW_WIFI_SET_PASSWD               VALOR=OK                                RESET_JSON=SIM

30.02 - Gerar Token de Acesso
    Retornar Token Vtal

30.03 - Realizar Pré Diagnóstico
    Realizando PreDiagnostico

30.04 - Realizar Validação do Pré diagnóstico no FW Console
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  type,startDate,endDate,state                
    
30.05 - Realizar Diagnóstico
    Realizando Diagnostico                

30.06 - Realizar Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW                                            ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  type,startDate,endDate,state,wifiIndex

30.07 - Realizar a troca de senha do usuário de rede wifi
    Troca de Senha WiFi

30.08 - Realizar Validação da troca da senha no FW Console
    Valida Troca de Senha WiFi

30.09 - Realizar Pré diagnostico após troca de senha
    Realizando PreDiagnostico

30.10 - Validar Pré diagnóstico após troca de senha no FW Console
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  type,startDate,endDate,state                

30.11 - Realizar Diagnóstico após troca de senha
    Realizando Diagnostico  

30.12 - Validar Diagnostico após troca de senha no FW Console
    Valida Notificacao Diagnostico no FW                                            ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  type,startDate,endDate,state
              


    
    
   