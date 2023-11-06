*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/033_RebootONTCPESemSucessoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***
33.01 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=GPON_ONT_RESET                    VALOR=nOK                               RESET_JSON=SIM                      

33.02 - Gerar Token de Acesso
    Retornar Token Vtal

33.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

33.04 - Validação do Pré diagnóstico no FW Console
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

33.05 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
33.06 - Validação do Diagnóstico no FW Console
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code

33.07 - Realização solicitação de reboot da ONT/CPE
    Realizar solicitação reboot ONT/CPE

33.08 - Validação de solicitação do reboot da ONT/CPE no FW Console
    Valida Solicitação de Reboot ONT/CPE no FW                                      GPON_ONT_RESET                          EXTERNAL_SYSTEM_FAULT                   NOK

33.09 - Realização do Pré Diagnóstico após solicitação do reboot
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

33.10 - Validação do Pré diagnóstico no FW Console após solicitação do reboot
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state

33.11 - Realização de Diagnóstico após solicitação do reboot
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
33.12 - Validação do Diagnóstico no FW Console após solicitação do reboot
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent         INVOKE             code
