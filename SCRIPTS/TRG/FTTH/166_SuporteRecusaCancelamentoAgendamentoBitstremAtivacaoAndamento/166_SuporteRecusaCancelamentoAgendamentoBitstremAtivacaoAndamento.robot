*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
    ...                                     OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/RESOURCE/FSL/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/RESOURCE/SOM/UTILS.robot
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
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/166_SuporteRecusaCancelamentoAgendamentoBitstremAtivacaoAndamento.xlsx


*** Test Cases ***
166.01 - Gerar Token de Acesso
    Retornar Token Vtal

166.02/03 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

166.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos Bitstream

166.05 - Realizar Consulta de Slots
    Consulta Slot Agendamento

166.06 - Realizar o Agendamento
    Realizar Agendamento

166.07 - Validar a Notificação do Agendamento
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

166.08 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400  
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

166.09 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar FW Ordem Bitstream              VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderInProvisioning'])[1]

166.10 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    
                                   
    @{RETORNO}=                             Create List                             associatedDocument  

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

166.11 - Atualização do patch de tarefa “TA - Notificar Recursos Tenant”
    Resolucao pendencia Tenant

166.12 - Validar a Notificação da resolução de tarefa via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

166.13 - Validar a atualização da tarefa via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    
                                   
    @{RETORNO}=                             Create List                             associatedDocument  
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

166.14 - Realizar o Reagendamento via API
    Reagendar Pedido OPM e FSL 
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global

XX.XX - Troca de técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

166.15 - Realizar o Encerramento da OS de Instalação via FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Atualiza Status SA
    Close Browser                           CURRENT

166.16-18 - Validar Mudança de Status do FSL no FW Console
    ${state_list}=                          Create List                EN_ROUTE                   IN_EXECUTION                      
    Validar Mudancas de Estado FW           subscriberId               ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name

166.19 - Realizar o Cancelamento 
    Cancelar Agendamento Bitstream