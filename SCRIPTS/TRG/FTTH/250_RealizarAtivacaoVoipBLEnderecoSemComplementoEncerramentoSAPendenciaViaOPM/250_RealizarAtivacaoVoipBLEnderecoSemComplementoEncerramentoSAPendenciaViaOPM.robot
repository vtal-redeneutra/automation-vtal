*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/250_RealizarAtivacaoVoipBLEnderecoSemComplementoEncerramentoSAPendenciaViaOPM.xlsx


*** Test Cases ***
250.01 - Gerar Token de Acesso 
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

250.02 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Logradouro CPOi

250.03 - Realizar Consulta de Complemento
    [TAGS]                                  SCRIPT_A
    Id Consulta Complemento

250.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

250.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Retornar Slot Agendamento V2            productType=Banda Larga,VoIP

250.06 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento V2                 appointmentReason=Instalacao de Fibra

250.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
    Criar Ordem de Agendamento Voip V2

250.08 - Validar a Notificação da Criação da Ordem (OS) via MicroServiços
    [TAGS]                                  SCRIPT_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.NotificationCreatedOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<                                      XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.NotificationCreatedOrder'])[1]
               
250.09 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Cliente_idContrato}               

    @{RETORNO}=                             Create List                             associatedDocument                      subscriberId                            

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

250.10 - Validar OS de Instalação via FSL
    [TAGS]                                  SCRIPT_A
    Validar Atribuicao Automatica Voip

XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

250.11/13/15 - Encerrar o SA via OPM
    [TAGS]                                  SCRIPT_B
    Colocar SA em execucao
    Validar Atribuicao Automatica Voip
    Close Browser                           CURRENT
    Colocar SA concluida VOIP               adicionarMaterial=SIM                   adicionarAuxilio=SIM

250.12/14/16 - Validar Mudança de Status via Micro Serviços
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY                    

    Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
 
250.17 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas

250.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

250.19 - Validar a Notificação de Encerramento via Microserviços (SOM)
    [TAGS]                                  SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e VOIP OI<

#===========================================================================================================================================================================================================

250.01 - Gerar Token de Acesso 
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Token Vtal

250.02 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_COMPLETO
    Consulta Logradouro CPOi

250.03 - Realizar Consulta de Complemento
    [TAGS]                                  SCRIPT_COMPLETO
    Id Consulta Complemento

250.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_COMPLETO
    Retorna Viabilidade dos Produtos

250.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Slot Agendamento V2            productType=Banda Larga,VoIP

250.06 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_COMPLETO
    Realizar Agendamento V2                 appointmentReason=Instalacao de Fibra

250.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_COMPLETO
    Criar Ordem de Agendamento Voip V2

250.08 - Validar a Notificação da Criação da Ordem (OS) via MicroServiços
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.NotificationCreatedOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<
               
250.09 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Cliente_idContrato}               

    @{RETORNO}=                             Create List                             associatedDocument                      subscriberId                            

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

250.10 - Validar OS de Instalação via FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Atribuicao Automatica Voip

XX.XX - Atualização da data de agendamento via API
    [TAGS]                                  SCRIPT_COMPLETO
    Reagendar Pedido OPM e FSL              activityType=4936

XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

250.11/13/15 - Encerrar o SA via OPM
    [TAGS]                                  SCRIPT_COMPLETO
    Colocar SA em execucao
    Validar Atribuicao Automatica Voip
    Close Browser                           CURRENT
    Colocar SA concluida VOIP               adicionarMaterial=SIM                   adicionarAuxilio=SIM

250.12/14/16 - Validar Mudança de Status via Micro Serviços
    [TAGS]                                  SCRIPT_COMPLETO
#     ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY

#     Validar Mudancas de Estado FW Voip      associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name
    
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=//*[text()="INVOKE - Request enviado ao API Gateway [/api/productOrdering/v1/listener/productOrderStateChangeEvent]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Encerramento<


250.17 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_COMPLETO
    Auditoria de Tarefas

250.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

250.19 - Validar a Notificação de Encerramento via Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e Insucesso para VOIP OI<















