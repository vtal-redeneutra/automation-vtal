*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/016_ConsultarAgendamentoPedidos.xlsx


*** Test Cases ***
16.01 - Gerar Token de Acesso 
    Retornar Token Vtal

16.02 - Realizar a Consulta do Agendamento
    Consultar Historico Agendamento

16.03 - Validar a Notificação após Consulta de Agendamento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.GetAppointment'])[1]    
    ...                                     RETORNO_ESPERADO=>200<   