*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/188_AbrirTroubleTicketComAgendamentoBitstream.xlsx


*** Test Cases ***
#188.01 - Realizar Acesso ao Citrix

188.02 - Realizar Acesso a Mock do NetQ
    Alterar Campo no NETQ                   CAMPO=GPON_ESTADO_ONT                   VALOR=GPON_03                           RESET_JSON=SIM

188.03 - Gerar Token de Acesso
    Retornar Token Vtal

188.04 - Realizar Consulta de Slots
    Retornar Slot Agendamento Reparo

188.05 - Realizar Agendamento
    Realizar Agendamento de Reparo

188.06 - Validar a Criação do SA no FSL
    Validar SA de Reparo Bitstream no FSL simples

188.07 - Realizar Pré-Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

188.08 - Validar retorno do Pré-Diagnóstico no FW
    Escrever Variavel na Planilha           preDiagnostic                           type                                    Global
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    ...                                     DADOS_XML=type,state

188.09 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

188.10 - Validar o Retorno do Diagnóstico no FW
    Escrever Variavel na Planilha           diagnostic                              type                                    Global
    Escrever Variavel na Planilha           IN_PROGRESS                             state                                   Global
    Validar Evento FW                       VALOR_BUSCA=diagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[2]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    ...                                     DADOS_XML=type,state,code,errorCode,description

    Validar Evento FW                       VALOR_BUSCA=diagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    ...                                     RETORNO_ESPERADO=>[12] Problema de configuração na OLT. Necessária abertura de chamado técnico para análise da Vtal.<

188.11 - Abrir Reparo
    Abrir Chamado Tecnico                   problem_description=PROBLEMA DE CONECTIVIDADE

188.12 - Validar no SOM a Abertura do Reparo
    Valida Abertura de reparo
