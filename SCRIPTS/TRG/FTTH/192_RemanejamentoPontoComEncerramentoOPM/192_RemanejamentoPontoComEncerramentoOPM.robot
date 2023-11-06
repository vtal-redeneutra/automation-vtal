*** Settings ***

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/192_RemanejamentoPontoComEncerramentoOPM.xlsx

*** Test Cases ***
####################################################################################################################################################################
# PARTE A
####################################################################################################################################################################
192.01 - Gerar Token de Acesso
    [Tags]                                  SCRIPT_A
    Retornar Token Vtal

192.02 - Realizar Consulta de Slots-Remanejamento de ponto
    [Tags]                                  SCRIPT_A
    Retornar Slot Agendamento V2            orderType=RemanejamentoPonto

192.03 - Realizar o Agendamento
    [Tags]                                  SCRIPT_A
    Realizar Agendamento V2                 appointmentReason=Remanejamento de Ponto

# 192.04 - Validar Notificação do Agendamento no MicroServiços


192.05 - Validar agendamento no FSL
    [Tags]                                  SCRIPT_A
    Validar SA Simples                      valorConta= 
    ...                                     valorOrigem= 
    ...                                     valorProntoExecucao=unchecked
    ...                                     validarEstado=False

192.06 - Validar no Field Service técnico habilitado para Remanejamento de ponto
    [Tags]                                  SCRIPT_A
    Valida Tecnico Habilitado no Field Service    habilitacao=FTTHREMCP
    

192.07 - Realizar a Criação de Ordem (OS) Remanejamento de Ponto
    [Tags]                                  SCRIPT_A
    Criar Ordem Agendamento                 orderType=RemanejamentoPonto            

192.08 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [Tags]                                  SCRIPT_A
    Validar Criação da Ordem                order_type=RemanejamentoPonto

# 192.09 - Validar a Notificação da Criação de Ordem no MicroServiços


192.10 - Validar a Criação da OS via SOM
    [Tags]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Customer_Name}
    ...                                     ${SOM_Numero_Pedido}

    @{RETORNO}=                             Create List                             customerName
    ...                                     associatedDocument

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Executar BA de Remanejamento de ponto
    ...                                     ORDER_TYPE=Remanejamento de ponto
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30

XX.XX - Troca de técnico via FSL
    [Tags]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

192.11 - Validar no FSL
    [Tags]                                  SCRIPT_A
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar SA Simples                      valorConta=TRGIBM
    ...                                     valorOrigem=TRGIBM
    ...                                     valorProntoExecucao=checked

####################################################################################################################################################################
# PARTE B
####################################################################################################################################################################
192.12 - Encerrar o SA via OPM
    [Tags]                                  SCRIPT_B
    Colocar SA em execucao
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    Validar Estado do pedido FSL
    Close Browser 
    Colocar Sa concluida - Remanejamento de Ponto
    ...                                     adicionarMaterial=SIM
    ...                                     adicionarAuxilio=SIM

192.13 - Validar Mudança de Status no FW Console
    [Tags]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           subscriberId                            ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name

# 192.18 - Validar a Notificação do Encerramento de Ordem no MicroServiços


192.19 - Validar no FSL
    [Tags]                                  SCRIPT_B
    Validar SA Simples                      valorConta=TRGIBM
    ...                                     valorOrigem=TRGIBM
    ...                                     valorProntoExecucao=checked

192.20 - Auditoria de Tarefas
    [Tags]                                  SCRIPT_B
    Auditoria de Tarefas

192.21 - Realizar Validação de Retorno via SOM
    [Tags]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Remanejamento de ponto

192.22 - Validar a Notificação de Encerramento via FW Console
    [Tags]                                  SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=Ordem Encerrada com Sucesso