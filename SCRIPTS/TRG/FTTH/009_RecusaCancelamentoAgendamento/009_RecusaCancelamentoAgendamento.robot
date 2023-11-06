*** Settings ***


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/009_RecusaCancelamentoAgendamento.xlsx


*** Test Cases ***
09.01 - Gerar Token de Acesso
    Retornar Token Vtal

09.02-03 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

09.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

09.05 - Realizar Consulta de Slots
    Consulta Slot Agendamento

09.06 - Realizar Agendamento
    Realizar Agendamento

09.07 - Realizar a Criação de Ordem OS
    Criar Ordem Agendamento
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

09.08 - Validar a Abertura da OS via SOM
    Validar Ordem SOM Sucesso
    
09.09 - Realizar a Consulta do Agendamento
    Consultar Agendamento

09.XX - Atualização da Data de Agendamento via API
    Reagendar Pedido OPM e FSL

09.XX - Troca de Técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

09.10 - Tramitar o SA via FSL
    Atualiza Status SA

09.11 - Realizar o Cancelamento do Agendamento
    Cancelar o Agendamento

09.12 - Validar a Notificação de Recusa do Cancelamento do Agendamento
    Validar Evento Cancelamento FW          Appointment.CancelAppointment           code>406<
