*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0032_CancelarOrdem/ROB0032_CancelarOrdem.robot


*** Variables ***

${DAT_CENARIO}                              ${DIR_DAT}/179_AtivacaoVoipCanceladaAntesDaAtividadeDeCampoPedidoDaTenant.xlsx

*** Test Cases ***
179.01 - Gerar Token de Acesso
    Retornar Token Vtal

179.02 - Realizar Consulta de Logradouro
    Consulta Logradouro CPOi

179.03 - Realizar Consulta de Complemento
    Consultar Complements

179.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

179.05 - Realizar Consulta de Slots
    Retornar Slot Agendamento Voip

179.06 - Realizar Agendamento
    Realizar Agendamento                    cod_activityType=4936

179.07 - Realizar a Criação de Ordem (OS)
    Criar Ordem de Agendamento Voip

179.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

179.09 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument   

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

179.10 - Realizar o Cancelamento
    Cancelar a Ordem de Agendamento         wlOuVoip=Voip

179.11 - Validar a Notificação do Cancelamento - FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerCancelProductOrderCreateEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

179.12 - Validar a Notificação de Cancelamento da Ativação via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.ListenerWorkOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=//*[text()="INVOKE - Request enviado ao API Gateway [/api/workOrderManagement/v1/listener/workOrderStateChangeEvent]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>ACTIVITY_CANCELED<

179.13 - Validar o Recebimento da Notificação de encerramento da ordem via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=Ordem Encerrada com Sucesso
    ...                                     TENTATIVAS_FOR=30                       # O EVENTO DEMORA A APARECER