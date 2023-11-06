*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_MS}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/160_RebootONTCPEcomSucessoBitstreamEnderecoMultiplosComp.xlsx

*** Test Cases ***
160.01 - Realizar Acesso ao Citrix
    Alterar Campo no NETQ                   RESET_JSON=SIM

160.02 - Gerar Token de Acesso
    Retornar Token Vtal

160.03 - Realização do Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

160.04 - Validação do Pré diagnóstico no FW Console
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               preDiagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso

160.05 - Realização de Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

160.06 - Validação do Diagnóstico no FW Console
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao diagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               diagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso

160.07 - Realização solicitação de reboot da ONT/CPE
    Realizar solicitação reboot ONT/CPE

160.08 - Validação de solicitação do reboot da ONT/CPE no FW Console
    Valida Solicitação de Reboot ONT/CPE no FW                                      GPON_ONT_RESET                          FINISHED                                OK

160.09 - Realização de Pré Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

160.10 - Validação do Pré diagnóstico no FW Console
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               preDiagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso

160.11 - Realização do Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

160.12 - Validação Diagnostico no FW Console
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao diagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               diagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso
    