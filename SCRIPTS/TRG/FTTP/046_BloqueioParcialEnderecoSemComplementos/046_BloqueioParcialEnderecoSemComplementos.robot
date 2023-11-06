*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/TRG_FTTP_DAT_046_BloqueioParcialEnderecoSemComplementos.xlsx


*** Test Cases ***

46.01 - Gerar Token de Acesso
    Retornar Token Vtal

46.02-03 - Realizar o Bloqueio
    Realizar Bloqueio ou Desbloqueio        Bloqueio                                FTTP                                    bloquear parcial                        400

46.04 - Realizar Validação no SOM
    Valida Ordem SOM Bloqueada              400                                     FTTP                                    
    
46.05 - Validar o Recebimento da Notificação de Bloqueio via FW Console
    Validar Confirmacao de Bloqueio ou Desbloqueio Total ou Parcial FW              Bloqueio                                bloquear parcial                        200