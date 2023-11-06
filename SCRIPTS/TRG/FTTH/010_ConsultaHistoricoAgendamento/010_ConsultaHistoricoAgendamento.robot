*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, CancelAppointmentReason, CancelAppointmentComments
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/010_ConsultaHistoricoAgendamento.xlsx

*** Test Cases ***
10.01 - Gerar Token de Acesso 
    Retornar Token Vtal

10.02 - Realizar Consulta do Histórico de Agendamento
    Consultar Historico Agendamento

10.03 - Validar Notificação - Consulta do histórico de Agendamento via FW
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.GetAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<
