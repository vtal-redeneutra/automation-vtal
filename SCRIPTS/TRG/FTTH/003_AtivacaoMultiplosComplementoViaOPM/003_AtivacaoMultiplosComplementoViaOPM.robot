*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,



Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_OPM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_ROBS}/ROB0031_ValidarComplementoFSL/ROB0031_ValidarComplementoFSL.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/003_AtivacaoMultiplosComplementoViaOPM.xlsx


*** Test Cases ***

03.01 - Retornar Token Vtal
    [TAGS]                                  COMPLETO
    Retornar Token Vtal

03.02-3 - Realizar Consulta de Logradouro
    [TAGS]                                  COMPLETO
    Consulta Id Logradouro

03.04-5 - Realizar Consulta de Viabilidade
    [TAGS]                                  COMPLETO
    Retorna Viabilidade dos Produtos

03.06 - Realizar Consulta de Slots
    [TAGS]                                  COMPLETO
    Consulta Slot Agendamento

03.07 - Realizar o Agendamento
    [TAGS]                                  COMPLETO
    Realizar Agendamento
    
03.08 - Realizar a Consulta do Agendamento
    [TAGS]                                  COMPLETO
    Consultar o Agendamento

03.09 - Validar a Notificação do Agendamento
    [TAGS]                                  COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

03.10 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  COMPLETO
    Criar Ordem Agendamento                 
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

03.11 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  COMPLETO
    Validar Criação da Ordem                subscriberId                           >200<

03.12 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  COMPLETO
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                     


    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30

XX.XX - Atualização da data de agendamento via API
    [TAGS]                                  COMPLETO
    Reagendar Pedido OPM e FSL

03.13 - Atribuir Técnico Habilitado para Atividade de Encerramento via OPM
    [TAGS]                                  COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

03.14 - Encerrar o SA via OPM
    [TAGS]                                  COMPLETO
    Validar Complemento FSL
    Close Browser                           CURRENT
    Colocar SA em execucao
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    Validar Atribuicao Automatica FSL
    Close Browser                           CURRENT
    Colocar Sa concluida

03.15 - Validar Mudança de Estados no FW
    [TAGS]              COMPLETO
    ${state_list}=                          Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY

    Validar Mudancas de Estado FW           subscriberId              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

03.16 - Validar no FSL
    [TAGS]                                  COMPLETO                 
    Validar Estado do pedido FSL

03.17 - Validar no Field Service
    [TAGS]                                  COMPLETO
    Valida SA no Field Service

03.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  COMPLETO
    Valida Ordem SOM Finalizada com sucesso

03.19 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

03.20 - Auditoria de Tarefas
    [TAGS]              COMPLETO
    Auditoria de Tarefas

#===========================================================================================================================# 
# SCRIPT_A

03.01 - Retornar Token Vtal
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

03.02-3 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Id Logradouro

03.04-5 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

03.06 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Consulta Slot Agendamento

03.07 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento

03.08 - Realizar a Consulta do Agendamento
    [TAGS]                                  SCRIPT_A
    Consultar o Agendamento

03.09 - Validar a Notificação do Agendamento
    [TAGS]                                  SCRIPT_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

03.10 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
    Criar Ordem Agendamento                 
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

03.11 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  SCRIPT_A
    
    Validar Criação da Ordem                subscriberId                           >200<

03.12 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                     

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

03.13 - Validar a Atribuição do Técnico Habilitado para Atividade de Encerramento via OPM
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Validar Complemento FSL
    Close Browser                           CURRENT

#===========================================================================================================================# 
# SCRIPT_B
03.14 - Encerrar o SA via OPM
    [TAGS]                                  SCRIPT_B
    Colocar SA em execucao
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    Validar Atribuicao Automatica FSL
    Close Browser                           CURRENT
    Colocar Sa concluida

03.15 - Validar Mudança de Estados no FW
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                EN_ROUTE        IN_EXECUTION        ACTIVITY_CONCLUDED_SUCESSFULLY
    Validar Mudancas de Estado FW           subscriberId              ${state_list}              WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name      

03.16 - Validar no FSL
    [TAGS]                                  SCRIPT_B
    Validar Estado do pedido FSL

03.17 - Validar no Field Service
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service

03.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_B
    Valida Ordem SOM Finalizada com sucesso

03.19 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

03.20 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas
