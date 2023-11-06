*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number
...                                         OUTPUT: Type_Logradouro,	Address_Name,	Address_Id,	TypeComplement1,	Value1,	TypeComplement2,	Value2,	TypeComplement3,	Value3,	Inventory_Id,	Availability_Description,	Catalog_Id,	Name,	MaxBandWidth,	Associated_Document_Date,	Appointment_Start,	Appointment_Finish,	Associated_Document,	Work_Order_Id,	Correlation_Order,	Customer_Name,	Phone_Number,	Reference,	SOM_Order_Id,	cancelDate,	LyfeCycleStatus,	CancelAppointmentReason,	CancelAppointmentComments,	creationDate,   returnedMessage
    
Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/044_AtivacaoMultiplosComplementos.xlsx


*** Test Cases ***
44.01 - Gerar Token de Acesso 
    Retornar Token Vtal

44.02 e 03 - Realizar consulta de Logradouro e Realizar consulta de Complemento
    Consulta Id Logradouro

44.04 - Realizar consulta de viabilidade
    Retorna Viabilidade dos Produtos

44.05 - Realizar a Criação de Ordem OS
    Criar Ordem Agendamento FTTP            VELOCIDADE=400
    
44.06 - Realizar Validação Criação da Ordem (OS) no FW Console
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderCreateEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204    

44.07 - Realizar Validação no SOM
    Validacao da OS Completa FTTP