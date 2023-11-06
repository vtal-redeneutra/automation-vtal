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
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0039_AlteracaoCEPNetwin/ROB0039_AlteracaoCEPNetwin.robot
Resource                                    ${DIR_ROBS}/ROB0040_ProcessoObraSOM/ROB0040_ProcessoObraSOM.robot
Resource                                    ${DIR_ROBS}/ROB0041_AbrirPendenciaObraSOM/ROB0041_AbrirPendenciaObraSOM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/139_AtivacaoEnderecoViabilidadeParcialPendencia.xlsx


*** Test Cases ***

139.01 - “Transformando” o CEP de viável para parcial no Netwin
    Transformar CEP Netwin

139.02 - Gerar Token de Acesso
    Retornar Token Vtal

139.03 / 04 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

139.05 - Realizar Consulta de Viabilidade
    Retorna Viabilidade Produtos            RETORNO_ESPERADO=Viável com obra - Survey sem CDO e em célula disponível

139.06 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento FTTP            VELOCIDADE=1000
    
139.07 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar Criação da Ordem

139.08 - Validar a Criação da OS de Instalação via SOM
    #Validacao da OS Completa FTTP
    Valida Executar Processo de Obra        FTTH_ou_FTTP=FTTP
    Valida Projeto de Rede

139.09 - “Transformando” o CEP de parcial para viavel no Netwin
    Transformar CEP Netwin 

139.10 - Realizar Processo de Pendência de Obra
    Abrir Pendencia Contato de Obra

139.11 - Realizar Resolução de Pendência via Postman
    Resolucao Pendencia 7100

139.12 - Realizar Validação de Pendência Tratada no Som
    Validar Pendencia Obra Tratada

139.13 - Realizar Processo de Obra - SOM
    Realizar Processo de Obra FTTP

139.14 - Realizar Validação de Retorno via SOM
    Valida Executar Processo de Obra FTTP   VELOCIDADE=1000

139.15 - Validar a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<