*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: IdBlock


Suite Setup                                 Setup cenario                           Whitelabel
Suite Teardown                              Salvar Documento Evidencia

Resource                                     ../../../../DATABASE/ROB/DB.robot

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/013_BloqueioTotalMultiplosComplementos.xlsx


*** Test Cases ***


13.01 - Gerar Token de Acesso 
    [TAGS]                                  COMPLETO    13_01_Gerar_Token_de_Acesso 
    Inicia CT
    Retornar Token Vtal
    Fecha CT        API                       13_02_Realizar_o_Bloqueio

13.02 - Realizar o Bloqueio
    [TAGS]                                  COMPLETO    13_02_Realizar_o_Bloqueio 
    Inicia CT
    Realizar Bloqueio ou Desbloqueio         Bloqueio                                FTTH                                    bloquear total
    Fecha CT        API                       13_03_Realizar_Validacao_no_SOM

13.03 - Realizar Validação no SOM
    [TAGS]                                  COMPLETO    13_03_Realizar_Validacao_no_SOM 
    Inicia CT
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                                 

    @{RETORNO}=                             Create List                             associatedDocument                      

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Bloqueio 
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    Fecha CT        SOM                       13_04_Validar_o_Recebimento_da_Notificacao_de_Bloqueio_via_FW_Console
13.04 - Validar o Recebimento da Notificação de Bloqueio via FW Console
    [TAGS]                                  COMPLETO    13_04_Validar_o_Recebimento_da_Notificacao_de_Bloqueio_via_FW_Console 
    Inicia CT
    Validar Confirmacao de Bloqueio ou Desbloqueio Total ou Parcial FW              Bloqueio                                bloquear total                          200
    Fecha CT        COMPLETO                       COMPLETO