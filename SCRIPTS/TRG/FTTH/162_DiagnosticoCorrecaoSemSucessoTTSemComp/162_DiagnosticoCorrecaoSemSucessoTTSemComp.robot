*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: subscriberId, Address_Id, InventoryId, TypeComplement1, Value1, InfraType, Type, Customer_Name, status, Atribuir_tecnico, errorCode, Valor_Pendencia
...                                         OUTPUT: code, type, state, PreDiag_ID, Diag_ID, Associated_Document_Date, Appointment_Start, Appoointment_Finish, associatedDocument, Work_Order_Id, Estado, troubleTicket_id

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
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
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0035_ConfiguracoesRemotas/ROB0035_ConfiguracoesRemotas.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/162_DiagnosticoCorrecaoSemSucessoTTSemComp.xlsx

*** Test Cases ***
162.01 - Gerar Token de Acesso
    [Tags]                                  COMPLETO
    Retornar Token Vtal

162.02 - Realizar configuração na ferramenta de mock
    [Tags]                                  COMPLETO
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01                           RESET_JSON=SIM

162.03 - Realizar pre-diagnostico
    [Tags]                                  COMPLETO
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

162.04 - Validar retorno do pre-diagnostico no FW
    [Tags]                                  COMPLETO
    Escrever Variavel na Planilha           preDiagnostic                           type                                    Global
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=type,state
162.05 - Realizar Diagnostico
    [Tags]                                  COMPLETO
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

162.06 - Validar retorno do diagnostico no FW
    [Tags]                                  COMPLETO
    Escrever Variavel na Planilha           diagnostic                              type                                    Global
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Escrever Variavel na Planilha           NOK                                     code                                    Global
    Validar Evento FW                       VALOR_BUSCA=diagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,code

162.07 - Abrir Chamado Técnico
    [Tags]                                  COMPLETO
    Abrir Chamado Tecnico sem complemento                                           problem_description=Problema de conectividade                                   problem_origin= 

162.09 - Tramitar no SOM o reparo até a Tarefa T070 - Agendamento de Reparo
    [Tags]                                  COMPLETO
    @{LIST}=                                Create List                             ${SOM_Processo_Nome}                    ${SOM_Pendencia_Valor}
    
    @{RETORNO}=                             Create List                             Type                                    valorPendencia

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T070 - Agendamento do Reparo	
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=25

162.10 - Realizar consulta de slot para agendamento do reparo
    [Tags]                                  COMPLETO
    Retornar Slot Agendamento Reparo

162.11 - Realizar agendamento do reparo
    [Tags]                                  COMPLETO
    Realizar Agendamento de Reparo
    
162.13 - Realizar resolução da pendência
    [Tags]                                  COMPLETO
    Tratamento de Pendencia TroubleTicket

162.14 - Validar no SOM a resolução da pendência de agendamento
    [Tags]                                  COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Ordem_tipo}                       
    ...                                     ${SOM_Numero_BA}
    
    @{RETORNO}=                             Create List                             associatedDocument                      Type
    ...                                     workOrderId

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T088 - Executar BA Planta Externa Chamado Tecnico
    ...                                     ORDER_STATE=In Progress	
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    
162.15 - Realizar o Encerramento da pendência do agendamento via FSL
    [Tags]                                  COMPLETO
    Atualiza Status SA
    Encerrar a Pendencia do Agendamento
    Close Browser                           CURRENT

162.16/20 - Validar Mudança de Status do FSL no FW Console
    [Tags]                                  COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name

162.21 - Auditoria de Tarefas
    [Tags]                                  COMPLETO
    Auditoria de Tarefas

162.22 - Validar no SOM o encerramento da pendência de agendamento
    [Tags]                                  COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Completed

162.23 - Validar retorno do encerramento da pendência no FW
    [Tags]                                  COMPLETO
    Validar Evento FW                       VALOR_BUSCA=troubleTicketId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=(//*[text()="Evento Origem SOM [API_TYPE: TroubleTicket][NOTIF_TYPE: StatusChange]"]/../..//textarea)[1]        
    ...                                     DADOS_XML=Ordem Encerrada com Sucesso

####################################################################################################################################################################
# PARTE A
####################################################################################################################################################################
162.01 - Gerar Token de Acesso
    [Tags]                                  SCRIPT_A
    Retornar Token Vtal

162.02 - Realizar configuração na ferramenta de mock
    [Tags]                                  SCRIPT_A
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01                           RESET_JSON=SIM

162.03 - Realizar pre-diagnostico
    [Tags]                                  SCRIPT_A
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

162.04 - Validar retorno do pre-diagnostico no FW
    [Tags]                                  SCRIPT_A
    Escrever Variavel na Planilha           preDiagnostic                           type                                    Global
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=type,state
162.05 - Realizar Diagnostico
    [Tags]                                  SCRIPT_A
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

162.06 - Validar retorno do diagnostico no FW
    [Tags]                                  SCRIPT_A
    Escrever Variavel na Planilha           diagnostic                              type                                    Global
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Escrever Variavel na Planilha           NOK                                     code                                    Global
    Validar Evento FW                       VALOR_BUSCA=diagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=state,code

162.07 - Abrir Chamado Técnico
    [Tags]                                  SCRIPT_A
    Abrir Chamado Tecnico sem complemento                                           problem_description=Problema de conectividade                                   problem_origin= 

162.09 - Tramitar no SOM o reparo até a Tarefa T070 - Agendamento de Reparo
    [Tags]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Processo_Nome}                    ${SOM_Pendencia_Valor}
    
    @{RETORNO}=                             Create List                             Type                                    valorPendencia

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T070 - Agendamento do Reparo	
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=25

162.10 - Realizar consulta de slot para agendamento do reparo
    [Tags]                                  SCRIPT_A
    Retornar Slot Agendamento Reparo

162.11 - Realizar agendamento do reparo
    [Tags]                                  SCRIPT_A
    Realizar Agendamento de Reparo
    
162.13 - Realizar resolução da pendência
    [Tags]                                  SCRIPT_A
    Tratamento de Pendencia TroubleTicket

162.14 - Validar no SOM a resolução da pendência de agendamento
    [Tags]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Ordem_tipo}                       
    ...                                     ${SOM_Numero_BA}
    
    @{RETORNO}=                             Create List                             associatedDocument                      Type
    ...                                     workOrderId

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T088 - Executar BA Planta Externa Chamado Tecnico
    ...                                     ORDER_STATE=In Progress	
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
####################################################################################################################################################################
# PARTE B
####################################################################################################################################################################
162.15 - Realizar o Encerramento da pendência do agendamento via FSL
    [Tags]                                  SCRIPT_B
    Atualiza Status SA
    Encerrar a Pendencia do Agendamento
    Close Browser                           CURRENT

162.16/20 - Validar Mudança de Status do FSL no FW Console
    [Tags]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name

162.21 - Auditoria de Tarefas
    [Tags]                                  SCRIPT_B
    Auditoria de Tarefas

162.22 - Validar no SOM o encerramento da pendência de agendamento
    [Tags]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem
    ...                                     ORDER_STATE=Completed

162.23 - Validar retorno do encerramento da pendência no FW
    [Tags]                                  SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=troubleTicketId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=(//*[text()="Evento Origem SOM [API_TYPE: TroubleTicket][NOTIF_TYPE: StatusChange]"]/../..//textarea)[1]        
    ...                                     RETORNO_ESPERADO=Ordem Encerrada com Sucesso