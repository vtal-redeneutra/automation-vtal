*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: IdDesbloqueio


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/014_DesbloqueioTotalMultiplosComplementos.xlsx


*** Test Cases ***

14.01 - Gerar Token de Acesso 
    Retornar Token Vtal
    
14.02 - Realizar o Desbloqueio
   Realizar Bloqueio ou Desbloqueio         Desbloqueio                             FTTH                                    desbloquear total

14.03 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                      
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Desbloqueio
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

14.04 - Validar o Recebimento da Notificação de Desbloqueio via Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204