*** Settings ***

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/RESOURCE/SOM/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/RESOURCE/FW/UTILS.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/190_InstalacaoComPrioridade.xlsx


*** Test Cases ***

190.01 - Gerar Token de Acesso 
    Retornar Token Vtal

190.02/03 - Consulta de Logradouro
    Consulta Id Logradouro

190.04 - Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

190.05 - Consulta de Slots
    Retornar Slot Agendamento V2            priorityFlag=true       

190.06 - Realizar Agendamento
    Realizar Agendamento V2
                        
190.07 - Validar Agendamento no FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global 
    Validacao Basica FSL                    true 

190.08 - Validar Agendamento no FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

190.09 - Realizar Criação de Ordem 
    Criar Ordem Agendamento                 

190.10 - Validar Criação de Ordem no FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.NotificationCreatedOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<
    
# 190.11 - Validar Notificação nos MicroServicos

190.12 - Validar Criação de Ordem no SOM
    @{LIST}=                                Create List                             
    ...                                     ${SOM_Numero_Pedido}                                 
                                                        
    @{RETORNO}=                             Create List                             
    ...                                     associatedDocument                       
                                                               

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    
XX.XX - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL              

XX.XX - Troca de técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

01.13 - Realizar o Encerramento da OS de Instalação via FSL
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Close Browser                           CURRENT

01.14 - Validar Mudanças de Estado no FW 
    ${state_list}=                            Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW             subscriberId              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

01.15 - Auditoria de Tarefas
    Auditoria de Tarefas

01.16 - Validar Ordem Completa no SOM
    Validar Evento Simples SOM              associatedDocument                      ORDER_TYPE=Vtal Fibra Instalação        ORDER_STATE=Completed       

01.17 - Validar Notificação de Encerramento FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<
