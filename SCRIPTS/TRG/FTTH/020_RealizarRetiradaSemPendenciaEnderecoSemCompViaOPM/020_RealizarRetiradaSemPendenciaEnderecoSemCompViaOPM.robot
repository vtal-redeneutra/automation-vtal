*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_OPM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/020_RealizarRetiradaSemPendenciaEnderecoSemCompViaOPM.xlsx


*** Test Cases ***

   
20.01 - Gerar Token de Acesso
    Retornar Token Vtal
    
20.02 - Realizar Consulta de Slots Para Atividade de Retirada
    Retornar Slot Agendamento Retirada

20.03 - Realizar Agendamento de Retirada
    Realizar Agendamento de Retirada 
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

20.04 - Validar a Criação do SA de Retirada via FSL
    Validar a Criação do SA de Retirada
    
20.05 - Validar a Notificação de abertura do Agendamento de Retirada
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

20.06 - Realizar Abertura da Ordem de Retirada
    Criar Ordem de Retirada

20.07 - Realizar Validação no SOM
    Valida Ordem SOM Retirada

20.08 - Validar a Notificação de abertura da OS de Retirada
    Validar Criação da Ordem                associatedDocument                     code>200<                               Retirada

20.09 - Realizar o Reagendamento
    Reagendar Pedido OPM e FSL Retirada
 
20.10-11 - Atribuir o Técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    
20.12 - Realizar Atribuição do Técnico Habilitado para Encerramento via OPM
    Atribuicao do tecnico auxiliar
    Close Browser                           CURRENT

20.13 - Realizar Encerramento via OPM
    Colocar SA em execucao
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT
    Colocar Sa Concluida - Retirada

20.14 - Validar a Notificação de Encerramento da OS via SOM
    Validar Ordem SOM Retirada Completa

20.15 - Validar a Notificação de Encerramento da OS de Retirada via FW
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

20.16 - Validar Mudança de Estados no FW
    [TAGS]                                  COMPLETO
    ${state_list}=                          Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

20.17 - Auditoria de Tarefas
    Auditoria de Tarefas