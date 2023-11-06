*** Settings ***


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/008_CancelamentoAgendamento.xlsx


*** Test Cases ***

08.01 - Gerar Token de Acesso
    Retornar Token Vtal

08.02-3 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

08.04-6 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

08.07 - Realizar Consulta de Slots
    Consulta Slot Agendamento
    
08.08 - Realizar o Agendamento
    Realizar Agendamento

08.09 - Realizar a Consulta do Agendamento
    Consultar o Agendamento 

08.10 - Executar o Cancelamento
    Cancelar Agendamento 
    Sleep     10                            #Tempo para consulta não retornar erro.

08.11 - Consultar o Agendamento
    Consultar o Agendamento

08.12 - Validar a Notificação de Cancelamento 
    Validar Evento FW                       VALOR_BUSCA=workOrderId  
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.CancelAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<

08.13 - Realizar Validação no FSL
    Validar SA Cancelada FSL                Cancelado                               Cancelamento Checkout