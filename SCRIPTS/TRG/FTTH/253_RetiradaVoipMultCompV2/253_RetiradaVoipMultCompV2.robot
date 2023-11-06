*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/253_RetiradaVoipMultCompV2.xlsx


*** Test Cases ***
253.01 - Gerar Token de Acesso
    Retornar Token Vtal

253.02 - Realizar Abertura da Ordem de Retirada Voip v2
    Criar Ordem de Agendamento Voip V2      orderType=Retirada

253.03 - Validar a Notificação da Criação de Ordem no MicroServiços
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.NotificationCreatedOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

253.04 -Validar o Encerramento da Ordem de Retirada no SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument                                                       

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Retirada
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=20

253.05 - Validar a Notificação de Encerramento via Microserviços (SOM)
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso<