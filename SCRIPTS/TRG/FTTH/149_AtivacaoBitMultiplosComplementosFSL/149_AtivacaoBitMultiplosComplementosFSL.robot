*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,



Suite Setup                                 Setup cenario                           Bitstream


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_MS}/UTILS.robot
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
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/149_AtivacaoBitMultiplosComplementosFSL.xlsx

*** Test Cases ***
149.01 - Gerar Token de Acesso
    [Tags]                                  COMPLETO
    Retornar Token Vtal

149.02/03 - Realizar Consulta de Logradouro
    [Tags]                                  COMPLETO
    Consulta Id Logradouro

149.04 - Realizar Consulta de Viabilidade
    [Tags]                                  COMPLETO
    Retorna Viabilidade dos Produtos Bitstream

149.05 - Realizar Consulta de Slots
    [Tags]                                  COMPLETO
    Consulta Slot Agendamento

149.06 - Realizar o Agendamento
    [Tags]                                  COMPLETO
    Realizar Agendamento

149.07 - Validar a Notificação do Agendamento
    [Tags]                                  COMPLETO
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar dado do Bloco com o Argumento    XML     END - Finalização do serviço    tns:code    201


149.08 - Realizar a Criação de Ordem (OS)
    [Tags]                                  COMPLETO
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

149.09 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [Tags]                                  COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderCreateEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204
    
149.10 - Validar a Criação da OS de Instalação via SOM
    [Tags]                                  COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument   

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

149.11 - Atualização do patch de tarefa “TA - Notificar Recursos Tenant”
    [Tags]                                  COMPLETO
    Resolucao pendencia Tenant

149.12 - Validar a Notificação da resolução de tarefa via FW Console
    [Tags]                                  COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

149.13 - Validar a atualização da tarefa via SOM
    [Tags]                                  COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument   
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

149.14 - Realizar o Reagendamento via API
    [Tags]                                  COMPLETO
    Reagendar Pedido OPM e FSL

XX.XX - Atribuir técnico no Field Service no Field Service
    [Tags]                                  COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

149.15 - Realizar o Encerramento da OS de Instalação via FSL
    [Tags]                                  COMPLETO
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA - Bitstream                                           EQUIPAMENTO=ONT TIM SAGEM FAST5670 WI-FI 6
    Encerrar com Sucesso
    Close Browser                           CURRENT

149.16/20 - Validar Mudança de Status do FSL no FW Console
    [Tags]                                  COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name

149.21 - Validar no Field Service
    [Tags]                                  COMPLETO
    Valida SA no Field Service

149.22 - Auditoria de Tarefas
    [Tags]                                  COMPLETO
    Auditoria de Tarefas

149.24 - Realizar Validação de Retorno via SOM
    [Tags]                                  COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação

149.25 - Validar a Notificação de Encerramento via FW Console
    [Tags]                                  COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204

####################################################################################################################################################################
# PARTE A
####################################################################################################################################################################
149.01 - Gerar Token de Acesso
    [Tags]                                  SCRIPT_A
    Retornar Token Vtal

149.02/03 - Realizar Consulta de Logradouro
    [Tags]                                  SCRIPT_A
    Consulta Id Logradouro

149.04 - Realizar Consulta de Viabilidade
    [Tags]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos Bitstream

149.05 - Realizar Consulta de Slots
    [Tags]                                  SCRIPT_A
    Consulta Slot Agendamento

149.06 - Realizar o Agendamento
    [Tags]                                  SCRIPT_A
    Realizar Agendamento

149.07 - Validar a Notificação do Agendamento
    [Tags]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar dado do Bloco com o Argumento    XML     END - Finalização do serviço    tns:code    201

149.08 - Realizar a Criação de Ordem (OS)
    [Tags]                                  SCRIPT_A
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

149.09 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [Tags]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderCreateEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204
    
149.10 - Validar a Criação da OS de Instalação via SOM
    [Tags]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument   

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

149.11 - Atualização do patch de tarefa “TA - Notificar Recursos Tenant”
    [Tags]                                  SCRIPT_A
    Resolucao pendencia Tenant

149.12 - Validar a Notificação da resolução de tarefa via FW Console
    [Tags]                                  SCRIPT_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

149.13 - Validar a atualização da tarefa via SOM
    [Tags]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument   
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

####################################################################################################################################################################
# PARTE B
####################################################################################################################################################################
149.14 - Realizar o Reagendamento via API
    [Tags]                                  SCRIPT_B
    Retornar Token Vtal
    Reagendar Pedido OPM e FSL

XX.XX - Atribuir técnico no Field Service no Field Service
    [Tags]                                  SCRIPT_B
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

149.15 - Realizar o Encerramento da OS de Instalação via FSL
    [Tags]                                  SCRIPT_B
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA - Bitstream                                           EQUIPAMENTO=ONT TIM SAGEM FAST5670 WI-FI 6
    Encerrar com Sucesso
    Close Browser                           CURRENT

149.16/20 - Validar Mudança de Status do FSL no FW Console
    [Tags]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name

149.21 - Validar no Field Service
    [Tags]                                  SCRIPT_B
    Valida SA no Field Service

149.22 - Auditoria de Tarefas
    [Tags]                                  SCRIPT_B
    Auditoria de Tarefas

149.24 - Realizar Validação de Retorno via SOM
    [Tags]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação

149.25 - Validar a Notificação de Encerramento via FW Console
    [Tags]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204