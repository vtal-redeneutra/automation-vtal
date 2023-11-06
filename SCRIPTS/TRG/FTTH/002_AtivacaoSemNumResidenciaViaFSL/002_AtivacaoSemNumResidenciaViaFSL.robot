*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,




Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
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
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot




*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/002_AtivacaoSemNumResidenciaViaFSL.xlsx



*** Test Cases ***
XX.XX - Gerar Token Acesso
    [TAGS]                                  COMPLETO
    Retornar Token Vtal

02.01-3 - Realizar Consulta de Logradouro
    [TAGS]                                  COMPLETO
    Consulta Id Logradouro

02.04-5 - Realizar Consulta de Viabilidade
    [TAGS]                                  COMPLETO
    Retorna Viabilidade dos Produtos

02.06 - Realizar Consulta de Slots
    [TAGS]                                  COMPLETO
    Consulta Slot Agendamento

02.07 - Realizar o Agendamento
    [TAGS]                                  COMPLETO
    Realizar Agendamento

02.08 - Realizar a Consulta do Agendamento
    [TAGS]                                  COMPLETO
    Consultar Agendamento

02.09 - Validar a Notificação do Agendamento
    [TAGS]                                  COMPLETO
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML     END - Finalização do serviço    tns:code    201

02.10 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  COMPLETO
    Criar Ordem Agendamento
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

02.11 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderCreateEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204   

02.12 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  COMPLETO
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                      

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                      ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30

XX.XX - Atualização da data de agendamento via API
    [TAGS]                                  COMPLETO
    Reagendar Pedido OPM e FSL

XX.XX - Troca de técnico via FSL
    [TAGS]                                  COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

02.13 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  COMPLETO
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL

02.14 - Validar Mudança de Estados no FW
    [TAGS]                                  COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

02.15 - Validar no Field Service
    [TAGS]                                  COMPLETO
    Valida SA no Field Service

02.16 - Realizar Validação de Retorno via SOM
    [TAGS]                                  COMPLETO
    Valida Ordem SOM Finalizada com sucesso

02.17 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204  

02.18 - Auditoria de Tarefas
    [TAGS]                                  COMPLETO
    Auditoria de Tarefas

#===========================================================================================================================#    

# SCRIPT A
XX.XX - Gerar Token de Acesso
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

02.01-3 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Id Logradouro

02.04-5 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

02.06 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Consulta Slot Agendamento

02.07 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento

02.08 - Realizar a Consulta do Agendamento
    [TAGS]                                  SCRIPT_A
    Consultar Agendamento

02.09 - Validar a Notificação do Agendamento
    [TAGS]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML     END - Finalização do serviço    tns:code    201

02.10 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
    Criar Ordem Agendamento
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

02.11 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderCreateEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204    

02.12 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                      

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                      ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30
    
XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

#===========================================================================================================================#    

02.13 - Realizar A Validação da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_B
    Validar Atribuicao Automatica FSL

02.14 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_B
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL

02.15 - Validar Mudança de Estados no FW
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

02.16 - Validar no Field Service
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service

02.17 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_B
    Valida Ordem SOM Finalizada com sucesso

02.18 - Validar a Notificação de Encerramento via FW Console
    [TAGS]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204 

02.19 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas