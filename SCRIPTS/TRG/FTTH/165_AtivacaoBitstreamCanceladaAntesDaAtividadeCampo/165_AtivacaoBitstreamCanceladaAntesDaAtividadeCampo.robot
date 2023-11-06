*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address - Number
...                                         OUTPUT: Type_Logradouro - Address_Name - Address_Id - TypeComplement1 - Value1 - TypeComplement2 - Value2 = TypeComplement3 - Value3 - Inventory_Id - Availability_Description - Catalog_Id - Name - MaxBandWidth - Associated_Document_Date - Appointment_Start - Appointment_Finish - associatedDocument - Work_Order_Id - Correlation_Order - Customer_Name	Phone_Number - Reference - SOM_Order_Id - cancelDate - LyfeCycleStatus - CancelAppointmentReason - CancelAppointmentComments - returnedMessage

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/165_AtivacaoBitstreamCanceladaAntesDaAtividadeCampo.xlsx


*** Test Cases ***
165.01 - Gerar Token de Acesso
    Retornar Token Vtal

165.02/03 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

165.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos Bitstream

165.05 - Realizar Consulta de Slots
    Consulta Slot Agendamento

165.06 - Realizar Agendamento
    Realizar Agendamento

165.07 - Validar a Notificação do Agendamento
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

165.08 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

165.09 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar FW Ordem Bitstream              VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderInProvisioning'])[1]

165.10 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    
                                   
    @{RETORNO}=                             Create List                             associatedDocument  
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

165.11 - Atualização do patch de tarefa “TA - Notificar Recursos Tenant”
    Resolucao pendencia Tenant

165.12 - Validar a Notificação da resolução de tarefa via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

165.13 - Validar a atualização da tarefa via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    
                                   
    @{RETORNO}=                             Create List                             associatedDocument  

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

165.14 - Realizar o Cancelamento 
    Cancelar Agendamento Bitstream

165.15 - Validar a Notificação do Cancelamento - FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument 
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerCancelProductOrderCreateEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

165.16 - Comprovar o Recebimento da Notificação de Cancelamento da Ativação
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=//*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea
    ...                                     DADOS_XML=type,description
