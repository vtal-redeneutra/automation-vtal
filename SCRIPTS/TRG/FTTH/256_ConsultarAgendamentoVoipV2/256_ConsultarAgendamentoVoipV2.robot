*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/256_ConsultarAgendamentoVoipV2.xlsx


*** Test Cases ***
256.01 - Gerar Token de Acesso
    Retornar Token Vtal

256.02 - Realizar Consulta do Histórico de Agendamento
    Consultar Historico Agendamento         VERSAO_API=v2

# 256.03 - Validar Notificação - Consulta do histórico de Agendamento via MicroServiços
#     Validar Evento FW                       VALOR_BUSCA=workOrderId
#     ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.GetAppointment'])[1]
#     ...                                     RETORNO_ESPERADO=>200<