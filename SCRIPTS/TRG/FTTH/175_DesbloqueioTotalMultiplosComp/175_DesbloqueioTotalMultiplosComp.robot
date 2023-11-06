*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: IdBlock


Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_MS}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/175_DesbloqueioTotalMultiplosComp.xlsx


*** Test Cases ***
175.01 - Gerar Token de Acesso 
    Retornar Token Vtal

175.02 - Realizar o Desbloqueio total
    Realiza Bloqueio/Desbloqueio Voip       Type=Desbloqueio                        acao=desbloquear total                                    

175.03 - Validar o Recebimento da Notificação de Desbloqueio no Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderCreateEvent referente ao associatedDocument
    Extrair dado do Bloco                   START - Inicialização do serviço        id                                      somOrderId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     msg:Description                         Sucesso

175.04 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    ${SOM_Cliente_idContrato}               

    @{RETORNO}=                             Create List                             associatedDocument                      subscriberId                           

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Desbloqueio 
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

175.05 - Notificação de encerramento da ordem no Microserviços (notificação do SOM) 
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por SingleNotificationManagement.SOM referente ao associatedDocument
    Validar texto do Bloco com o Argumento    Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]       Ordem Encerrada com Sucesso


