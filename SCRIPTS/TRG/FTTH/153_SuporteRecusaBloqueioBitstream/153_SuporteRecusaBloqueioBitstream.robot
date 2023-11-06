*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: IdBlock

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/153_SuporteRecusaBloqueioBitstream.xlsx


*** Test Cases ***
153.1 - Gerar Token de Acesso
    Retornar Token Vtal

153.2-3 - Realizar o Bloqueio e Validar Retorno da API
   Realizar Bloqueio ou Desbloqueio         Bloqueio                                FTTH                                    bloquear total

153.4 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    ${SOM_Tipo_Ordem}       
    ...                                     ${SOM_Atributo_Acao}                

    @{RETORNO}=                             Create List                             associatedDocument                      tipoOrdem
    ...                                     action                                  

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Bitstream Bloqueio
    ...                                     ORDER_STATE=Cancelled
    ...                                     TASK_NAME=Vtal Bitstream Bloqueio order entry task
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

153.5 - Validar o Recebimento da Notificação de Bloqueio via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=//*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=Bloqueio/Desbloqueio não está disponível para o produto BITSTREAM