*** Settings ***

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot

Suite Setup                                 Setup cenario                           Voip

Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_ROBS}/ROB0045_ReparoVoip/ROB0045_ReparoVoip.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/178_ReparoVoipBLPlantaExternaFechamentoViaOPM.xlsx


*** Test Cases ***
178.01 - Gerar Token de Acesso
    Retornar Token Vtal

178.02 - Realizar a Criação de Reparo
    Criar Ordem de Reparo Voip
    
178.03 - Validar a Notificação da Criação de Reparo via FW Console
    Validar FW Ordem CPOi                   VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]

178.04 - Validar a Criação de Reparo via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}

    @{RETORNO}=                             Create List                             associatedDocument
                        
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T039 - Executar BA de Planta Externa
    ...                                     ORDER_TYPE=Vtal Fibra Reparo
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     plantaExterna=True

178.05 - Reagendamento Via Api
    Reagendar Pedido OPM e FSL              4934

178.06 - Atribuir técnico no Field Service
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

178.07 - Encerrar o SA via OPM
    Colocar SA em execucao
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    Validar Criação do SA de Reparo
    Close Browser 
    Colocar Sa concluida - Reparo Planta Externa

178.08/12 - Validar Mudança de Status no FW Console
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name

178.13 - Auditoria de Tarefas
    Auditoria de Tarefas

178.14 - Validar no Field Service (Retirar)
    Valida SA no Field Service              atividadeSA=REPARO FIBRA

178.15 - Realizar Validação de Retorno via SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Fibra Reparo

178.16 - Validar a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: TroubleTicket][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Reparo Encerrado<