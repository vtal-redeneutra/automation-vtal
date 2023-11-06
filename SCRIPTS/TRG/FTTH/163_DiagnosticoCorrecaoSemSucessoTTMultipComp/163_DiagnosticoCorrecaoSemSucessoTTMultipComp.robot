*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Customer_Name, Phone_Number, Reference,
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot

Suite Setup                                 Setup cenario                           Bitstream

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
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/163_DiagnosticoCorrecaoSemSucessoTTMultipComp.xlsx

*** Test Cases ***
163.01 - Gerar Token de Acesso
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

163.02 - Realizar configuração na ferramenta de mock
    [TAGS]                                  SCRIPT_A
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01                           RESET_JSON=SIM

163.03 - Realizar pre-diagnostico
    [TAGS]                                  SCRIPT_A
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

163.04 - Validar retorno do pre-diagnostico no Microserviços
    [TAGS]                                  SCRIPT_A
    Escrever Variavel na Planilha           preDiagnostic                           type                                    Global
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT         XML    INVOKE - Request enviado para a ClienteCo        state                   state
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado para a ClienteCo        type                    preDiagnostic
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço                     msg:Description         Sucesso

163.05 - Realizar Diagnostico
    [TAGS]                                  SCRIPT_A
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

163.06 - Validar retorno do diagnostico no Microserviços
    [TAGS]                                  SCRIPT_A
    Escrever Variavel na Planilha           diagnostic                              type                                    Global
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao diagId
    Validar dado do Bloco com a DAT         XML    INVOKE - Request enviado para a ClienteCo        state                   state
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado para a ClienteCo        type                    diagnostic
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço                     msg:Description         Sucesso

163.07 - Abrir Chamado Técnico
    [TAGS]                                  SCRIPT_A
    Abrir Chamado Tecnico                   problem_description=PROBLEMA DE CONECTIVIDADE

163.08 - Validar no SOM a abertura do reparo
    [TAGS]                                  SCRIPT_A
    Validar Criação de Reparo SOM

163.09 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Retornar Slot Agendamento Reparo    
    Realizar Agendamento de Reparo

163.10 - Realizar Resolução da Pendência (7029)
    [TAGS]                                  SCRIPT_A
    Resolucao Pendencia 7029

163.11 – Validar no SOM a resolução da pendência de agendamento
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Ordem_tipo}
    ...                                     ${SOM_Numero_BA}
    
    @{RETORNO}=                             Create List                             associatedDocument                      Type
    ...                                     workOrderId

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T088 - Executar BA Planta Externa Chamado Tecnico
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

#===================================================================================================================================================================

163.12 - Validação SA no FSL
    [TAGS]                                  SCRIPT_B
    Escrever Variavel na Planilha           Atribuído                               Estado                                    Global
    Validar SA de Reparo Bitstream no FSL

163.13-15-17 - Realizar o Encerramento da SA via OPM
    [TAGS]                                  SCRIPT_B
    Colocar SA em execucao
    Validar SA de Reparo Bitstream no FSL
    Close Browser 
    Finalizar SA no OPM
    Validar SA de Reparo Bitstream no FSL

163.14-16-18 - Validar Mudança de Status no FW Console
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

163.19 - Validar no Field Service    
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service

163.20 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas

163.21 - Realizar Validação de Encerramento via SOM
    [TAGS]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Bitstream Chamado Tecnico Ordem

163.22 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por TroubleTicketManagement.NotificarStatusTroubleTicket referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado ao API Gateway                                  msg:Description                         Ordem Encerrada com Sucesso
