*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: 
...                                         OUTPUT: 


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0030_EnriquecimentoMassaSOM/ROB0030_EnriquecimentoMassaSOM.robot
Resource                                    C:/IBM_VTAL/SCRIPTS/ROBS/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/018_RealizarRetiradaSucessoSemComplementoAgendamentoViaOPM.xlsx


*** Test Cases ***
18.01 - Gerar Token de Acesso 
    Retornar Token Vtal

18.02 - Realizar Consulta de Slots Para Atividade de Retirada
    Retornar Slot Agendamento Retirada
    
18.03 - Realizar Agendamento de Retirada    
    Realizando Agendamento Retirada
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    
18.04 - Validar a Criação do SA de Retirada via FLS
    Validar a Criação do SA de Retirada

18.05 - Validar a Notificação de Abertura do Agendamento de Retirada
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

18.06 - Realizar Abertura da Ordem de Retirada
    Criar Ordem Agendamento Retirada

18.07 - Realizar Validação no SOM
    Valida Ordem SOM Retirada
    Close Browser                           CURRENT

# 18.08 - Validar a Notificação de Abertura da OS de Retirada
#     Validar Evento FW                       VALOR_BUSCA=associatedDocument
#     ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]
#     ...                                     RETORNO_ESPERADO=>200<

18.09 - Realizar o Reagendamento
    Reagendar Pedido OPM e FSL Retirada
    Escrever Variavel na Planilha           Não atribuído                               Estado                                  Global

18.10 - Validar a atualização via FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Retornar Token Vtal
    Validar a Criação do SA de Retirada

18.11- Validar a Notificação após Atualização do Agendamento
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PatchAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<

18.xx - Troca de técnico
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

18.12 - Realizar Enriquecimento do SA Incluindo a Pendência 7065
    Atualiza Status SA
    Encerrar SA com Pendencia 7065
    Close Browser                           CURRENT

18.13 - Validar a Notificação de Encerramento da OS de Retirada
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderInformationRequiredEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<
    
18.14 - Validar o Enriquecimento da Massa via SOM
    Validar Ordem SOM Enriquecimento

18.15 - Realizar Novo Agendamento
    Retornar Token Vtal
    Realizar Novo Agendamento de Retirada 
    Escrever Variavel na Planilha           Atribuído                           Estado                                  Global

18.16 - Valida a Criação do Agendamento via FSL
    Validar a Criação do SA de Retirada

18.17 - Valida a Notificação do Novo Agendamento via FW console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

18.18 - Enviar a Atualização da Ordem (PATCH) Retirando a Pendência 7065
    Retornar Token Vtal
    Tratamento de Pendencia 7065
   
18.19 - Validar Notificação de Reagendamento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

18.20 - Validar Atualização da Atividade via SOM
    Valida Ordem SOM Retirada

18.21 - Validar a Criação do Novo SA de Retirada via FSL
    Validar a Criação do SA de Retirada

18.22 - Reagendar a Data de Retirada
    Reagendar Pedido OPM e FSL Retirada

18.23 - Valida no FW Console após Atualização do Agendamento
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<
    
18.24 - Realizar Atribuição via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT
    
18.25 - Realizar o Encerramento da Ordem de Retirada via FSL
    Atualiza Status SA
    Atualizar e Encerrar o SA - Retirada
    Close Browser                           CURRENT

18.26 - Validar o Retorno de Conclusão no SOM
    Validar Ordem SOM Retirada Completa

18.27 - Validar Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

18.28 - Validar Mudança de Estados no FW
    ${state_list}=                            Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY      ACTIVITY_CONCLUDED_UNSUCESSFULLY

    Validar Mudancas de Estado FW             subscriberId              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

18.29 - Auditoria de Tarefas
    Auditoria de Tarefas