*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number
...                                         OUTPUT: Type_Logradouro,	Address_Name,	Address_Id,	TypeComplement1,	Value1,	TypeComplement2,	Value2,	TypeComplement3,	Value3,	Inventory_Id,	Availability_Description,	Catalog_Id,	Name,	MaxBandWidth,	Associated_Document_Date,	Appointment_Start,	Appointment_Finish,	Associated_Document,	Work_Order_Id,	Correlation_Order,	Customer_Name,	Phone_Number,	Reference,	SOM_Order_Id,	cancelDate,	LyfeCycleStatus,	CancelAppointmentReason,	CancelAppointmentComments,	creationDate,   returnedMessage


Suite Setup                                 Setup cenario                           FTTP

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/043_AtivacaoSemNumResidencia.xlsx


*** Test Cases ***
43.01 - Gerar Token de Acesso 
    Retornar Token Vtal
    
43.02 e 03 - Realizar consulta de Logradouro e Realizar consulta de Complemento
    Consulta Id Logradouro

43.04 - Realizar consulta de viabilidade
    Retorna Viabilidade dos Produtos
    
43.05 - Realizar a Criação de Ordem OS
    Criar Ordem Agendamento FTTP            VELOCIDADE=400
    
43.06 - Realizar Validação Criação da Ordem (OS) no FW Console
    Validar Criação da Ordem
 
43.07 - Realizar Validação no SOM
    Validacao da OS Completa FTTP