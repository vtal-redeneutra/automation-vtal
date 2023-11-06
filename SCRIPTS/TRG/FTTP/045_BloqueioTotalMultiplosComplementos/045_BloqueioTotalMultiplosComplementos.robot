*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number
...                                         OUTPUT: Type_Logradouro,	Address_Name,	Address_Id,	TypeComplement1,	Value1,	TypeComplement2,	Value2,	TypeComplement3,	Value3,	Inventory_Id,	Availability_Description,	Catalog_Id,	Name,	MaxBandWidth,	Associated_Document_Date,	Appointment_Start,	Appointment_Finish,	Associated_Document,	Work_Order_Id,	Correlation_Order,	Customer_Name,	Phone_Number,	Reference,	SOM_Order_Id,	cancelDate,	LyfeCycleStatus,	CancelAppointmentReason,	CancelAppointmentComments,	creationDate,   returnedMessage

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0014_RealizarBloqueioAgendamento/ROB0014_RealizarBloqueioAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/045_BloqueioTotalMultiplosComplementos.xlsx


*** Test Cases ***
45.01 - Gerar Token de Acesso 
    Retornar Token Vtal

45.02 - Realizar o Bloqueio
    Realizar Bloqueio Agendamento FTTP      400
    
45.03 - Realizar Validação no SOM
    Validacao da OS Bloqueada FTTP          400

45.04 - Validar o Recebimento da Notificação de Bloqueio via FW Console
    Validar Confirmacao de Bloqueio ou Desbloqueio Total ou Parcial FW              Bloqueio                                bloquear total                          200