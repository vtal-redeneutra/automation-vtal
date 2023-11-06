*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address_Id - Associated_Document_Date - SubscriberId - MaxBandWidth  - Customer_Name - Phone_Number - CorrelationOrder - InventoryId - Reference- TypeComplement1 - Value1
...                                         OUTPUT: IdDesbloqueio

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0015_RealizarDesbloqueioTotal/ROB0015_RealizarDesbloqueioTotal.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/047_DesbloqueioTotalMultiplosComplementos.xlsx


*** Test Cases ***
47.01 - Gerar Token de Acesso 
    Retornar Token Vtal

47.02 - Realizar a Abertura de OS (Desbloqueio)
    Desbloqueia Totalmente no FTTP          400

47.03 - Realizar Validação no SOM 
    Valida Ordem SOM Desbloqueio FTTP       400

47.04 - Validar o Recebimento da Notificação de Desbloqueio via FW Console
    Validar Confirmacao de Bloqueio ou Desbloqueio Total ou Parcial FW              Desbloqueio                             desbloquear total                       200