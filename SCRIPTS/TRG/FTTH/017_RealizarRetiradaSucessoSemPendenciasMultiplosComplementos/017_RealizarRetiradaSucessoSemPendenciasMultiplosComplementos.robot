*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: 
...                                         OUTPUT: 


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/017_RealizarRetiradaSucessoSemPendênciasMultiplosComplementos.xlsx


*** Test Cases ***

17.01 - Gerar Token de Acesso 
    Retornar Token Vtal

17.02 - Realizar Consulta de Slots Para Atividade de Retirada
    Retornar Slot Agendamento Retirada

17.03 - Realizar Agendamento de Retirada
    Realizando Agendamento Retirada
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

17.04 - Validar Notificação do Agendamento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<
    
17.05 - Validar a Criação do SA de Retirada via FLS
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT
   
17.06 - Realizar Abertura da Ordem de Retirada
    Criar Ordem de Retirada                 FTTH_ou_FTTP=FTTH                       VELOCIDADE=400        
   
17.07 - Realizar Validação no SOM
    Valida Ordem SOM Retirada
    Close Browser                           CURRENT

17.08 - Validar Notificação de Criação da Ordem via FW Console
    Validar Criação da Ordem                associatedDocument
    
17.09 - Realizar Reagendamento
    Reagendar Pedido OPM e FSL Retirada
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global

17.10 - Validar Notificação de Atualização via FW Console 
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PatchAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<
    
17.11 - Validar a Atualização do Agendamento via FLS
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT

17.12 - Realizar Atribuição ao Técnico via FLS
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

17.13 - Encerrar a OS de Retirada 
    Atualiza Status SA
    Atualizar e Encerrar o SA - Retirada
    Close Browser                           CURRENT

17.14 - Valida a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>200<
    
17.15 - Validar o Encerramento da Ordem no SOM
    Validar Ordem SOM Retirada Completa     FTTH                                    400
    Close Browser                           CURRENT

17.16 - Validar Mudança de Estados no FW
    ${state_list}=                          Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

17.17 - Auditoria de Tarefas
    Auditoria de Tarefas