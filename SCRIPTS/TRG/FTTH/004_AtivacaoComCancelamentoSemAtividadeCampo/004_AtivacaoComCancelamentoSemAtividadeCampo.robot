*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address - Number
...                                         OUTPUT: Type_Logradouro - Address_Name - Address_Id - TypeComplement1 - Value1 - TypeComplement2 - Value2 = TypeComplement3 - Value3 - Inventory_Id - Availability_Description - Catalog_Id - Name - MaxBandWidth - Associated_Document_Date - Appointment_Start - Appointment_Finish - Associated_Document - Work_Order_Id - Correlation_Order - Customer_Name	Phone_Number - Reference - SOM_Order_Id - cancelDate - LyfeCycleStatus - CancelAppointmentReason - CancelAppointmentComments - returnedMessage

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0023_ValidarNotificacaoCancelamentoFW/ROB0023_ValidarNotificacaoCancelamentoFW.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/004_AtivacaoComCancelamento.xlsx


*** Test Cases ***
04.01 - Gerar Token de Acesso
    Retornar Token Vtal

04.02-3 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

04.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

04.05 - Realizar Consulta de Slots
    Consulta Slot Agendamento

04.06 - Realizar Agendamento
    Realizar Agendamento

04.07 - Valida a Criação do Agendamento via FSL
    Validar Atribuicao Automatica FSL

04.08 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento
  
04.09 - Realizar a Consulta do Agendamento
    Consultar Agendamento
    
04.10 - Realizar Validação no SOM
    Validar Ordem SOM Sucesso

04.11 - Realizar o Cancelamento
    Cancelar agendamento

04.12 - Validar a Notificação do Cancelamento - FW Console
    Validar Evento FW                       VALOR_BUSCA=workOrderId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.CancelAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<

04.13 - Comprovar o Recebimento da Notificação de Cancelamento da Ativação
    Validar Evento FW                       VALOR_BUSCA=workOrderId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.ListenerWorkOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>200<