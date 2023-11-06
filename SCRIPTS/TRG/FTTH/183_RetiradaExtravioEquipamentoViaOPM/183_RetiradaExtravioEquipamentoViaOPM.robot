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
${DAT_CENARIO}                              ${DIR_DAT}/183_RetiradaExtravioEquipamentoViaOPM.xlsx


*** Test Cases ***

   
183.01 - Gerar Token de Acesso
    [Tags]                                  COMPLETO
    Retornar Token Vtal
    
183.02 - Realizar Consulta de Slots Para Atividade de Retirada
    [Tags]                                  COMPLETO
    Retornar Slot Agendamento Retirada

183.03 - Realizar Agendamento de Retirada
    [Tags]                                  COMPLETO
    Realizar Agendamento de Retirada 
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

183.04 - Validar a Criação do SA de Retirada via FSL
    [Tags]                                  COMPLETO
    Validar a Criação do SA de Retirada
    
183.05 - Validar a Notificação de abertura do Agendamento de Retirada
    [Tags]                                  COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

183.06 - Realizar Abertura da Ordem de Retirada
    [Tags]                                  COMPLETO
    Criar Ordem de Retirada

183.07 - Realizar Validação no SOM
    [Tags]                                  COMPLETO
    Valida Ordem SOM Retirada

183.08 - Validar a Notificação de abertura da OS de Retirada
    [Tags]                                  COMPLETO
    Validar Criação da Ordem                associatedDocument                      code>200<                               Retirada

183.09 - Realizar o Reagendamento
    [Tags]                                  COMPLETO
    Reagendar Pedido OPM e FSL Retirada
 
183.10-11 - Atribuir o Técnico via FSL
    [Tags]                                  COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

183.12 - Realizar Atribuição do Técnico Habilitado para Encerramento via OPM
    [Tags]                                  COMPLETO
    Atribuicao do tecnico auxiliar
    Close Browser                           CURRENT

183.13 - Realizar Encerramento via OPM
    [Tags]                                  COMPLETO
    Colocar SA em execucao
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT
    Colocar Sa Concluida - Retirada         Extravio=True

183.14 - Validar a Notificação de Encerramento da OS via SOM
    [Tags]                                  COMPLETO
    Validar Ordem SOM Retirada Completa

183.15 - Validar a Notificação de Encerramento da OS de Retirada via FW
    [Tags]                                  COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

183.16 - Validar Mudança de Estados no FW
    [TAGS]                                  COMPLETO
    ${state_list}=                            Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW             associatedDocument              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

183.17 - Auditoria de Tarefas
    [Tags]                                  COMPLETO
    Auditoria de Tarefas
    


#===================================================================================================================================================================
#SCRIPT PARTE A
#===================================================================================================================================================================


  
183.01 - Gerar Token de Acesso
    [Tags]                                  PARTE_A
    Retornar Token Vtal
    
183.02 - Realizar Consulta de Slots Para Atividade de Retirada
    [Tags]                                  PARTE_A
    Retornar Slot Agendamento Retirada

183.03 - Realizar Agendamento de Retirada
    [Tags]                                  PARTE_A
    Realizar Agendamento de Retirada 
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

183.04 - Validar a Criação do SA de Retirada via FSL
    [Tags]                                  PARTE_A
    Validar a Criação do SA de Retirada
    
183.05 - Validar a Notificação de abertura do Agendamento de Retirada
    [Tags]                                  PARTE_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

183.06 - Realizar Abertura da Ordem de Retirada
    [Tags]                                  PARTE_A
    Criar Ordem de Retirada

183.07 - Realizar Validação no SOM
    [Tags]                                  PARTE_A
    Valida Ordem SOM Retirada

183.08 - Validar a Notificação de abertura da OS de Retirada
    [Tags]                                  PARTE_A
    Validar Criação da Ordem                associatedDocument                     code>200<                               Retirada

183.10-11 - Atribuir o Técnico via FSL
    [Tags]                                  PARTE_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    
183.12 - Realizar Atribuição do Técnico Habilitado para Encerramento via OPM
    [Tags]                                  PARTE_A
    Atribuicao do tecnico auxiliar
    Close Browser                           CURRENT


#===================================================================================================================================================================
#SCRIPT PARTE B
#===================================================================================================================================================================

183.13 - Realizar Encerramento via OPM
    [Tags]                                  PARTE_B
    Colocar SA em execucao
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT
    Colocar Sa Concluida - Retirada         Extravio=True

183.14 - Validar a Notificação de Encerramento da OS via SOM
    [Tags]                                  PARTE_B
    Validar Ordem SOM Retirada Completa

183.15 - Validar a Notificação de Encerramento da OS de Retirada via FW
    [Tags]                                  PARTE_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

183.16 - Validar Mudança de Estados no FW
    [TAGS]                                  PARTE_B
    ${state_list}=                            Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW             associatedDocument              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

183.17 - Auditoria de Tarefas
    [Tags]                                  PARTE_B
    Auditoria de Tarefas
   

