*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/040_RealizarBloqueioParcialEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

40.01 - Gerar Token de Acesso
    Retornar Token Vtal

40.02-03 - Realizar o Bloqueio
    Realizar Bloqueio ou Desbloqueio        Bloqueio                                FTTH                                    bloquear parcial

40.04 - Realizar Validação no SOM
    Valida Ordem SOM Bloqueada
    
40.05 - Validar o Recebimento da Notificação de Bloqueio via FW Console 
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.PostProductOrder.v2.5 referente ao blockId
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            200
