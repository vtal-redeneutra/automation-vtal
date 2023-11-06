*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: IdBlock


Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/COMMON/RES_EXCEL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/SOM/UTILS.robot
Resource                                    ../../../RESOURCE/FSL/UTILS.robot
Resource                                    ${DIR_MS}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0045_ReparoVoip/ROB0045_ReparoVoip.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/177_ReparoVoipBLPlantaExternaFechamentoViaFSL.xlsx


*** Test Cases ***
177.01 - Gerar Token de Acesso 
    Retornar Token Vtal

177.02 - Realizar a Criação de Reparo
    Criar Ordem de Reparo Voip

177.03 - Validar a Notificação da Criação de Reparo no Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderCreateEvent referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     msg:Description                         Sucesso

177.04 - Validar a Criação de Reparo via SOM
    Validar Criação de Reparo Voip no SOM

xx.xx - Realizar o Reagendamento via API
    Reagendar Pedido OPM e FSL              activityType=4934

xx.xx - Atribuir técnico no Field Service no Field Service
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

177.05-07-09 - Realizar o Encerramento de Reparo via FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Criação do SA de Reparo
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atribuicao do tecnico auxiliar
    Encerrar SA Voip

177.06-08-10 - Validar Mudança de Status no Microserviços
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name

177.11 - Auditoria de Tarefas
    Auditoria de Tarefas

177.12 - Validar no Field Service
    Valida SA no Field Service              atividadeSA=REPARO FIBRA

177.13 - Realizar Validação de Retorno via SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Fibra Reparo

177.14 - Validar a Notificação de Encerramento no Microserviços
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por SingleNotificationManagement.SOM referente ao associatedDocument
    Validar texto do Bloco com o Argumento    Evento Origem SOM [API_TYPE: TroubleTicket][NOTIF_TYPE: StatusChange]       Reparo Encerrado
