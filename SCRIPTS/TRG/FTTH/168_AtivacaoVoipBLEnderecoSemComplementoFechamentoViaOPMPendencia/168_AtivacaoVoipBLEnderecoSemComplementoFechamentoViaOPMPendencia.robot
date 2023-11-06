*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: subscriberId, Address_Id, InventoryId, TypeComplement1, Value1, InfraType, Customer_Name, status, errorCode, Valor_Pendencia
...                                         OUTPUT: code, type, state, PreDiag_ID, Diag_ID, Associated_Document_Date, Appointment_Start, Appoointment_Finish, associatedDocument, Work_Order_Id, Estado, troubleTicket_id

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot

Suite Setup                                 Setup cenario                           Voip

Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/168_AtivacaoVoipBLEnderecoSemComplementoFechamentoViaOPMPendencia.xlsx

*** Test Cases ***
168.01 - Gerar Token de Acesso
    Retornar Token Vtal

168.02/03 - Realizar Consulta de Logradouro
    Consulta Logradouro CPOi
    
168.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

168.05 - Realizar Consulta de Slots
    Retornar Slot Agendamento Voip

168.06 - Realizar o Agendamento
    Realizar Agendamento                    cod_activityType=4936

168.07 - Realizar a Criação de Ordem (OS)
    Criar Ordem de Agendamento Voip

168.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

168.09 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument   

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

XX.XX - Realizar o Reagendamento via API
    Reagendar Pedido OPM e FSL

XX.XX - Atribuir técnico no Field Service
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

168.10 - Encerrar o SA via OPM
    Colocar SA em execucao
    Validar Atribuicao Automatica Voip
    Colocar Sa Concluida sem sucesso        EquipamentoAssociado=ONT HW - HG8245H
    Valida sucesso do equipamento no FSL
    Encerrar SA sem sucesso OPM             codigo_encerramento=0058
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global

168.11/15 - Validar Mudança de Status no FW Console
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION              ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name

168.16 - Validar no Field Service
    Valida SA no Field Service

168.17 - Auditoria de Tarefas
    Auditoria de Tarefas

168.18 - Realizar Validação de Retorno via SOM
    Valida Ordem SOM Finalizada com sucesso

168.19 - Validar a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e Insucesso para VOIP OI<