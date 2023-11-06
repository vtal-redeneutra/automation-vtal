*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,



Suite Setup                                 Setup cenario                           Bitstream


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/248_AtivacaoBitComReagendamentoConsultaEnderecoGeoreferenciado.xlsx

*** Test Cases ***
248.01 - Gerar Token de Acesso
    Retornar Token Vtal

248.02/03 - Realizar Consulta de Logradouro via Coordenadas
    Consultar Logradouro LocGeografica      Complemento_True_False=True

248.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos Bitstream

248.05 - Realizar Consulta de Slots
    Consulta Slot Agendamento

248.06 - Realizar o Agendamento
    Realizar Agendamento

248.07 - Consulta Agendamento via API
    Consultar Agendamento

248.08 - Validar a Notificação do Agendamento Via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     XPATH_XML=//*[text()="START - Inicialização do serviço"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>4927<

    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     XPATH_XML=//*[text()="INVOKE - Request enviado para o ClienteOperacao.ConfirmarSlotAgendamento"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>4929<


248.09 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

248.10 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar FW Ordem Bitstream              VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderInProvisioning'])[1]
    
248.11 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument   

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

248.12 – Atualização do patch de tarefa “TA – Notificar Recursos Tenant”
    Resolucao pendencia Tenant

248.13 - Validar a Notificação da resolução de tarefa via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

248.14 - Validar a atualização da Atividade via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument   
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

248.15 - Realizar o Reagendamento via API
    Reagendar Pedido OPM e FSL

XX.XX - Atribuir técnico no Field Service no Field Service
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

248.16-18-20 - Realizar o Encerramento da OS de Instalação via FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA - Bitstream                                           EQUIPAMENTO=ONT TIM SAGEM FAST5670 WI-FI 6
    Encerrar com Sucesso
    Close Browser                           CURRENT

248.17-19-21 - Validar Mudança de Status do FSL no FW Console
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           subscriberId                           ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name

248.22 - Validar no Field Service
    Valida SA no Field Service

248.23 – Auditoria de Tarefas
    Auditoria de Tarefas

248.24 - Realizar Validação de Retorno via SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação

248.25 - Validar a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=//*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso<