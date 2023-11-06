*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: 
...                                         OUTPUT: 

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ${DIR_COMMON}/RES_UTIL.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_NETQ}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0033_RealizarPreDiagnostico/ROB0033_RealizarPreDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0036_TroubleTicketChamadoTecnico/ROB0036_TroubleTicketChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0038_TramitarOrdemSomReparo/ROB0038_TramitarOrdemSomReparo.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/038_RealizarDiagnosticoFTTHSemSucessoAbrirTTComSucessoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

38.01 - Retornar Token Vtal
    Retornar Token Vtal
    # Cancelar Chamado Tecnico
    
38.02 - Realizar configuração na ferramenta de mock
    Alterar Campo no NETQ                   CAMPO=GPON_ESTADO_ONT                   VALOR=GPON_03                           RESET_JSON=SIM                          

38.03 - Realizando PreDiagnostico
    Realizando PreDiagnostico

38.04 - Valida Notificacao Pre Diagnostico no FW  
    Valida Notificacao Pre Diagnostico no FW                                        ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  startDate,endDate,subscriberId,state

38.05- Realizando Diagnostico
    Realizando Diagnostico

38.06 - Valida Notificacao Diagnostico no FW_2
    Valida Notificacao Diagnostico no FW_2                                          ServiceTestManagement.ListenerServiceTestResultEvent                            INVOKE                                  description,subscriberId,code                           

38.07 - Abrir Chamado Técnico
    Abrir Chamado Tecnico sem complemento   Problema de conectividade   

38.08 - Validar no SOM a abertura do reparo
    Valida Abertura de reparo
    
38.09 - Tramitar no SOM o reparo até o encerramento
    Resolver a abertura do chamado tecnico

38.10 - Validar encerramento do reparo no SOM
    Validar Conclusao OS Trouble Ticket

38.11 - Validar encerramento do reparo no FW
    Valida Notificacao Encerramento Diagnostico no FW                               TroubleTicketManagement.NotificarStatusTroubleTicket                            INVOKE                                  associatedDocument

