*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/187_AbrirTroubleTicketSemDiagnosticoBitstream.xlsx


*** Test Cases ***
187.01 - Gerar Token de Acesso
    Retornar Token Vtal

187.02 - Abrir Trouble Ticket
    Abrir Chamado Tecnico sem complemento   problem_description=Problema de Conectividade
    ...                                     problem_origin=Pendencia Cliente

187.03 - Validar a Notificação de Cancelamento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]      
    ...                                     RETORNO_ESPERADO=description>Ordem cancelada<
    
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]
    ...                                     XPATH_XML=(//*[text()="RESPONSE - Resposta recebida do API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]          
    ...                                     RETORNO_ESPERADO=type>200<

187.04 - Validar a Notificação de Cancelamento via SOM
    @{LIST}=                                Create List                             ${SOM_Processo_Nome}
    ...                                     ${SOM_Processo_Status}                  ${ultimaTarefaSOM}
    
    @{RETORNO}=                             Create List                             Type
    ...                                     status                                  tarefaSom

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}