*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0036_TroubleTicketChamadoTecnico/ROB0036_TroubleTicketChamadoTecnico.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/041_CancelarTroubleTicket.xlsx


*** Test Cases ***

41.01 - Gerar Token de Acesso
    Retornar Token Vtal

41.02 - Cancela o Chamado Técnico 
    Cancelar Chamado Tecnico

41.03 - Validando Cancelamento do Chamado Técnico SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Cancelled

41.04 - Validando o Cancelamento no Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por TroubleTicketManagement.NotificarStatusTroubleTicket referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            200
