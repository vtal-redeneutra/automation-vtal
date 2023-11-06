*** Settings ***

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/185_AbrirTroubleTicketSemTesteDiagnostico.xlsx


*** Test Cases ***

185.01 - Gerar Token de Acesso 
    Retornar Token Vtal

185.02 - Abrir Chamado Técnico
    Abrir Chamado Tecnico sem complemento   problem_description=Problema de conectividade                                   problem_origin=

185.03 - Validar de abertura do reparo no FW                                                                          
    Validar Evento FW                       VALOR_BUSCA=associatedDocument  
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.PostTroubleTicket'])[1]        
    ...                                     RETORNO_ESPERADO=201

185.04 - Validar encerramento automático no SOM 
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Completed

185.05 - Validar encerramento do reparo no FW
    Validar Evento FW                       VALOR_BUSCA=associatedDocument   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.NotificarStatusTroubleTicket'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado ao API Gateway [/api/troubleTicket/v1/listener/troubleTicketStateChangeEvent]"]/../..//textarea)[1]    
    ...                                     RETORNO_ESPERADO=>Ordem cancelada<