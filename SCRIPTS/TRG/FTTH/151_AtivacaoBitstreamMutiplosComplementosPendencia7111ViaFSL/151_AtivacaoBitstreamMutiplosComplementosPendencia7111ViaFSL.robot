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
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/151_AtivaçãoBitstreamMutiplosComplementosPendência7111ViaFSL.xlsx

*** Test Cases ***
151.01 - Gerar Token de Acesso 
    Retornar Token Vtal

151.02/03 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

151.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos Bitstream

151.05 - Realizar Consulta de Slots
    Consulta Slot Agendamento

151.06 - Realizar o Agendamento
    Realizar Agendamento

151.07 - Validar a Notificação do Agendamento
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar dado do Bloco com o Argumento    XML     END - Finalização do serviço    tns:code    201

151.08 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400  
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

151.09 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderCreateEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204

151.10 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    
                                   
    @{RETORNO}=                             Create List                             associatedDocument                     

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

151.11 - Atualização do patch de tarefa “TA - Notificar Recursos Tenant”
    Resolucao pendencia Tenant

151.12 - Validar a Notificação da resolução de tarefa via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

151.13 - Validar a atualização da tarefa via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    
                                   
    @{RETORNO}=                             Create List                             associatedDocument                     

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

151.14 - Realizar o Reagendamento via API
    Reagendar Pedido OPM e FSL

151.15 - Atribuir técnico no Field Service 
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

151.16/18/20 - Realizar o Encerramento da OS de Instalação via FSL
    Validar Atribuicao Automatica Bitstream FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA - Bitstream   EQUIPAMENTO=ONT TIM SAGEM FAST5670 WI-FI 6
    Encerrar SA Bitstream                   7111                                    Encerramento Pendencia                  Concluído sem sucesso
    Close Browser                           CURRENT

151.17/19/21 - Validar Mudança de Status do FSL no FW Console
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_UNSUCESSFULLY                    

    Validar Mudancas de Estado FW           subscriberId                            ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
    Close Browser                           CURRENT

151.22 - Validar no Field Service
    Valida SA no Field Service
   
151.23 - Auditoria de Tarefas
    Auditoria de Tarefas                    estado_encerramento=Concluído sem sucesso

151.24 - Realizar Validação de Pendência 7111 via SOM
    Validar a pendencia Tenant 7111         TASK_NAME=TA - Tratar Pendência Tenant  VALIDACAO=1

151.25 - Realizar o Agendamento
    Realizar Agendamento para o dia seguinte

151.26 - Validar a Notificação do Agendamento
    Validar a Notificação de Agendamento
    
151.27 - Realizar resolução da pendência (7111)
    Resolucao Pendencia 7111

151.28 - Validar a Notificação da resolução de tarefa via FW Console
    Validar Notificação de resolução de tarefa

151.29 - Realizar Validação de Pendência 7111 via SOM    
    Validar a pendencia Tenant 7111         TASK_NAME=T017 - Instalar Equipamento   VALIDACAO=2

XX.XX - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL

151.30 - Atribuir técnico no field service no Field Service
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

151.31/33/35 - Realizar o Encerramento da OS de Instalação via FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA - Bitstream   EQUIPAMENTO=ONT TIM SAGEM FAST5670 WI-FI 6
    Encerrar SA Bitstream                   00                                      Encerramento Bit                        Concluído com sucesso
    Close Browser                           CURRENT

151.32/34/36 - Validar Mudança de Status do FSL no FW Console
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name

151.37 - Validar no Field Service
    Valida SA no Field Service

151.38 - Auditoria de Tarefas
    Auditoria de Tarefas

151.39 - Realizar Validação de Encerramento via SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

151.40 - Validar Encerramento no FW Console
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204