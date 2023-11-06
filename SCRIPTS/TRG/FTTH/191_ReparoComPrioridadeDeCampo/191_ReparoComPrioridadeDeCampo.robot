*** Settings ***

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/191_ReparoComPrioridadeDeCampo.xlsx


*** Test Cases ***
191.01 - Gerar Token de Acesso
    Retornar Token Vtal

191.02 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01

191.03 - Realizar pre-diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

191.04 - Validar retorno do pre-diagnostico no FW
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state

191.05 - Realizar Diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

191.06 - Validar retorno do diagnostico no FW
    Validar Evento FW                       VALOR_BUSCA=diagId   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]         
    ...                                     DADOS_XML=state                  
    Close Browser                           CURRENT

191.07 - Abrir Chamado Técnico
    Abrir Chamado Tecnico sem complemento   PROBLEMA DE CONECTIVIDADE

191.08 - Validar abertura do reparo no FW
    Validar Evento FW                       VALOR_BUSCA=troubleTicketId   
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.ListenerTroubleTicketInformationRequiredEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para o API Gateway[/api/troubleTicket/v1/listener/troubleTicketInformationRequiredEvent]"]/../..//textarea)[1]        
    ...                                     RETORNO_ESPERADO=AGENDAMENTO DO PEDIDO

191.09 - Validar no SOM abertura do reparo
    Validar Criação de Reparo SOM           SomAgendamento=T070 - Agendamento

191.10 - Realizar consulta de slot para agendamento do reparo
    Retornar Slot Agendamento V2            orderType=ChamadoTecnico                priorityFlag=true

191.11 - Realizar agendamento do reparo
    Realizar Agendamento V2                 appointmentReason=Chamado Técnico de Fibra

191.13 - Validar no FSL
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global
    Validar Criação do SA de Reparo

191.14- Realizar resolução da pendência
    Tratamento de Pendencia TroubleTicket

191.15 - Validar no SOM resolução da pendência de agendamento
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Ordem_tipo}                       
    
    @{RETORNO}=                             Create List                             associatedDocument                      Type
    ...                                     customerName                            workOrderID

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T088 - Executar BA Planta Externa Chamado Tecnico
    ...                                     ORDER_STATE=In Progress	
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

XX.XX - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL              activityType=4934

XX.XX - Troca de técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

191.16 - Realizar o Encerramento do Reparo via FSL
    Atualiza Status SA
    Encerrar o SA - Reparo

191.17 - Validar Mudanças de Estado no FW 
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                           tns:name

191.18 - Auditoria de Tarefas
    Auditoria de Tarefas

191.19 - Validar no SOM o Encerramento do Reparo
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Completed

191.20 - Validar retorno do encerramento do Som no FW
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     RETORNO_ESPERADO=Chamado Técnico tratado com sucesso
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: TroubleTicket][NOTIF_TYPE: StatusChange]"]/../..//textarea