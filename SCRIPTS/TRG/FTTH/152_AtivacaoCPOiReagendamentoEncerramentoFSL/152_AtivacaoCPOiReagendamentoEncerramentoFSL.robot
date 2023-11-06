*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
    ...                                     OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,



Suite Setup                                 Setup cenario                           CPOI

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FW}/UTILS.robot
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
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/152_AtivacaoCPOiReagendamentoEncerramentoFSL.xlsx


*** Test Cases ***
152.01 - Retornar Token VTAL
    Retornar Token Vtal

152.02-03 - Realizar Consulta de Logradouro e Complemento
    Consulta Logradouro CPOi

152.04-05 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

152.06 - Realizar Consulta de Slots
    Consulta Slot Agendamento

152.07 - Realizar o Agendamento
    Realizar Agendamento

152.08 - Validar a Notificação do Agendamento
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

152.09 - Realizar a Criação de Ordem (OS)
    Criar Ordem de Agendamento CPOi         
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

152.10 - Validar a Notificação da Criação da Ordem (OS) via FW Console
   Validar FW Ordem CPOi                    VALOR_BUSCA=associatedDocument
   ...                                      XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

152.11 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                     

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TIPO_PESQUISA=QUERY
    ...                                     TENTATIVAS_FOR=25

152.12 - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL              

XX.XX - Troca de técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

152.13 - Validar Notificação de Atualização via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PatchAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<
    Close Browser                           CURRENT

152.14 - Realizar o Encerramento da OS de Instalação via FSL
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA CPOI          ONT HW - HG8245H
    Validar Estado do pedido FSL
    Close Browser                           CURRENT

152.15 - Validar Mudança de Estados no FW
    ${state_list}=                          Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           subscriberId              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

152.16 - Auditoria de Tarefas
    Auditoria de Tarefas

152.17 - Validar no Field Service
    Valida SA no Field Service

152.18 - Validar Hierarquia da Atividade e Gestão de Polígonos
    Validar Hierarquia da Atividade e Gestão de Polígonos

152.19 - Realizar Validação de Retorno via SOM
    Valida Ordem SOM Finalizada com sucesso

152.20 - Validar a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     RETORNO_ESPERADO=Ordem Encerrada com Sucesso
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea