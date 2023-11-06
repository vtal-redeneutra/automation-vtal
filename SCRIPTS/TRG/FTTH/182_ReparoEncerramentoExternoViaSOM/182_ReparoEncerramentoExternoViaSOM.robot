*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/182_ReparoEncerramentoExternoViaSOM.xlsx

*** Test Cases ***
182.01/02 - Realizar Acesso ao Citrix
    Alterar Campo no NETQ                   CAMPO=GPON_ESTADO_ONT                   VALOR=GPON_03                           RESET_JSON=SIM

182.03 - Gerar Token de Acesso
    Retornar Token Vtal

182.04 - Realizar Pré-Diagnóstico 
    Realizar PreDiagnostico ou Diagnostico  preDiagnostic

182.05 - Validar retorno do Pré-Diagnóstico no FW
    Validar Evento FW                       VALOR_BUSCA=preDiagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    ...                                     DADOS_XML=subscriberId,state

182.06 - Realizar Diagnóstico
    Realizar PreDiagnostico ou Diagnostico  diagnostic

182.07 - Validar o Retorno do Diagnóstico no FW 
    Validar Evento FW                       VALOR_BUSCA=diagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[2]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    ...                                     RETORNO_ESPERADO=>NetQ identificou problemas e irá executar ações de correção<

182.08 - Abrir Reparo
    Abrir Chamado Tecnico sem complemento   problem_description=Problema de Conectividade                                   problem_origin=Pendência Cliente

182.09 - Validar no SOM a Abertura do Reparo
    @{LIST}=                                Create List                             ${SOM_Cliente_idContrato}

    @{RETORNO}=                             Create List                             subscriberId

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T052 - Analisar Chamado Tecnico
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     plantaExterna=True

182.10 - Tramitar no SOM o Reparo até o Encerramento
    Tramitar Reparo SOM

182.11 - Validar Encerramento do Reparo no SOM
    @{LIST}=                                Create List                             ${SOM_Cliente_idContrato}

    @{RETORNO}=                             Create List                             subscriberId

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     plantaExterna=True

182.12 - Validar encerramento do reparo no FW
    Validar Evento FW                       VALOR_BUSCA=troubleTicketId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso<