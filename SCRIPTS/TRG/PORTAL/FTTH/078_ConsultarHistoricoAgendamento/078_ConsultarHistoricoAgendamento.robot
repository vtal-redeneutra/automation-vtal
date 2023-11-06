*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, CancelAppointmentReason, CancelAppointmentComments
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../../RESOURCE/PORTAL/UTILS.robot
Resource                                    ../../../../ROBS/ROB0049_OrdensDeServiçoPortal/ROB0049_OrdensDeServiçoPortal.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/078_ConsultarHistoricoAgendamento.xlsx

*** Test Cases ***

78.01/02 - Consultar Histórico de Agendamento via PORTAL
    [Teardown]                            Logout Portal Operacional

    Login ao Portal Operacional
    Acessar Ordens de Serviço no menu do PORTAL
    Consultar Historico de Agendamento da OS no PORTAL

# 78.03 - Validar Notificação