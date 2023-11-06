*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/246_ConsultarAgendamentoVisitaTecnicaVoip.xlsx


*** Test Cases ***
246.01 - Gerar Token de Acesso
    Retornar Token Vtal

246.02 - Realizar Consulta do Histórico de Agendamento
    Consultar Historico Agendamento

246.03 - Validar Notificação - Consulta do histórico de Agendamento via FW
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.GetAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<


