*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0036_TroubleTicketChamadoTecnico/ROB0036_TroubleTicketChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/164_CancelarTTComSucesso.xlsx


*** Test Cases ***
# Cenário para massas que já tem Trouble Ticket aberto

164.01 - Gerar Token de Acesso
    Retornar Token Vtal

164.02 - Cancelar Chamado Técnico
    Cancelar Chamado Tecnico

164.03 - Validando Cancelamento do Chamado Técnico SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=Vtal Bitstream Chamado Tecnico Ordem order entry task
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Cancelled

164.04 - Validando o Cancelamento no FW Console 
    Validar Evento FW                       VALOR_BUSCA=subscriberId   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]      
    ...                                     DADOS_XML=description,status,code
    
    Validar Evento FW                       VALOR_BUSCA=subscriberId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]
    ...                                     XPATH_XML=(//*[text()="RESPONSE - Resposta recebida do API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]          
    ...                                     RETORNO_ESPERADO=type>200<

#===========================================================================================================================#
# Para massa que não tem Trouble Ticket aberto, rodar o .bat COM_AbrirTroubleTicket, para que faça a abertura de um antes de cancelar.

164.01 - Gerar Token de Acesso
    [TAGS]              COM_AbrirTroubleTicket
    Retornar Token Vtal

xx.xx - Realizar configuração na ferramenta de mock 
    [TAGS]              COM_AbrirTroubleTicket
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01                           RESET_JSON=SIM

xx.xx - Realizar pre-diagnostico
    [TAGS]              COM_AbrirTroubleTicket
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

xx.xx - Validar retorno do pre-diagnostico no FW
    [TAGS]              COM_AbrirTroubleTicket
    Escrever Variavel na Planilha           preDiagnostic                           type                                    Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=type,state
    
xx.xx - Realizar Diagnostico
    [TAGS]              COM_AbrirTroubleTicket
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic
    
xx.xx - Validar retorno do diagnostico no FW
    [TAGS]              COM_AbrirTroubleTicket
    Escrever Variavel na Planilha           diagnostic                              type                                    Global
    Validar Evento FW                       VALOR_BUSCA=diagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=type,state

xx.xx - Abrir Chamado Tecnico
    [TAGS]              COM_AbrirTroubleTicket

    Abrir Chamado Tecnico sem complemento   problem_description=PROBLEMA DE CONECTIVIDADE

xx.xx - Realizar Validação de Retorno via SOM
    [TAGS]              COM_AbrirTroubleTicket
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=In Progress
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem

164.02 - Cancelar Chamado Técnico
    [TAGS]              COM_AbrirTroubleTicket
    Cancelar Chamado Tecnico

164.03 - Validando Cancelamento do Chamado Técnico SOM
    [TAGS]              COM_AbrirTroubleTicket
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=Vtal Bitstream Chamado Tecnico Ordem order entry task
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Cancelled

164.04 - Validando o Cancelamento no FW Console
    [TAGS]              COM_AbrirTroubleTicket
    Validar Evento FW                       VALOR_BUSCA=subscriberId   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]      
    ...                                     DADOS_XML=description,status
    
    Validar Evento FW                       VALOR_BUSCA=subscriberId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]
    ...                                     XPATH_XML=(//*[text()="RESPONSE - Resposta recebida do API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]          
    ...                                     RETORNO_ESPERADO=type>200<