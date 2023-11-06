*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: IdBlock


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/013_BloqueioTotalMultiplosComplementos.xlsx


*** Test Cases ***


13.01 - Gerar Token de Acesso 
    Retornar Token Vtal

13.02 - Realizar o Bloqueio
   Realizar Bloqueio ou Desbloqueio         Bloqueio                                FTTH                                    bloquear total

13.03 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                                 

    @{RETORNO}=                             Create List                             associatedDocument                      

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Bloqueio 
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

13.04 - Validar o Recebimento da Notificação de Bloqueio via Microserviços
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204