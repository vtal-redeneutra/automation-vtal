*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, CancelAppointmentReason, CancelAppointmentComments
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/247_ConsultaAgendamentoVisitaTecnicaBitstream.xlsx

*** Test Cases ***
247.01 - Gerar Token de Acesso
    Retornar Token Vtal

247.02 - Realizar Consulta do Histórico de Agendamento
    Consultar Historico Agendamento

247.03 - Validar Notificação - Consulta do histórico de Agendamento via FW
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.GetAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<